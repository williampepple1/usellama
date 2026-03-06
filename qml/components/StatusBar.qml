import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: statusBarRoot
    width: parent ? parent.width : 0
    height: Theme.statusBarHeight
    anchors.bottom: parent ? parent.bottom : undefined
    color: Theme.accent
    z: 100

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingMd
        spacing: Theme.spacingLg

        Text {
            text: {
                if (OllamaClient.connected)
                    return "\u25CF Connected"
                return "\u25CB Disconnected"
            }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.textInverse
        }

        Text {
            text: OllamaClient.currentModel || "No model"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.textInverse
        }

        Item { Layout.fillWidth: true }

        Text {
            text: AgentEngine.running ? "\u26A1 Agent Running" : ""
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            color: Theme.textInverse
            visible: AgentEngine.running
        }

        Text {
            text: "UseLlama v1.0.0"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.textInverse
            opacity: 0.8
        }
    }
}
