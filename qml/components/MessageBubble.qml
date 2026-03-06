import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Rectangle {
    id: bubble
    radius: Theme.radiusMd
    color: {
        switch (roleType) {
        case 0: return Theme.bgHover       // User
        case 1: return Theme.bgSurface     // Assistant
        case 3: return "#3b1d2e"           // Error
        default: return "transparent"
        }
    }

    property int roleType: 0
    property string content: ""
    property bool isStreaming: false

    implicitHeight: contentLayout.implicitHeight + Theme.spacingMd * 2
    implicitWidth: parent ? parent.width : 300

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Theme.spacingMd
        spacing: Theme.spacingXs

        RowLayout {
            spacing: Theme.spacingSm

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: roleType === 0 ? Theme.accent : Theme.syntaxKeyword

                Text {
                    anchors.centerIn: parent
                    text: roleType === 0 ? "U" : "A"
                    font.pixelSize: 12
                    font.bold: true
                    color: Theme.textInverse
                }
            }

            Text {
                text: {
                    switch (roleType) {
                    case 0: return "You"
                    case 1: return "UseLlama"
                    case 3: return "Error"
                    default: return ""
                    }
                }
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.textSecondary
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: Theme.accent
                visible: bubble.isStreaming
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    running: bubble.isStreaming
                    NumberAnimation { to: 0.3; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }
        }

        TextEdit {
            Layout.fillWidth: true
            text: bubble.content
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: roleType === 3 ? Theme.error : Theme.textPrimary
            wrapMode: Text.Wrap
            readOnly: true
            selectByMouse: true
            textFormat: Text.MarkdownText
        }
    }
}
