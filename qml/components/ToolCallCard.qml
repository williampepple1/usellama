import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: toolCard
    radius: Theme.radiusMd
    color: Theme.bgTertiary
    border.color: Theme.border
    border.width: 1

    property string toolName: ""
    property string toolArgs: ""
    property string toolResult: ""
    property bool expanded: false

    implicitHeight: cardLayout.implicitHeight + Theme.spacingMd * 2
    implicitWidth: parent ? parent.width : 300

    ColumnLayout {
        id: cardLayout
        anchors.fill: parent
        anchors.margins: Theme.spacingMd
        spacing: Theme.spacingSm

        RowLayout {
            spacing: Theme.spacingSm

            Rectangle {
                width: 24
                height: 24
                radius: Theme.radiusSm
                color: Theme.accentMuted

                Text {
                    anchors.centerIn: parent
                    text: "\u2692"
                    font.pixelSize: 12
                }
            }

            Text {
                text: toolCard.toolName
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.accent
                Layout.fillWidth: true
            }

            Text {
                text: toolCard.expanded ? "\u25B2" : "\u25BC"
                font.pixelSize: 10
                color: Theme.textMuted

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toolCard.expanded = !toolCard.expanded
                }
            }
        }

        ColumnLayout {
            visible: toolCard.expanded
            spacing: Theme.spacingXs
            Layout.fillWidth: true

            Text {
                text: "Arguments:"
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.textMuted
                visible: toolCard.toolArgs.length > 0
            }

            Rectangle {
                Layout.fillWidth: true
                height: argsText.implicitHeight + Theme.spacingSm * 2
                radius: Theme.radiusSm
                color: Theme.bgSecondary
                visible: toolCard.toolArgs.length > 0

                TextEdit {
                    id: argsText
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSm
                    text: toolCard.toolArgs
                    font.family: Theme.monoFont
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                    readOnly: true
                    selectByMouse: true
                }
            }

            Text {
                text: "Result:"
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.textMuted
                visible: toolCard.toolResult.length > 0
            }

            Rectangle {
                Layout.fillWidth: true
                height: Math.min(resultText.implicitHeight + Theme.spacingSm * 2, 200)
                radius: Theme.radiusSm
                color: Theme.bgSecondary
                clip: true
                visible: toolCard.toolResult.length > 0

                Flickable {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSm
                    contentHeight: resultText.implicitHeight
                    clip: true

                    TextEdit {
                        id: resultText
                        width: parent.width
                        text: toolCard.toolResult
                        font.family: Theme.monoFont
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.syntaxString
                        wrapMode: Text.Wrap
                        readOnly: true
                        selectByMouse: true
                    }
                }
            }
        }
    }
}
