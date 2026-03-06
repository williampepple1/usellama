import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import usellama
import "../theme"

Rectangle {
    id: tabBarRoot
    color: Theme.bgTertiary

    signal tabSelected(string filePath)
    signal tabClosed(string filePath)

    property var openTabs: []
    property string activeTab: ""

    function addTab(filePath) {
        let tabs = openTabs
        if (tabs.indexOf(filePath) === -1) {
            tabs.push(filePath)
            openTabs = tabs
        }
        activeTab = filePath
    }

    function removeTab(filePath) {
        let tabs = openTabs
        let idx = tabs.indexOf(filePath)
        if (idx >= 0) {
            tabs.splice(idx, 1)
            openTabs = tabs
            if (activeTab === filePath) {
                activeTab = tabs.length > 0 ? tabs[Math.max(0, idx - 1)] : ""
                if (activeTab.length > 0) tabSelected(activeTab)
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        Row {
            spacing: 0
            height: parent.height

            Repeater {
                model: tabBarRoot.openTabs

                Rectangle {
                    width: tabContent.implicitWidth + Theme.spacingXl * 2
                    height: tabBarRoot.height
                    color: modelData === tabBarRoot.activeTab ? Theme.bgPrimary : (tabMouse.containsMouse ? Theme.bgHover : Theme.bgTertiary)
                    border.width: modelData === tabBarRoot.activeTab ? 0 : 0

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: Theme.accent
                        visible: modelData === tabBarRoot.activeTab
                    }

                    RowLayout {
                        id: tabContent
                        anchors.centerIn: parent
                        spacing: Theme.spacingSm

                        Text {
                            text: FileSystemManager.fileName(modelData)
                            font.pixelSize: Theme.fontSizeSmall
                            color: modelData === tabBarRoot.activeTab ? Theme.textPrimary : Theme.textSecondary
                        }

                        Text {
                            text: "\u2715"
                            font.pixelSize: 10
                            color: closeArea.containsMouse ? Theme.textPrimary : Theme.textMuted
                            visible: tabMouse.containsMouse || modelData === tabBarRoot.activeTab

                            MouseArea {
                                id: closeArea
                                anchors.fill: parent
                                anchors.margins: -4
                                hoverEnabled: true
                                onClicked: {
                                    tabBarRoot.removeTab(modelData)
                                    tabBarRoot.tabClosed(modelData)
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: tabMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            tabBarRoot.activeTab = modelData
                            tabBarRoot.tabSelected(modelData)
                        }
                    }
                }
            }
        }
    }
}
