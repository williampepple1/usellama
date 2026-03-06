import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: welcomeRoot
    color: Theme.bgTertiary

    signal openFolder()
    signal openFile()
    signal openRecent(string path)

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacingXl
        width: Math.min(parent.width * 0.6, 600)

        Item { Layout.preferredHeight: 40 }

        Text {
            text: "UseLlama"
            font.pixelSize: 48
            font.bold: true
            color: Theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Agentic AI IDE powered by Ollama"
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.textSecondary
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
            Layout.topMargin: Theme.spacingMd
            Layout.bottomMargin: Theme.spacingMd
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacingLg

            Rectangle {
                width: 56
                height: 56
                radius: Theme.radiusMd
                color: connectionIndicator.containsMouse ? Theme.bgHover : Theme.bgSurface
                border.color: OllamaClient.connected ? Theme.success : Theme.error
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: OllamaClient.connected ? "\u2713" : "\u2717"
                    font.pixelSize: 24
                    color: OllamaClient.connected ? Theme.success : Theme.error
                }

                MouseArea {
                    id: connectionIndicator
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: OllamaClient.checkConnection()
                    cursorShape: Qt.PointingHandCursor
                }
            }

            ColumnLayout {
                spacing: 2
                Text {
                    text: OllamaClient.connected ? "Ollama Connected" : "Ollama Not Connected"
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: OllamaClient.connected ? Theme.success : Theme.error
                }
                Text {
                    text: OllamaClient.connected
                          ? OllamaClient.availableModels.length + " model(s) available"
                          : "Click to retry connection"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textMuted
                }
                Text {
                    text: AppSettings.hasApiKey ? "\u{1F511} API key configured" : "\u{1F513} No API key (local mode)"
                    font.pixelSize: Theme.fontSizeSmall
                    color: AppSettings.hasApiKey ? Theme.info : Theme.textMuted
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
            Layout.topMargin: Theme.spacingMd
            Layout.bottomMargin: Theme.spacingMd
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacingMd

            Button {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48
                text: "Open Folder"
                font.pixelSize: Theme.fontSizeLarge

                background: Rectangle {
                    radius: Theme.radiusMd
                    color: parent.hovered ? Theme.accentHover : Theme.accent
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Theme.textInverse
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: welcomeRoot.openFolder()
            }

            Button {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48
                text: "Open File"
                font.pixelSize: Theme.fontSizeLarge

                background: Rectangle {
                    radius: Theme.radiusMd
                    color: parent.hovered ? Theme.bgHover : Theme.bgSurface
                    border.color: Theme.accent
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Theme.accent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: welcomeRoot.openFile()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            visible: WorkspaceManager.recentWorkspaces.length > 0

            Text {
                text: "Recent Workspaces"
                font.pixelSize: Theme.fontSizeNormal
                font.bold: true
                color: Theme.textSecondary
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                model: WorkspaceManager.recentWorkspaces

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: Theme.radiusSm
                    color: recentHover.containsMouse ? Theme.bgHover : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.spacingMd
                        anchors.rightMargin: Theme.spacingMd
                        spacing: Theme.spacingSm

                        Text {
                            text: "\uD83D\uDCC1"
                            font.pixelSize: 16
                        }

                        ColumnLayout {
                            spacing: 0
                            Layout.fillWidth: true
                            Text {
                                text: WorkspaceManager.workspaceName(modelData)
                                font.pixelSize: Theme.fontSizeNormal
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: modelData
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.textMuted
                                elide: Text.ElideMiddle
                                Layout.fillWidth: true
                            }
                        }

                        Button {
                            text: "\u2715"
                            flat: true
                            font.pixelSize: 12
                            visible: recentHover.containsMouse
                            onClicked: WorkspaceManager.removeFromRecent(modelData)
                            background: Rectangle {
                                color: parent.hovered ? Theme.bgActive : "transparent"
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

                    MouseArea {
                        id: recentHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: welcomeRoot.openRecent(modelData)
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
