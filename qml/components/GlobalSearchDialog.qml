import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Popup {
    id: searchDialog
    width: 600
    height: 500
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0

    signal resultSelected(string filePath)

    onOpened: searchField.forceActiveFocus()

    background: Rectangle {
        color: Theme.bgSurface
        radius: Theme.radiusLg
        border.color: Theme.borderFocused
        border.width: 2
    }

    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            spacing: 0

            TextField {
                id: searchField
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.textPrimary
                placeholderText: "Search in files..."
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

                onAccepted: performSearch()
            }

            Button {
                text: "Search"
                Layout.fillHeight: true
                Layout.preferredWidth: 80
                onClicked: performSearch()
                background: Rectangle {
                    color: parent.hovered ? Theme.accentHover : Theme.accent
                    radius: 0
                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        width: Theme.radiusLg
                        height: Theme.radiusLg
                        radius: Theme.radiusLg
                        color: parent.color
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: Theme.fontSizeNormal
                    color: Theme.textInverse
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        ListView {
            id: resultsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ListModel { id: resultsModel }
            clip: true

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Rectangle {
                width: resultsList.width
                height: resultContent.implicitHeight + Theme.spacingSm * 2
                color: resultMouse.containsMouse ? Theme.bgHover : "transparent"

                ColumnLayout {
                    id: resultContent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: Theme.spacingMd
                    spacing: 2

                    RowLayout {
                        spacing: Theme.spacingSm
                        Text {
                            text: model.file
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                            color: Theme.accent
                            elide: Text.ElideMiddle
                            Layout.fillWidth: true
                        }
                        Text {
                            text: ":" + model.lineNum
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textMuted
                        }
                    }

                    Text {
                        text: model.lineContent
                        font.family: Theme.monoFont
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    id: resultMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        searchDialog.resultSelected(model.file)
                        searchDialog.close()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 28
            color: Theme.bgTertiary

            Text {
                anchors.centerIn: parent
                text: resultsModel.count + " result(s)"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
            }
        }
    }

    function performSearch() {
        let query = searchField.text.trim()
        if (query.length === 0) return

        resultsModel.clear()
        let results = FileSystemManager.searchFiles(FileSystemManager.rootPath, query)
        for (let i = 0; i < results.length; i++) {
            let r = results[i]
            resultsModel.append({
                file: r.file,
                lineNum: r.line,
                lineContent: r.content
            })
        }
    }
}
