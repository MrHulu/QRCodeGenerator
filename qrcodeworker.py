from abc import abstractmethod
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

# 透明背景
class TransparentBackground(BackgroundStrategy):
    def __init__(self, parent=None):
        BackgroundStrategy.__init__(self)

    def apply(self, img):
        return img.convert("RGBA")

# 图片背景
class ImageBackground(BackgroundStrategy):
    def __init__(self, path, parent=None):
        BackgroundStrategy.__init__(self)
        self._path = path

    def apply(self, img):
        background = Image.open(self._path).resize(img.size)
        return Image.alpha_composite(background.convert("RGBA"), img.convert("RGBA"))
    
    def get_path(self):
        return self._path
    
    def set_path(self, path):
        self._path = path
        self._pathChanged.emit()

    pathChanged = pyqtSignal()
    path = pyqtProperty(str, get_path, set_path, notify=pathChanged)

# 渐变背景
class GradientBackground(BackgroundStrategy):
    def __init__(self, colors):
        BackgroundStrategy.__init__(self)
        self._colors = colors

    def apply(self, img):
        gradient = Image.new('RGBA', img.size, color=0)
        draw = ImageDraw.Draw(gradient)
        for i, color in enumerate(self._colors):
            draw.rectangle(
                [0, i*img.size[1]//len(self._colors), 
                 img.size[0], (i+1)*img.size[1]//len(self._colors)],
                fill=color)
        return Image.alpha_composite(gradient, img.convert("RGBA"))
    
    def get_colors(self):
        return self._colors
    
    def set_colors(self, colors):
        self._colors = colors
        self.colorsChanged.emit()

    colorsChanged = pyqtSignal()
    colors = pyqtProperty(list, get_colors, set_colors, notify=colorsChanged)
    

    