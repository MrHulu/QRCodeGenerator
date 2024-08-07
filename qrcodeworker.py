from abc import abstractmethod
from qrcode.image.styledpil import StyledPilImage
from qrcode.image.styles.moduledrawers import *
from qrcode.image.styles.colormasks import *
from PIL import Image, ImageDraw
from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot
from PyQt5.QtGui import QColor

'''
    模块绘制器策略
    1. SquareModuleDrawer: 方形模块绘制器
    2. RoundedModuleDrawer: 圆角模块绘制器
    3. GappedSquareModuleDrawer: 间隔方形模块绘制器
    4. CircleModuleDrawer: 圆形模块绘制器
    5. VerticalBarsDrawer: 垂直条纹绘制器
    6. HorizontalBarsDrawer: 水平条纹绘制器
'''
class ModuleDrawerFactory:
    @staticmethod
    def get_drawer(style):
        drawers = {
            "square": SquareModuleDrawer(),
            "round": RoundedModuleDrawer(),
            "gapped": GappedSquareModuleDrawer(),
            "circle": CircleModuleDrawer(),
            "vertical": VerticalBarsDrawer(),
            "horizontal": HorizontalBarsDrawer()
        }
        return drawers.get(style, SquareModuleDrawer())


'''
    前景色策略
'''
class ForegroundMaskFactory():
    
    @staticmethod
    def get_mask(foregrounds, background = QColor("#FFFFFFFF")):
        try:
            # 检查background是否是QColor类型
            temp_background = (255, 255, 255)        
            if isinstance(background, QColor):
                temp_background = (background.red(), background.green(), background.blue())

            # 检查foregrounds中的颜色是否是QColor类型
            temp = []
            for color in foregrounds:
                if isinstance(color, QColor):
                    temp.append(tuple([color.red(), color.green(), color.blue()]))
                elif isinstance(color, str):
                    temp.append(tuple([QColor(color).red(), QColor(color).green(), QColor(color).blue()])) if QColor(color).isValid() else print("Invalid color: ", color)
            if len(temp) == 1:
                return SolidFillColorMask(front_color=temp[0], back_color=temp_background)
            elif len(temp) > 1:
                return RadialGradiantColorMask(center_color=temp[0], edge_color=temp[1], back_color=temp_background)
            else:
                raise Exception("default")
        except Exception as e:
            print("Error: ", e)
            return SolidFillColorMask()

'''
    背景色策略
'''
# 背景策略抽象类
class BackgroundStrategy(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self)
    @abstractmethod
    def apply(self, img):
        pass

    def eliminateBackground(self, img, embedded_image_path=None):
        if isinstance(img, StyledPilImage) == False:
            return img
        if embedded_image_path is None:
            img = img.convert("RGBA")
            datas = img.getdata()
            newData = []
            for item in datas:
                if item[0] == 255 and item[1] == 255 and item[2] == 255:
                    newData.append((255, 255, 255, 0))  # 完全透明
                else:
                    newData.append(item)  # 不透明的黑色
        else:
            # 打开嵌入图像
            embedded_img = Image.open(embedded_image_path)
            # 获取嵌入图像的位置和大小
            embed_pos = ((img.size[0] - embedded_img.size[0]) // 2,
                        (img.size[1] - embedded_img.size[1]) // 2)
            embed_size = embedded_img.size
            width, height = img.size
            for i in range(height):
                for j in range(width):
                    index = i * width + j
                    item = datas[index]
                    
                    # 检查像素是否在嵌入图像区域内
                    if (embed_pos[0] <= j < embed_pos[0] + embed_size[0] and
                        embed_pos[1] <= i < embed_pos[1] + embed_size[1]):
                        newData.append(item)  # 保持嵌入图像区域不变
                    elif item[0] == 255 and item[1] == 255 and item[2] == 255:
                        newData.append((255, 255, 255, 0))  # 将 QR 码的白色背景变为透明
                    else:
                        newData.append(item)  # 保持其他颜色不变
        img.putdata(newData)
        return img
    
    dataChanged = pyqtSignal()

# 透明背景
class TransparentBackground(BackgroundStrategy):
    def __init__(self, parent=None):
        BackgroundStrategy.__init__(self)

    def apply(self, img):
        if isinstance(img, StyledPilImage) == False:
            return img

        return self.eliminateBackground(img)

# 图片背景
class ImageBackground(BackgroundStrategy):
    def __init__(self, path=None, parent=None):
        BackgroundStrategy.__init__(self)
        self._path = path
        self.pathChanged.connect(lambda: self.dataChanged.emit())

    def apply(self, img):
        if self._path is None or self._path == "":
            return img
        background = Image.open(self._path).resize(img.size)
        # 消除背景
        img = self.eliminateBackground(img)
        
        # 取反
        img_mask = Image.new('L', img.size)
        img = img.convert("RGBA")
        datas = img.getdata()
        mask_data = []
        for item in datas:
            if item[3] != 0:
                mask_data.append(0)  # 黑：透明
            else:
                mask_data.append((255))  # 白：不透明
        img_mask.putdata(mask_data)
        img.paste(background, None, img_mask)
        return img
    
    def get_path(self):
        return self._path
    
    def set_path(self, path):
        self._path = path
        self.pathChanged.emit()

    pathChanged = pyqtSignal()
    path = pyqtProperty(str, get_path, set_path, notify=pathChanged)

# 渐变背景
class GradientBackground(BackgroundStrategy):
    def __init__(self, colors):
        BackgroundStrategy.__init__(self)
        self._colors = colors
        self.colorsChanged.connect(lambda: self.dataChanged.emit())

    def _ensure_rgba(self, color):
        """确保颜色是RGBA格式"""
        if isinstance(color, str):
            # 如果是颜色名称，转换为RGB
            from PIL import ImageColor
            color = ImageColor.getrgb(color)
        if isinstance(color, QColor):
            color = (color.red(), color.green(), color.blue(), color.alpha())
        if isinstance(color, tuple):
            if len(color) == 3:
                color = color + (255,)
        return color 

    def apply(self, img):
        size = img.size
        color1 = self._ensure_rgba(self._colors[0]) if len(self._colors) > 0 else (255, 255, 255, 255)
        color2 = self._ensure_rgba(self._colors[1]) if len(self._colors) > 1 else (0, 0, 0, 255)
        base = Image.new('RGBA', size, color1)
        top = Image.new('RGBA', size, color2)
        mask_data = []
        mask = Image.new('L', size)
        
        direction = 'horizontal'
        if direction == 'horizontal':
            for y in range(size[1]):
                for x in range(size[0]):
                    mask_data.append(int(255 * (x / size[0])))
        else:  # vertical
            for y in range(size[1]):
                for x in range(size[0]):
                    mask_data.append(int(255 * (y / size[1])))
        
        mask.putdata(mask_data)
        base.paste(top, (0, 0), mask)

        # 消除背景
        img = self.eliminateBackground(img)

        # 取反
        img_mask = Image.new('L', size)
        img = img.convert("RGBA")
        datas = img.getdata()
        mask_data.clear()
        for item in datas:
            if item[3] != 0:
                mask_data.append(0)  # 黑：透明
            else:
                mask_data.append((255))  # 白：不透明
        img_mask.putdata(mask_data)
        img_mask.show()

        img.paste(base, None, img_mask)
        img.show()
        return img
        
    
    def get_colors(self):
        return self._colors
    
    def set_colors(self, colors):
        self._colors = colors
        self.colorsChanged.emit()

    colorsChanged = pyqtSignal()
    colors = pyqtProperty(list, get_colors, set_colors, notify=colorsChanged)
    

    