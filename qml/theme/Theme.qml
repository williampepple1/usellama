pragma Singleton
import QtQuick

QtObject {
    // Background layers
    readonly property color bgPrimary: "#1e1e2e"
    readonly property color bgSecondary: "#181825"
    readonly property color bgTertiary: "#11111b"
    readonly property color bgSurface: "#252536"
    readonly property color bgHover: "#313244"
    readonly property color bgActive: "#45475a"

    // Text
    readonly property color textPrimary: "#cdd6f4"
    readonly property color textSecondary: "#a6adc8"
    readonly property color textMuted: "#6c7086"
    readonly property color textInverse: "#1e1e2e"

    // Accent
    readonly property color accent: "#89b4fa"
    readonly property color accentHover: "#74c7ec"
    readonly property color accentMuted: "#45475a"

    // Semantic
    readonly property color success: "#a6e3a1"
    readonly property color warning: "#f9e2af"
    readonly property color error: "#f38ba8"
    readonly property color info: "#89dceb"

    // Syntax highlighting
    readonly property color syntaxKeyword: "#cba6f7"
    readonly property color syntaxString: "#a6e3a1"
    readonly property color syntaxNumber: "#fab387"
    readonly property color syntaxComment: "#6c7086"
    readonly property color syntaxFunction: "#89b4fa"
    readonly property color syntaxType: "#f9e2af"
    readonly property color syntaxOperator: "#89dceb"
    readonly property color syntaxVariable: "#cdd6f4"

    // Borders
    readonly property color border: "#313244"
    readonly property color borderFocused: "#89b4fa"

    // Typography
    readonly property string fontFamily: "Segoe UI"
    readonly property string monoFont: "Cascadia Code, Consolas, monospace"
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeNormal: 13
    readonly property int fontSizeLarge: 15
    readonly property int fontSizeTitle: 20
    readonly property int fontSizeHeader: 28

    // Spacing
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
    readonly property int spacingXxl: 32

    // Radii
    readonly property int radiusSm: 4
    readonly property int radiusMd: 8
    readonly property int radiusLg: 12

    // Layout
    readonly property int sidebarWidth: 260
    readonly property int chatPanelWidth: 380
    readonly property int statusBarHeight: 28
    readonly property int tabBarHeight: 36
}
