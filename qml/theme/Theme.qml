pragma Singleton
import QtQuick
import usellama

QtObject {
    property string currentTheme: AppSettings.colorTheme

    property color bgPrimary: _schemes[currentTheme].bgPrimary
    property color bgSecondary: _schemes[currentTheme].bgSecondary
    property color bgTertiary: _schemes[currentTheme].bgTertiary
    property color bgSurface: _schemes[currentTheme].bgSurface
    property color bgHover: _schemes[currentTheme].bgHover
    property color bgActive: _schemes[currentTheme].bgActive

    property color textPrimary: _schemes[currentTheme].textPrimary
    property color textSecondary: _schemes[currentTheme].textSecondary
    property color textMuted: _schemes[currentTheme].textMuted
    property color textInverse: _schemes[currentTheme].textInverse

    property color accent: _schemes[currentTheme].accent
    property color accentHover: _schemes[currentTheme].accentHover
    property color accentMuted: _schemes[currentTheme].accentMuted

    property color success: _schemes[currentTheme].success
    property color warning: _schemes[currentTheme].warning
    property color error: _schemes[currentTheme].error
    property color info: _schemes[currentTheme].info

    property color syntaxKeyword: _schemes[currentTheme].syntaxKeyword
    property color syntaxString: _schemes[currentTheme].syntaxString
    property color syntaxNumber: _schemes[currentTheme].syntaxNumber
    property color syntaxComment: _schemes[currentTheme].syntaxComment
    property color syntaxFunction: _schemes[currentTheme].syntaxFunction
    property color syntaxType: _schemes[currentTheme].syntaxType
    property color syntaxOperator: _schemes[currentTheme].syntaxOperator
    property color syntaxVariable: _schemes[currentTheme].syntaxVariable

    property color border: _schemes[currentTheme].border
    property color borderFocused: _schemes[currentTheme].borderFocused

    readonly property string fontFamily: "Segoe UI"
    readonly property string monoFont: "Cascadia Code, Consolas, monospace"
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeNormal: 13
    readonly property int fontSizeLarge: 15
    readonly property int fontSizeTitle: 20
    readonly property int fontSizeHeader: 28

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
    readonly property int spacingXxl: 32

    readonly property int radiusSm: 4
    readonly property int radiusMd: 8
    readonly property int radiusLg: 12

    readonly property int sidebarWidth: 260
    readonly property int chatPanelWidth: 380
    readonly property int statusBarHeight: 28
    readonly property int tabBarHeight: 36

    readonly property var themeNames: [
        "grey", "midnight", "emerald", "rose",
        "amber", "ocean", "purple", "light"
    ]

    readonly property var themeLabels: ({
        "grey": "Grey",
        "midnight": "Midnight Blue",
        "emerald": "Emerald",
        "rose": "Rose",
        "amber": "Amber",
        "ocean": "Ocean",
        "purple": "Purple",
        "light": "Light"
    })

    readonly property var _schemes: ({
        "grey": {
            bgPrimary:    "#1e1e1e",
            bgSecondary:  "#181818",
            bgTertiary:   "#121212",
            bgSurface:    "#252525",
            bgHover:      "#2e2e2e",
            bgActive:     "#3c3c3c",
            textPrimary:  "#d4d4d4",
            textSecondary:"#a0a0a0",
            textMuted:    "#6a6a6a",
            textInverse:  "#1e1e1e",
            accent:       "#0098ff",
            accentHover:  "#1aadff",
            accentMuted:  "#3c3c3c",
            success:      "#4ec995",
            warning:      "#e8b84a",
            error:        "#e05252",
            info:         "#4aacde",
            syntaxKeyword:"#c586c0",
            syntaxString: "#ce9178",
            syntaxNumber: "#b5cea8",
            syntaxComment:"#6a9955",
            syntaxFunction:"#dcdcaa",
            syntaxType:   "#4ec9b0",
            syntaxOperator:"#d4d4d4",
            syntaxVariable:"#9cdcfe",
            border:       "#333333",
            borderFocused:"#0098ff"
        },
        "midnight": {
            bgPrimary:    "#1e1e2e",
            bgSecondary:  "#181825",
            bgTertiary:   "#11111b",
            bgSurface:    "#252536",
            bgHover:      "#313244",
            bgActive:     "#45475a",
            textPrimary:  "#cdd6f4",
            textSecondary:"#a6adc8",
            textMuted:    "#6c7086",
            textInverse:  "#1e1e2e",
            accent:       "#89b4fa",
            accentHover:  "#74c7ec",
            accentMuted:  "#45475a",
            success:      "#a6e3a1",
            warning:      "#f9e2af",
            error:        "#f38ba8",
            info:         "#89dceb",
            syntaxKeyword:"#cba6f7",
            syntaxString: "#a6e3a1",
            syntaxNumber: "#fab387",
            syntaxComment:"#6c7086",
            syntaxFunction:"#89b4fa",
            syntaxType:   "#f9e2af",
            syntaxOperator:"#89dceb",
            syntaxVariable:"#cdd6f4",
            border:       "#313244",
            borderFocused:"#89b4fa"
        },
        "emerald": {
            bgPrimary:    "#1a2420",
            bgSecondary:  "#151f1b",
            bgTertiary:   "#101a16",
            bgSurface:    "#1f2f28",
            bgHover:      "#283d33",
            bgActive:     "#345545",
            textPrimary:  "#d0e0d6",
            textSecondary:"#8fb09e",
            textMuted:    "#5a7a6a",
            textInverse:  "#1a2420",
            accent:       "#34d399",
            accentHover:  "#6ee7b7",
            accentMuted:  "#345545",
            success:      "#34d399",
            warning:      "#fbbf24",
            error:        "#f87171",
            info:         "#67e8f9",
            syntaxKeyword:"#a78bfa",
            syntaxString: "#6ee7b7",
            syntaxNumber: "#fbbf24",
            syntaxComment:"#5a7a6a",
            syntaxFunction:"#34d399",
            syntaxType:   "#67e8f9",
            syntaxOperator:"#d0e0d6",
            syntaxVariable:"#93c5fd",
            border:       "#283d33",
            borderFocused:"#34d399"
        },
        "rose": {
            bgPrimary:    "#241a1e",
            bgSecondary:  "#1f1518",
            bgTertiary:   "#1a1013",
            bgSurface:    "#2d2024",
            bgHover:      "#3d2830",
            bgActive:     "#553545",
            textPrimary:  "#e8d5db",
            textSecondary:"#b09098",
            textMuted:    "#7a5a64",
            textInverse:  "#241a1e",
            accent:       "#f472b6",
            accentHover:  "#f9a8d4",
            accentMuted:  "#553545",
            success:      "#86efac",
            warning:      "#fde68a",
            error:        "#fca5a5",
            info:         "#a5f3fc",
            syntaxKeyword:"#f472b6",
            syntaxString: "#86efac",
            syntaxNumber: "#fde68a",
            syntaxComment:"#7a5a64",
            syntaxFunction:"#c084fc",
            syntaxType:   "#fda4af",
            syntaxOperator:"#e8d5db",
            syntaxVariable:"#a5b4fc",
            border:       "#3d2830",
            borderFocused:"#f472b6"
        },
        "amber": {
            bgPrimary:    "#1f1c16",
            bgSecondary:  "#1a1710",
            bgTertiary:   "#15120c",
            bgSurface:    "#29251a",
            bgHover:      "#362f20",
            bgActive:     "#4a4028",
            textPrimary:  "#e5dcc8",
            textSecondary:"#b0a688",
            textMuted:    "#7a7058",
            textInverse:  "#1f1c16",
            accent:       "#f59e0b",
            accentHover:  "#fbbf24",
            accentMuted:  "#4a4028",
            success:      "#84cc16",
            warning:      "#f59e0b",
            error:        "#ef4444",
            info:         "#38bdf8",
            syntaxKeyword:"#f59e0b",
            syntaxString: "#84cc16",
            syntaxNumber: "#fb923c",
            syntaxComment:"#7a7058",
            syntaxFunction:"#fbbf24",
            syntaxType:   "#38bdf8",
            syntaxOperator:"#e5dcc8",
            syntaxVariable:"#a3e635",
            border:       "#362f20",
            borderFocused:"#f59e0b"
        },
        "ocean": {
            bgPrimary:    "#0f172a",
            bgSecondary:  "#0c1322",
            bgTertiary:   "#080e1a",
            bgSurface:    "#152035",
            bgHover:      "#1e2d45",
            bgActive:     "#2a4060",
            textPrimary:  "#cbd5e1",
            textSecondary:"#8899b0",
            textMuted:    "#506680",
            textInverse:  "#0f172a",
            accent:       "#38bdf8",
            accentHover:  "#7dd3fc",
            accentMuted:  "#2a4060",
            success:      "#4ade80",
            warning:      "#facc15",
            error:        "#fb7185",
            info:         "#38bdf8",
            syntaxKeyword:"#818cf8",
            syntaxString: "#4ade80",
            syntaxNumber: "#facc15",
            syntaxComment:"#506680",
            syntaxFunction:"#38bdf8",
            syntaxType:   "#c084fc",
            syntaxOperator:"#cbd5e1",
            syntaxVariable:"#7dd3fc",
            border:       "#1e2d45",
            borderFocused:"#38bdf8"
        },
        "purple": {
            bgPrimary:    "#1e1628",
            bgSecondary:  "#1a1222",
            bgTertiary:   "#140e1c",
            bgSurface:    "#271d33",
            bgHover:      "#332646",
            bgActive:     "#463260",
            textPrimary:  "#ddd5e8",
            textSecondary:"#a898b8",
            textMuted:    "#706080",
            textInverse:  "#1e1628",
            accent:       "#a78bfa",
            accentHover:  "#c4b5fd",
            accentMuted:  "#463260",
            success:      "#86efac",
            warning:      "#fde68a",
            error:        "#fca5a5",
            info:         "#a5f3fc",
            syntaxKeyword:"#c084fc",
            syntaxString: "#86efac",
            syntaxNumber: "#fde68a",
            syntaxComment:"#706080",
            syntaxFunction:"#a78bfa",
            syntaxType:   "#f9a8d4",
            syntaxOperator:"#ddd5e8",
            syntaxVariable:"#93c5fd",
            border:       "#332646",
            borderFocused:"#a78bfa"
        },
        "light": {
            bgPrimary:    "#ffffff",
            bgSecondary:  "#f5f5f5",
            bgTertiary:   "#e8e8e8",
            bgSurface:    "#fafafa",
            bgHover:      "#eeeeee",
            bgActive:     "#dddddd",
            textPrimary:  "#1a1a1a",
            textSecondary:"#555555",
            textMuted:    "#999999",
            textInverse:  "#ffffff",
            accent:       "#0066cc",
            accentHover:  "#0080ee",
            accentMuted:  "#dddddd",
            success:      "#16a34a",
            warning:      "#ca8a04",
            error:        "#dc2626",
            info:         "#0284c7",
            syntaxKeyword:"#7c3aed",
            syntaxString: "#16a34a",
            syntaxNumber: "#c2410c",
            syntaxComment:"#999999",
            syntaxFunction:"#0066cc",
            syntaxType:   "#0891b2",
            syntaxOperator:"#1a1a1a",
            syntaxVariable:"#0284c7",
            border:       "#d4d4d4",
            borderFocused:"#0066cc"
        }
    })

    Connections {
        target: AppSettings
        function onColorThemeChanged() {
            currentTheme = AppSettings.colorTheme
        }
    }
}
