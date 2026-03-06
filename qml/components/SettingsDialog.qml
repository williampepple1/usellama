import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Dialog {
    id: settingsRoot
    title: "Settings"
    anchors.centerIn: parent
    width: 560
    height: 720
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    background: Rectangle {
        color: Theme.bgSurface
        radius: Theme.radiusLg
        border.color: Theme.border
    }

    onOpened: {
        urlField.text = AppSettings.ollamaUrl
        apiKeyField.text = AppSettings.apiKey
        fontSizeSpinner.value = AppSettings.fontSize
        temperatureSlider.value = AppSettings.temperature
        contextLengthField.text = AppSettings.contextLength.toString()
    }

    onAccepted: {
        AppSettings.ollamaUrl = urlField.text
        AppSettings.apiKey = apiKeyField.text.trim()
        AppSettings.fontSize = fontSizeSpinner.value
        AppSettings.temperature = temperatureSlider.value
        AppSettings.contextLength = parseInt(contextLengthField.text) || 8192
        OllamaClient.checkConnection()
    }

    contentItem: Flickable {
        contentHeight: settingsColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        ColumnLayout {
            id: settingsColumn
            width: parent.width
            spacing: Theme.spacingLg

            Text {
                text: "Appearance"
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.textPrimary
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSm

                Text {
                    text: "Color Theme"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    columnSpacing: Theme.spacingSm
                    rowSpacing: Theme.spacingSm

                    Repeater {
                        model: Theme.themeNames

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            radius: Theme.radiusMd
                            color: Theme._schemes[modelData].bgPrimary
                            border.width: AppSettings.colorTheme === modelData ? 2 : 1
                            border.color: AppSettings.colorTheme === modelData
                                          ? Theme._schemes[modelData].accent
                                          : Theme._schemes[modelData].border

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Row {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 3

                                    Repeater {
                                        model: [
                                            Theme._schemes[modelData].accent,
                                            Theme._schemes[modelData].success,
                                            Theme._schemes[modelData].warning,
                                            Theme._schemes[modelData].error
                                        ]

                                        Rectangle {
                                            width: 8
                                            height: 8
                                            radius: 4
                                            color: modelData
                                        }
                                    }
                                }

                                Text {
                                    text: Theme.themeLabels[modelData]
                                    font.pixelSize: 10
                                    color: Theme._schemes[modelData].textPrimary
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.width: 2
                                border.color: Theme._schemes[modelData].accent
                                visible: AppSettings.colorTheme === modelData
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: AppSettings.colorTheme = modelData
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.border
            }

            Text {
                text: "Ollama Connection"
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.textPrimary
            }

            RowLayout {
                spacing: Theme.spacingSm
                Layout.fillWidth: true

                Text {
                    text: "URL:"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                    Layout.preferredWidth: 120
                }

                TextField {
                    id: urlField
                    Layout.fillWidth: true
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textPrimary
                    placeholderText: "http://localhost:11434"
                    placeholderTextColor: Theme.textMuted
                    background: Rectangle {
                        color: Theme.bgSecondary
                        radius: Theme.radiusSm
                        border.color: urlField.activeFocus ? Theme.borderFocused : Theme.border
                    }
                }
            }

            RowLayout {
                spacing: Theme.spacingSm
                Layout.fillWidth: true

                Text {
                    text: "API Key:"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                    Layout.preferredWidth: 120
                }

                TextField {
                    id: apiKeyField
                    Layout.fillWidth: true
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textPrimary
                    placeholderText: "Leave blank for local Ollama"
                    placeholderTextColor: Theme.textMuted
                    echoMode: apiKeyVisible ? TextInput.Normal : TextInput.Password
                    background: Rectangle {
                        color: Theme.bgSecondary
                        radius: Theme.radiusSm
                        border.color: apiKeyField.activeFocus ? Theme.borderFocused : Theme.border
                    }

                    property bool apiKeyVisible: false
                }

                Button {
                    text: apiKeyField.apiKeyVisible ? "\u{1F441}" : "\u{1F512}"
                    flat: true
                    implicitWidth: 32
                    implicitHeight: 32
                    onClicked: apiKeyField.apiKeyVisible = !apiKeyField.apiKeyVisible
                    ToolTip.visible: hovered
                    ToolTip.text: apiKeyField.apiKeyVisible ? "Hide API key" : "Show API key"
                    background: Rectangle {
                        color: parent.hovered ? Theme.bgHover : "transparent"
                        radius: Theme.radiusSm
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: Theme.textMuted
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Text {
                text: "Required for Ollama Cloud or remote servers that use Bearer token auth."
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.leftMargin: 124
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.border
            }

            Text {
                text: "Editor"
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.textPrimary
            }

            RowLayout {
                spacing: Theme.spacingSm
                Layout.fillWidth: true

                Text {
                    text: "Font Size:"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                    Layout.preferredWidth: 120
                }

                SpinBox {
                    id: fontSizeSpinner
                    from: 8
                    to: 32
                    value: 14
                    editable: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.border
            }

            Text {
                text: "Model"
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.textPrimary
            }

            RowLayout {
                spacing: Theme.spacingSm
                Layout.fillWidth: true

                Text {
                    text: "Temperature:"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                    Layout.preferredWidth: 120
                }

                Slider {
                    id: temperatureSlider
                    Layout.fillWidth: true
                    from: 0.0
                    to: 2.0
                    stepSize: 0.1
                    value: 0.7
                }

                Text {
                    text: temperatureSlider.value.toFixed(1)
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textPrimary
                    Layout.preferredWidth: 30
                }
            }

            RowLayout {
                spacing: Theme.spacingSm
                Layout.fillWidth: true

                Text {
                    text: "Context Length:"
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textSecondary
                    Layout.preferredWidth: 120
                }

                TextField {
                    id: contextLengthField
                    Layout.fillWidth: true
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textPrimary
                    placeholderText: "8192"
                    placeholderTextColor: Theme.textMuted
                    inputMethodHints: Qt.ImhDigitsOnly
                    background: Rectangle {
                        color: Theme.bgSecondary
                        radius: Theme.radiusSm
                        border.color: contextLengthField.activeFocus ? Theme.borderFocused : Theme.border
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
