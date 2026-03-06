import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: fileExplorerRoot
    color: Theme.bgSecondary

    signal fileSelected(string filePath)

    property string currentDir: FileSystemManager.rootPath

    ListModel {
        id: fileModel
    }

    function loadDirectory(dirPath) {
        fileModel.clear()
        if (!dirPath || dirPath.length === 0)
            return

        var entries = FileSystemManager.listDirectory(dirPath)
        for (var i = 0; i < entries.length; i++) {
            var entry = entries[i]
            var isDir = entry.startsWith("[DIR] ")
            var name = isDir ? entry.substring(6) : entry
            var fullPath = dirPath + "/" + name
            fileModel.append({
                "name": name,
                "fullPath": fullPath,
                "isDir": isDir
            })
        }
    }

    Connections {
        target: FileSystemManager
        function onRootPathChanged() {
            currentDir = FileSystemManager.rootPath
            loadDirectory(currentDir)
        }
    }

    Component.onCompleted: {
        if (currentDir && currentDir.length > 0)
            loadDirectory(currentDir)
    }

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
                    text: "\u2191"
                    flat: true
                    implicitWidth: 24
                    implicitHeight: 24
                    font.pixelSize: 14
                    visible: currentDir !== FileSystemManager.rootPath
                    onClicked: {
                        var parts = currentDir.replace(/\\/g, "/").split("/")
                        parts.pop()
                        var parent = parts.join("/")
                        if (parent.length >= FileSystemManager.rootPath.length) {
                            currentDir = parent
                            loadDirectory(currentDir)
                        }
                    }
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

                Button {
                    text: "\u21BB"
                    flat: true
                    implicitWidth: 24
                    implicitHeight: 24
                    font.pixelSize: 14
                    onClicked: loadDirectory(currentDir)
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
            height: 24
            color: Theme.bgSecondary
            visible: currentDir !== FileSystemManager.rootPath

            Text {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMd
                text: {
                    var rel = currentDir.replace(FileSystemManager.rootPath, "")
                    if (rel.startsWith("/") || rel.startsWith("\\"))
                        rel = rel.substring(1)
                    return rel || "/"
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
                elide: Text.ElideLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

        ListView {
            id: fileListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: fileModel
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: Rectangle {
                width: fileListView.width
                height: 28
                color: delegateHover.containsMouse ? Theme.bgHover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacingMd
                    anchors.rightMargin: Theme.spacingSm
                    spacing: Theme.spacingXs

                    Text {
                        text: {
                            if (model.isDir) return "\uD83D\uDCC1"
                            return fileIcon(model.name)
                        }
                        font.pixelSize: 12

                        function fileIcon(name) {
                            var ext = name.split('.').pop().toLowerCase()
                            if (["js","ts","jsx","tsx"].indexOf(ext) >= 0) return "\u{1F7E1}"
                            if (["py"].indexOf(ext) >= 0) return "\u{1F7E2}"
                            if (["cpp","c","h","hpp"].indexOf(ext) >= 0) return "\u{1F535}"
                            if (["qml"].indexOf(ext) >= 0) return "\u{1F7E3}"
                            if (["json"].indexOf(ext) >= 0) return "\u{1F7E0}"
                            if (["md","txt","rst"].indexOf(ext) >= 0) return "\u{1F4C4}"
                            if (["html","css","scss"].indexOf(ext) >= 0) return "\u{1F7E0}"
                            return "\u{1F4C3}"
                        }
                    }

                    Text {
                        text: model.name
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: model.isDir
                        color: model.isDir ? Theme.accent : Theme.textPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    id: delegateHover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (model.isDir) {
                            currentDir = model.fullPath
                            loadDirectory(model.fullPath)
                        } else {
                            fileExplorerRoot.fileSelected(model.fullPath)
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
    }
}
