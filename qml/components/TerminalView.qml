import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: terminalRoot
    color: Theme.bgTertiary

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: Theme.bgSecondary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingSm
                spacing: Theme.spacingSm

                Text {
                    text: "TERMINAL"
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    color: Theme.textMuted
                    font.letterSpacing: 1
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: TerminalProcess.running ? "\u25CF Running" : "\u25CB Idle"
                    font.pixelSize: Theme.fontSizeSmall
                    color: TerminalProcess.running ? Theme.success : Theme.textMuted
                }

                Button {
                    text: "\u2715"
                    flat: true
                    implicitWidth: 22
                    implicitHeight: 22
                    font.pixelSize: 10
                    visible: TerminalProcess.running
                    onClicked: TerminalProcess.killProcess()
                    background: Rectangle {
                        color: parent.hovered ? Theme.bgHover : "transparent"
                        radius: Theme.radiusSm
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.error
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: "\u239A"
                    flat: true
                    implicitWidth: 22
                    implicitHeight: 22
                    font.pixelSize: 12
                    onClicked: TerminalProcess.clearOutput()
                    ToolTip.visible: hovered
                    ToolTip.text: "Clear terminal"
                    background: Rectangle {
                        color: parent.hovered ? Theme.bgHover : "transparent"
                        radius: Theme.radiusSm
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.textMuted
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        Flickable {
            id: terminalFlick
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: terminalOutput.paintedHeight + Theme.spacingSm
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Connections {
                target: TerminalProcess
                function onOutputAppended() {
                    Qt.callLater(function() {
                        terminalFlick.contentY = Math.max(0, terminalFlick.contentHeight - terminalFlick.height)
                    })
                }
            }

            TextEdit {
                id: terminalOutput
                width: terminalFlick.width
                text: TerminalProcess.output
                font.family: Theme.monoFont
                font.pixelSize: AppSettings.fontSize - 1
                color: Theme.textPrimary
                wrapMode: TextEdit.Wrap
                readOnly: true
                selectByMouse: true
                padding: Theme.spacingSm
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            spacing: 0

            Text {
                text: " $ "
                font.family: Theme.monoFont
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.accent
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
            }

            TextField {
                id: terminalInput
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.family: Theme.monoFont
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.textPrimary
                placeholderText: "Enter command..."
                placeholderTextColor: Theme.textMuted

                background: Rectangle {
                    color: Theme.bgSecondary
                }

                onAccepted: {
                    if (text.trim().length > 0) {
                        TerminalProcess.executeCommand(text.trim())
                        text = ""
                    }
                }
            }
        }
    }
}
