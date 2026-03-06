import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Popup {
    id: quickOpen
    width: 500
    height: 400
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0

    signal fileChosen(string filePath)

    property var allFiles: []

    function populateFiles() {
        allFiles = scanDirectory(FileSystemManager.rootPath, "", 0)
        filterModel()
        searchField.text = ""
        searchField.forceActiveFocus()
    }

    function scanDirectory(basePath, relativePath, depth) {
        if (depth > 8) return []
        let results = []
        let fullPath = relativePath.length > 0 ? basePath + "/" + relativePath : basePath
        let entries = FileSystemManager.listDirectory(fullPath)
        for (let i = 0; i < entries.length; i++) {
            let entry = entries[i]
            if (entry.startsWith("[DIR] ")) {
                let dirName = entry.substring(6)
                if (dirName.startsWith(".") || dirName === "node_modules" ||
                    dirName === "build" || dirName === "__pycache__") continue
                let subPath = relativePath.length > 0 ? relativePath + "/" + dirName : dirName
                results = results.concat(scanDirectory(basePath, subPath, depth + 1))
            } else {
                let filePath = relativePath.length > 0 ? relativePath + "/" + entry : entry
                results.push(filePath)
            }
        }
        return results
    }

    function filterModel() {
        let query = searchField.text.toLowerCase()
        filteredModel.clear()

        let maxResults = 50
        let count = 0

        for (let i = 0; i < allFiles.length && count < maxResults; i++) {
            let file = allFiles[i]
            if (query.length === 0 || file.toLowerCase().includes(query)) {
                filteredModel.append({filePath: file})
                count++
            }
        }
    }

    onOpened: populateFiles()

    background: Rectangle {
        color: Theme.bgSurface
        radius: Theme.radiusLg
        border.color: Theme.borderFocused
        border.width: 2
    }

    contentItem: ColumnLayout {
        spacing: 0

        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.textPrimary
            placeholderText: "Search files by name..."
            placeholderTextColor: Theme.textMuted
            leftPadding: Theme.spacingMd

            background: Rectangle {
                color: Theme.bgSecondary
                radius: Theme.radiusLg
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: parent.radius
                    color: parent.color
                }
            }

            onTextChanged: filterModel()

            Keys.onDownPressed: {
                fileList.currentIndex = Math.min(fileList.currentIndex + 1, filteredModel.count - 1)
            }
            Keys.onUpPressed: {
                fileList.currentIndex = Math.max(fileList.currentIndex - 1, 0)
            }
            Keys.onReturnPressed: {
                if (fileList.currentIndex >= 0 && fileList.currentIndex < filteredModel.count) {
                    let item = filteredModel.get(fileList.currentIndex)
                    let fullPath = FileSystemManager.rootPath + "/" + item.filePath
                    quickOpen.fileChosen(fullPath)
                    quickOpen.close()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        ListView {
            id: fileList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ListModel { id: filteredModel }
            clip: true
            currentIndex: 0

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Rectangle {
                width: fileList.width
                height: 32
                color: index === fileList.currentIndex ? Theme.bgHover :
                       delegateMouse.containsMouse ? Theme.bgActive : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacingMd
                    anchors.rightMargin: Theme.spacingMd
                    spacing: Theme.spacingSm

                    Text {
                        text: {
                            let parts = model.filePath.split('/')
                            return parts[parts.length - 1]
                        }
                        font.pixelSize: Theme.fontSizeNormal
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: model.filePath
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textMuted
                        elide: Text.ElideMiddle
                        Layout.maximumWidth: 250
                    }
                }

                MouseArea {
                    id: delegateMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        let fullPath = FileSystemManager.rootPath + "/" + model.filePath
                        quickOpen.fileChosen(fullPath)
                        quickOpen.close()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 28
            color: Theme.bgTertiary
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.parent.children[0].background.radius
                color: parent.color
            }

            Text {
                anchors.centerIn: parent
                text: filteredModel.count + " file(s) found"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
            }
        }
    }
}
