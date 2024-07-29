import qrcodegenrator
import qrcodeworker
from PyQt5.QtCore import QCoreApplication
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType, qmlRegisterUncreatableType
from PyQt5.QtWidgets import QApplication
import resources_rc
import sys

if __name__ == "__main__":
    try:
        QCoreApplication.setOrganizationName("Hulu")
        QCoreApplication.setOrganizationDomain("https://github.com/MrHulu")
        QCoreApplication.setApplicationName("二维码生成解释器")

        app = QApplication(sys.argv)
        engine = QQmlApplicationEngine()
        qrcode_genrator = qrcodegenrator.QrcodeGenerator()

        qmlRegisterUncreatableType(qrcodeworker.BackgroundStrategy, 'Qrcodeworker', 1, 0, 'BackgroundStrategy', "Cannot create a BackgroundStrategy object")
        qmlRegisterType(qrcodeworker.GradientBackground, 'Qrcodeworker', 1, 0, 'GradientBackground')
        qmlRegisterType(qrcodeworker.ImageBackground, 'Qrcodeworker', 1, 0, 'ImageBackground')
        qmlRegisterType(qrcodeworker.TransparentBackground, 'Qrcodeworker', 1, 0, 'TransparentBackground')

        engine.rootContext().setContextProperty("qrcodegenrator", qrcode_genrator)
        engine.load('app/main.qml')

        app.exec_()
    except Exception as e:
            print(f"An error occurred: {e}")
            import traceback
            traceback.print_exc()
