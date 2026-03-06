cmake_minimum_required(VERSION 3.16)

project(usellama VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets Network)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appusellama
    main.cpp
    src/core/OllamaClient.cpp
    src/core/FileSystemManager.cpp
    src/core/SyntaxHighlighter.cpp
    src/core/AgentEngine.cpp
    src/core/AgentTools.cpp
    src/core/TerminalProcess.cpp
    src/core/WorkspaceManager.cpp
    src/core/Settings.cpp
    src/models/FileTreeModel.cpp
    src/models/ChatHistoryModel.cpp
    src/models/ModelListModel.cpp
)

qt_add_qml_module(appusellama
    URI usellama
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/theme/Theme.qml
        qml/components/CodeEditor.qml
        qml/components/FileExplorer.qml
        qml/components/ChatPanel.qml
        qml/components/TerminalView.qml
        qml/components/EditorTabBar.qml
        qml/components/StatusBar.qml
        qml/components/SettingsDialog.qml
        qml/components/WelcomeScreen.qml
        qml/components/ToolCallCard.qml
        qml/components/MessageBubble.qml
    SOURCES
        src/core/OllamaClient.h
        src/core/FileSystemManager.h
        src/core/SyntaxHighlighter.h
        src/core/AgentEngine.h
        src/core/AgentTools.h
        src/core/TerminalProcess.h
        src/core/WorkspaceManager.h
        src/core/Settings.h
        src/models/ChatMessage.h
        src/models/FileTreeModel.h
        src/models/ChatHistoryModel.h
        src/models/ModelListModel.h
)

set_target_properties(appusellama PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appusellama
    PRIVATE
        Qt6::Quick
        Qt6::Widgets
        Qt6::Network
)

include(GNUInstallDirs)
install(TARGETS appusellama
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
