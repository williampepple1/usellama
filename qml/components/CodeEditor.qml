import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama

Rectangle {
    id: editorRoot
    color: Theme.bgPrimary

    property string currentFilePath: ""
    property bool modified: false

    function loadFile(path, content) {
        currentFilePath = path
        editorText.text = content
        modified = false
        let ext = path.split('.').pop()
        highlighter.fileExtension = ext
    }

    function clearEditor() {
        currentFilePath = ""
        editorText.text = ""
        modified = false
    }

    function getText() {
        return editorText.text
    }

    SyntaxHighlighter {
        id: highlighter
        document: editorText.textDocument
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgPrimary
        visible: currentFilePath.length === 0

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Theme.spacingMd

            Text {
                text: "UseLlama"
                font.pixelSize: 36
                font.bold: true
                color: Theme.bgActive
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Open a file from the explorer to start editing"
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.textMuted
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0
        visible: currentFilePath.length > 0

        Rectangle {
            id: lineNumbers
            Layout.fillHeight: true
            Layout.preferredWidth: 56
            color: Theme.bgSecondary

            Column {
                y: -editorFlick.contentY
                width: parent.width

                Repeater {
                    model: editorText.text.split('\n').length

                    Text {
                        width: lineNumbers.width - Theme.spacingSm
                        height: editorMetrics.height
                        text: (index + 1).toString()
                        font.family: Theme.monoFont
                        font.pixelSize: AppSettings.fontSize
                        color: (index + 1) === currentLine() ? Theme.textPrimary : Theme.textMuted
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter

                        function currentLine() {
                            let pos = editorText.cursorPosition
                            let textBefore = editorText.text.substring(0, pos)
                            return textBefore.split('\n').length
                        }
                    }
                }
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: Theme.border
        }

        Flickable {
            id: editorFlick
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: editorText.paintedWidth + Theme.spacingXl
            contentHeight: editorText.paintedHeight + Theme.spacingXl
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

            function ensureVisible(r) {
                if (contentX >= r.x)
                    contentX = r.x
                else if (contentX + width <= r.x + r.width)
                    contentX = r.x + r.width - width
                if (contentY >= r.y)
                    contentY = r.y
                else if (contentY + height <= r.y + r.height)
                    contentY = r.y + r.height - height
            }

            TextEdit {
                id: editorText
                width: Math.max(editorFlick.width, paintedWidth + Theme.spacingXl)
                height: Math.max(editorFlick.height, paintedHeight + Theme.spacingXl)
                font.family: Theme.monoFont
                font.pixelSize: AppSettings.fontSize
                color: Theme.textPrimary
                selectionColor: Theme.accent
                selectedTextColor: Theme.textInverse
                wrapMode: TextEdit.NoWrap
                tabStopDistance: 4 * editorMetrics.averageCharacterWidth
                padding: Theme.spacingSm
                selectByMouse: true

                onCursorRectangleChanged: editorFlick.ensureVisible(cursorRectangle)
                onTextChanged: {
                    if (editorRoot.currentFilePath.length > 0)
                        editorRoot.modified = true
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
                        if (currentFilePath.length > 0) {
                            FileSystemManager.writeFile(currentFilePath, editorText.text)
                            editorRoot.modified = false
                        }
                        event.accepted = true
                    }
                }
            }
        }
    }

    FontMetrics {
        id: editorMetrics
        font.family: Theme.monoFont
        font.pixelSize: AppSettings.fontSize
    }
}
