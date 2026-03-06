import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Dialog {
    id: settingsRoot
    title: "Settings"
    anchors.centerIn: parent
    width: 500
    height: 520
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    background: Rectangle {
        color: Theme.bgSurface
        radius: Theme.radiusLg
        border.color: Theme.border
    }

    onOpened: {
        urlField.text = AppSettings.ollamaUrl
        fontSizeSpinner.value = AppSettings.fontSize
        temperatureSlider.value = AppSettings.temperature
        contextLengthField.text = AppSettings.contextLength.toString()
    }

    onAccepted: {
        AppSettings.ollamaUrl = urlField.text
        AppSettings.fontSize = fontSizeSpinner.value
        AppSettings.temperature = temperatureSlider.value
        AppSettings.contextLength = parseInt(contextLengthField.text) || 8192
        OllamaClient.checkConnection()
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacingLg

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
