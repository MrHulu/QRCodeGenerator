import qrcode
from qrcode.image.styledpil import StyledPilImage
import tempfile
import os
import qrcodeworker
from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot
# from PySide6.QtCore import QObject, Slot, Property, Signal
# from PySide6.QtConcurrent import *
from PyQt5.QtGui import QColor
from PIL import Image


class QrcodeGenerator(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self)
        self._ready = False
        self._backgroundStrategy = None
        self._foreground_colors = [ "#FF000000" ]
        self._background_colors = [ "#FFFFFFFF" ]
        self._error_correction = qrcode.constants.ERROR_CORRECT_L
        self.qr = qrcode.QRCode(error_correction=self._error_correction)
        self.qr.clear()
        self.img = None
        self._icon = ""
        self._data = ""
        self._moduledrawer_type = "square"
        # 所以的set的信号都会触发set_ready(False)
        self.dataChanged.connect(lambda: self.set_ready(False))
        self.errorCorrectionChanged.connect(lambda: self.set_ready(False))
        self.moduledrawerTypeChanged.connect(lambda: self.set_ready(False))
        self.iconChanged.connect(lambda: self.set_ready(False))
        self.backgroundStrategyChanged.connect(lambda: self.set_ready(False))
        self.foregroundColorsChanged.connect(lambda: self.set_ready(False))
        self.backgroundColorsChanged.connect(lambda: self.set_ready(False))


    # 清理
    def clear(self):
        self._backgroundStrategy = None
        self._foreground_colors = [ "#FF000000" ]
        self._background_colors = [ "#FFFFFFFF" ]
        self._error_correction = qrcode.constants.ERROR_CORRECT_L
        self.qr = qrcode.QRCode(error_correction=self._error_correction)
        self.qr.clear()
        self.set_moduledrawer_type("square")
        self.set_data("")
        self.img = None
        self._icon = ""

    # 生成
    @pyqtSlot()
    def generate(self):
        if self._data == "":
            print("Error: No data to generate")
            return
        self.set_ready(False)
        qrcode.QRCode(error_correction=self._error_correction)
        self.qr.make(fit=True)
        self.img = self.qr.make_image(image_factory=StyledPilImage,
            module_drawer=qrcodeworker.ModuleDrawerFactory.get_drawer(self._moduledrawer_type),
            color_mask=qrcodeworker.ForegroundMaskFactory.get_mask(
                self._foreground_colors, 
                self._background_colors[0] if self._backgroundStrategy is None else QColor("#FFFFFFFF")),
            embeded_image = None if self._icon == "" else self._icon
        )
        if self._backgroundStrategy is not None:
            temp = self.img
            self.img = self._backgroundStrategy.apply(temp)
        dir = tempfile.gettempdir() + "/Hulu"
        os.makedirs(dir, exist_ok=True)
        file = f"{dir}/temp.png"
        if os.path.exists(file): os.remove(file)

        self.img.save(file)
        self.set_ready(True)

    # 保存
    @pyqtSlot(str)
    def save(self, path):
        if self.img is not None:
            self.img.save(path)
        else:
            print("Error: No image to save")
        
    # 修改中
    def get_ready(self):
        return self._ready
    def set_ready(self, value):
        self._ready = value
        self.isBusyChanged.emit()
    isBusyChanged = pyqtSignal()
    ready = pyqtProperty(bool, get_ready, set_ready, notify=isBusyChanged)

    # 内容
    def get_data(self):
        return self._data
    
    def set_data(self, value):
        self.qr.clear() 
        self._data = ""
        if(value != ""):
            self._data = value
            self.qr.add_data(value)
        self.dataChanged.emit()

    dataChanged = pyqtSignal()
    data = pyqtProperty(str, get_data, set_data, notify=dataChanged)

    ''' 选项 '''
    # 质量
    def get_error_correction(self):
        return self._error_correction
    
    def set_error_correction(self, value):
        self._error_correction = value
        self.errorCorrectionChanged.emit()

    errorCorrectionChanged = pyqtSignal()
    error_correction = pyqtProperty(int, get_error_correction, set_error_correction, notify=errorCorrectionChanged)

    ''' 设计 '''
    # 绘制类型
    def get_moduledrawer_type(self):
        return self._moduledrawer_type
    
    def set_moduledrawer_type(self, value):
        self._moduledrawer_type = value
        self.moduledrawerTypeChanged.emit()

    moduledrawerTypeChanged = pyqtSignal()
    moduledrawer_type = pyqtProperty(str, get_moduledrawer_type, set_moduledrawer_type, notify=moduledrawerTypeChanged)

    # 图标
    def get_icon(self):
        return self._icon
    def set_icon(self, value):
        # 检查value是否是一个图片文件路径
        self._icon = value
        self.iconChanged.emit()

    iconChanged = pyqtSignal()
    icon = pyqtProperty(str, get_icon, set_icon, notify=iconChanged)

    ''' 颜色 '''
    # 背景策略
    def get_backgroundStrategy(self):
        return self._backgroundStrategy
    
    def set_backgroundStrategy(self, value):
        if isinstance(value, qrcodeworker.BackgroundStrategy) or value is None:
            self._backgroundStrategy = value
            print("Background set successfully: ", value)
            self.backgroundStrategyChanged.emit()
            if value is not None:
                self.backgroundStrategy.dataChanged.connect(lambda: self.set_ready(False))
        else:
            print(f"Error: Invalid type. Expected BackgroundStrategy, got {type(value)}")

    backgroundStrategyChanged = pyqtSignal()
    backgroundStrategy = pyqtProperty(qrcodeworker.BackgroundStrategy, get_backgroundStrategy, set_backgroundStrategy, notify=backgroundStrategyChanged)

    # 前景色
    def get_foreground_colors(self):
        return self._foreground_colors
    
    def set_foreground_colors(self, value):
        if isinstance(value, list) and len(value) > 0:
            temp = []
            for (i, color) in enumerate(value):
                if isinstance(color, QColor):
                    temp.append(color)
                elif isinstance(color, str):
                    temp.append(QColor(color)) if QColor(color).isValid() else print(f"Error: Invalid color at index {i}")
            if len(temp) >  0:
                self._foreground_colors = temp
                print("Foreground colors set successfully: ", [str(color.name()) for color in temp])
                self.foregroundColorsChanged.emit()
        else:
            print(f"Error: Invalid type. Expected list, got {type(value)}")
    
    foregroundColorsChanged = pyqtSignal()
    foreground_colors = pyqtProperty(list, get_foreground_colors, set_foreground_colors, notify=foregroundColorsChanged)

    # 背景色
    def get_background_colors(self):
        return self._background_colors
    
    def set_background_colors(self, value):
        if isinstance(value, list) and len(value) > 0:
            temp = []
            for (i, color) in enumerate(value):
                if isinstance(color, QColor):
                    temp.append(color)
                elif isinstance(color, str):
                    temp.append(QColor(color)) if QColor(color).isValid() else print(f"Error: Invalid color at index {i}")
            if len(temp) >  0:
                self._background_colors = temp
                print("Background colors set successfully: ", [str(color.name()) for color in temp])
                self.backgroundColorsChanged.emit()
        else:
            print(f"Error: Invalid type. Expected list, got {type(value)}")
    
    backgroundColorsChanged = pyqtSignal()
    background_colors = pyqtProperty(list, get_background_colors, set_background_colors, notify=backgroundColorsChanged)


            