import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Rectangle {
    id: fileExplorerRoot
    color: Theme.bgSecondary

    signal fileSelected(string filePath)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: Theme.bgTertiary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                anchors.rightMargin: Theme.spacingSm
                spacing: Theme.spacingSm

                Text {
                    text: "EXPLORER"
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    color: Theme.textMuted
                    Layout.fillWidth: true
                    font.letterSpacing: 1
                }

                Button {
                    text: "\u21BB"
                    flat: true
                    implicitWidth: 24
                    implicitHeight: 24
                    font.pixelSize: 14
                    onClicked: FileTreeModel.setRootDirectory(FileSystemManager.rootPath)
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

        TreeView {
            id: treeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: FileTreeModel
            rootIndex: FileTreeModel.rootModelIndex()
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: TreeViewDelegate {
                id: treeDelegate
                implicitHeight: 28
                implicitWidth: treeView.width

                contentItem: RowLayout {
                    spacing: Theme.spacingXs

                    Text {
                        text: {
                            if (model.isDirectory !== undefined && model.isDirectory)
                                return treeDelegate.expanded ? "\u25BE" : "\u25B8"
                            return fileIcon(model.fileName || "")
                        }
                        font.pixelSize: 12
                        color: {
                            if (model.isDirectory !== undefined && model.isDirectory)
                                return Theme.accent
                            return Theme.textMuted
                        }

                        function fileIcon(name) {
                            let ext = name.split('.').pop().toLowerCase()
                            if (["js","ts","jsx","tsx"].includes(ext)) return "\u{1F7E1}"
                            if (["py"].includes(ext)) return "\u{1F7E2}"
                            if (["cpp","c","h","hpp"].includes(ext)) return "\u{1F535}"
                            if (["qml"].includes(ext)) return "\u{1F7E3}"
                            if (["json"].includes(ext)) return "\u{1F7E0}"
                            if (["md","txt"].includes(ext)) return "\u{1F4C4}"
                            return "\u{1F4C3}"
                        }
                    }

                    Text {
                        text: model.fileName || ""
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                background: Rectangle {
                    color: treeDelegate.hovered ? Theme.bgHover :
                           treeDelegate.current ? Theme.bgActive : "transparent"
                }

                onClicked: {
                    if (model.isDirectory !== undefined && !model.isDirectory) {
                        let path = FileTreeModel.filePath(treeView.index(row, 0))
                        fileExplorerRoot.fileSelected(path)
                    }
                }
            }
        }
    }
}
