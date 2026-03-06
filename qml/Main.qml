import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import usellama
import "theme"
import "components"

ApplicationWindow {
    id: root
    width: 1440
    height: 900
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: workspacePath.length > 0 ? "UseLlama — " + workspacePath : "UseLlama"
    color: Theme.bgTertiary

    property string workspacePath: ""
    property bool showWelcome: workspacePath.length === 0
    property bool showChat: true
    property bool showTerminal: false

    Component.onCompleted: {
        OllamaClient.checkConnection()
    }

    FolderDialog {
        id: folderDialog
        title: "Open Workspace Folder"
        onAccepted: {
            let path = selectedFolder.toString()
            if (Qt.platform.os === "windows") {
                path = path.replace("file:///", "")
            } else {
                path = path.replace("file://", "")
            }
            root.workspacePath = path
            FileSystemManager.setRootPath(path)
            WorkspaceManager.openWorkspace(path)
        }
    }

    menuBar: MenuBar {
        palette.window: Theme.bgSecondary
        palette.windowText: Theme.textPrimary
        palette.highlight: Theme.accent
        palette.highlightedText: Theme.textInverse

        Menu {
            title: "&File"
            Action {
                text: "&Open Folder..."
                shortcut: "Ctrl+O"
                onTriggered: folderDialog.open()
            }
            MenuSeparator {}
            Action {
                text: "&Settings"
                shortcut: "Ctrl+,"
                onTriggered: settingsDialog.open()
            }
            MenuSeparator {}
            Action {
                text: "&Exit"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: "&View"
            Action {
                text: showChat ? "Hide &Chat Panel" : "Show &Chat Panel"
                shortcut: "Ctrl+L"
                onTriggered: showChat = !showChat
            }
            Action {
                text: showTerminal ? "Hide &Terminal" : "Show &Terminal"
                shortcut: "Ctrl+`"
                onTriggered: showTerminal = !showTerminal
            }
        }
        Menu {
            title: "&Help"
            Action {
                text: "&About UseLlama"
                onTriggered: aboutDialog.open()
            }
        }
    }

    SettingsDialog {
        id: settingsDialog
    }

    Dialog {
        id: aboutDialog
        title: "About UseLlama"
        anchors.centerIn: parent
        width: 400
        height: 200
        modal: true
        standardButtons: Dialog.Ok

        background: Rectangle {
            color: Theme.bgSurface
            radius: Theme.radiusLg
            border.color: Theme.border
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingMd

            Text {
                text: "UseLlama"
                font.pixelSize: Theme.fontSizeHeader
                font.bold: true
                color: Theme.accent
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "An agentic AI IDE powered by Ollama"
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.textSecondary
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "Version 0.1"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    WelcomeScreen {
        id: welcomeScreen
        anchors.fill: parent
        visible: root.showWelcome
        z: 10
        onOpenFolder: folderDialog.open()
        onOpenRecent: function(path) {
            root.workspacePath = path
            FileSystemManager.setRootPath(path)
            WorkspaceManager.openWorkspace(path)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0
        visible: !root.showWelcome

        FileExplorer {
            id: fileExplorer
            Layout.preferredWidth: Theme.sidebarWidth
            Layout.fillHeight: true
            onFileSelected: function(filePath) {
                editorArea.openFile(filePath)
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: Theme.border
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                EditorTabBar {
                    id: tabBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.tabBarHeight
                    onTabSelected: function(filePath) {
                        editorArea.switchToFile(filePath)
                    }
                    onTabClosed: function(filePath) {
                        editorArea.closeFile(filePath)
                    }
                }

                CodeEditor {
                    id: editorArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    function openFile(path) {
                        let content = FileSystemManager.readFile(path)
                        tabBar.addTab(path)
                        editorArea.loadFile(path, content)
                    }

                    function switchToFile(path) {
                        let content = FileSystemManager.readFile(path)
                        editorArea.loadFile(path, content)
                    }

                    function closeFile(path) {
                        editorArea.clearEditor()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
                visible: root.showTerminal
                Layout.fillWidth: true
            }

            TerminalView {
                id: terminalView
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                visible: root.showTerminal
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: Theme.border
            visible: root.showChat
        }

        ChatPanel {
            id: chatPanel
            Layout.preferredWidth: Theme.chatPanelWidth
            Layout.fillHeight: true
            visible: root.showChat
            workspacePath: root.workspacePath
        }
    }

    StatusBar {
        id: statusBar
    }
}
