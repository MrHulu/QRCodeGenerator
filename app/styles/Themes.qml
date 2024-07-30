pragma Singleton
import QtQuick 2.15

QtObject {
    enum ThemeStyle {
        Light = 0,
        Dark
    }
    property int theme: Themes.ThemeStyle.Light
    property color primaryColor: "#FF66B8FF" //"#00c43d" 
    property color secondaryColor: "#00f54c"

    property color accent: theme === Themes.ThemeStyle.Light ? "#FF338BFF" : "#FF66B8FF"//"#006e22" : "00b739"
    property color background: theme === Themes.ThemeStyle.Light ? "#f8f8ff" : "#1B1B1F"
    property color foreground: theme === Themes.ThemeStyle.Light ? "#1B1B1F" : "#f8f8ff"
    property color shadow: theme === Themes.ThemeStyle.Light ? "#000000" : "#ffffff"
}