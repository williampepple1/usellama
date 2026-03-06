cmake_minimum_required(VERSION 3.16)

project(usellama VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets Network)

qt_standard_project_setup(REQUIRES 6.8)

set(PROJECT_SOURCES
    main.cpp
    src/core/OllamaClient.h
    src/core/OllamaClient.cpp
    src/core/FileSystemManager.h
    src/core/FileSystemManager.cpp
    src/core/SyntaxHighlighter.h
    src/core/SyntaxHighlighter.cpp
    src/core/AgentEngine.h
    src/core/AgentEngine.cpp
    src/core/AgentTools.h
    src/core/AgentTools.cpp
    src/core/TerminalProcess.h
    src/core/TerminalProcess.cpp
    src/core/WorkspaceManager.h
    src/core/WorkspaceManager.cpp
    src/core/Settings.h
    src/core/Settings.cpp
    src/models/ChatMessage.h
    src/models/FileTreeModel.h
    src/models/FileTreeModel.cpp
    src/models/ChatHistoryModel.h
    src/models/ChatHistoryModel.cpp
    src/models/ModelListModel.h
    src/models/ModelListModel.cpp
)

if (WIN32)
    list(APPEND PROJECT_SOURCES app_icon.rc)
endif()

qt_add_executable(appusellama ${PROJECT_SOURCES})

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
        qml/components/QuickOpenDialog.qml
        qml/components/GlobalSearchDialog.qml
    SOURCES
        src/core/SyntaxHighlighter.h
        src/core/SyntaxHighlighter.cpp
)

set_target_properties(appusellama PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appusellama PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core
    ${CMAKE_CURRENT_SOURCE_DIR}/src/models
)

target_link_libraries(appusellama
    PRIVATE
        Qt6::Quick
        Qt6::Widgets
        Qt6::Network
        Qt6::Gui
)

include(GNUInstallDirs)
install(TARGETS appusellama
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
