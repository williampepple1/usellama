import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: chatRoot
    color: Theme.bgSecondary

    property string workspacePath: ""
    property int currentAssistantIndex: -1

    Connections {
        target: AgentEngine
        function onAssistantToken(token) {
            if (chatRoot.currentAssistantIndex < 0) {
                chatRoot.currentAssistantIndex = ChatHistoryModel.addAssistantMessage("")
            }
            ChatHistoryModel.appendToAssistant(chatRoot.currentAssistantIndex, token)
        }
        function onToolCallStarted(name, args) {
            let argsStr = JSON.stringify(args, null, 2)
            ChatHistoryModel.addToolCall(name, argsStr, "")
        }
        function onToolCallFinished(name, result) {
            let count = ChatHistoryModel.count
            if (count > 0) {
                ChatHistoryModel.addToolCall(name, "", result)
            }
        }
        function onAgentFinished(fullResponse) {
            if (chatRoot.currentAssistantIndex >= 0) {
                ChatHistoryModel.finalizeAssistant(chatRoot.currentAssistantIndex)
            }
            chatRoot.currentAssistantIndex = -1
        }
        function onAgentError(error) {
            ChatHistoryModel.addErrorMessage(error)
            chatRoot.currentAssistantIndex = -1
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 44
            color: Theme.bgTertiary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingSm
                spacing: Theme.spacingSm

                Text {
                    text: "CHAT"
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    color: Theme.textMuted
                    font.letterSpacing: 1
                }

                Item { Layout.fillWidth: true }

                ComboBox {
                    id: modelSelector
                    Layout.preferredWidth: 150
                    model: OllamaClient.availableModels
                    currentIndex: {
                        let models = OllamaClient.availableModels
                        let current = OllamaClient.currentModel
                        for (let i = 0; i < models.length; i++) {
                            if (models[i] === current) return i
                        }
                        return 0
                    }
                    onActivated: function(index) {
                        OllamaClient.setCurrentModel(OllamaClient.availableModels[index])
                    }

                    background: Rectangle {
                        color: Theme.bgSurface
                        radius: Theme.radiusSm
                        border.color: Theme.border
                    }
                    contentItem: Text {
                        text: modelSelector.displayText
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textPrimary
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: Theme.spacingSm
                        elide: Text.ElideRight
                    }
                }

                Button {
                    text: "\u{1F5D1}"
                    flat: true
                    implicitWidth: 28
                    implicitHeight: 28
                    onClicked: {
                        ChatHistoryModel.clear()
                        AgentEngine.clearHistory()
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: "Clear chat"
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

        ListView {
            id: chatList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ChatHistoryModel
            clip: true
            spacing: Theme.spacingSm
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            onCountChanged: {
                Qt.callLater(function() {
                    chatList.positionViewAtEnd()
                })
            }

            header: Item { height: Theme.spacingSm }
            footer: Item { height: Theme.spacingSm }

            delegate: Item {
                width: chatList.width
                height: delegateLoader.height
                anchors.leftMargin: Theme.spacingSm
                anchors.rightMargin: Theme.spacingSm

                Loader {
                    id: delegateLoader
                    width: parent.width - Theme.spacingMd * 2
                    x: Theme.spacingMd

                    sourceComponent: {
                        if (model.roleType === 2) return toolCallComponent
                        return messageBubbleComponent
                    }
                }

                Component {
                    id: messageBubbleComponent
                    MessageBubble {
                        roleType: model.roleType
                        content: model.content
                        isStreaming: model.isStreaming
                    }
                }

                Component {
                    id: toolCallComponent
                    ToolCallCard {
                        toolName: model.toolName
                        toolArgs: model.toolArgs
                        toolResult: model.toolResult
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 120
            Layout.preferredHeight: Math.max(120, inputArea.implicitHeight + 70)
            Layout.maximumHeight: 250
            color: Theme.bgTertiary

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSm
                spacing: Theme.spacingSm

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 50

                    TextArea {
                        id: inputArea
                        placeholderText: OllamaClient.connected ? "Ask UseLlama anything..." : "Ollama not connected..."
                        font.pixelSize: Theme.fontSizeNormal
                        color: Theme.textPrimary
                        placeholderTextColor: Theme.textMuted
                        wrapMode: TextArea.Wrap
                        enabled: !AgentEngine.running && OllamaClient.connected

                        background: Rectangle {
                            color: Theme.bgSurface
                            radius: Theme.radiusMd
                            border.color: inputArea.activeFocus ? Theme.borderFocused : Theme.border
                        }

                        Keys.onReturnPressed: function(event) {
                            if (event.modifiers & Qt.ShiftModifier) {
                                event.accepted = false
                            } else {
                                sendMessage()
                                event.accepted = true
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingSm

                    Text {
                        text: AgentEngine.running ? "Agent is working..." : "Shift+Enter for new line"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textMuted
                        Layout.fillWidth: true
                    }

                    Button {
                        text: AgentEngine.running ? "Stop" : "Send"
                        implicitWidth: 70
                        implicitHeight: 30
                        font.pixelSize: Theme.fontSizeSmall
                        enabled: AgentEngine.running || (inputArea.text.trim().length > 0 && OllamaClient.connected)

                        background: Rectangle {
                            color: {
                                if (!parent.enabled) return Theme.bgActive
                                if (AgentEngine.running) return Theme.error
                                return parent.hovered ? Theme.accentHover : Theme.accent
                            }
                            radius: Theme.radiusSm
                        }

                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: parent.enabled ? Theme.textInverse : Theme.textMuted
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (AgentEngine.running) {
                                AgentEngine.cancelAgent()
                            } else {
                                sendMessage()
                            }
                        }
                    }
                }
            }
        }
    }

    function sendMessage() {
        let msg = inputArea.text.trim()
        if (msg.length === 0) return
        ChatHistoryModel.addUserMessage(msg)
        inputArea.text = ""
        chatRoot.currentAssistantIndex = -1
        AgentEngine.sendMessage(msg, chatRoot.workspacePath)
    }
}
