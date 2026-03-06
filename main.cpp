#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "src/core/OllamaClient.h"
#include "src/core/FileSystemManager.h"
#include "src/core/SyntaxHighlighter.h"
#include "src/core/AgentEngine.h"
#include "src/core/TerminalProcess.h"
#include "src/core/WorkspaceManager.h"
#include "src/core/Settings.h"
#include "src/models/FileTreeModel.h"
#include "src/models/ChatHistoryModel.h"
#include "src/models/ModelListModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("UseLlama");
    app.setOrganizationName("UseLlama");
    app.setApplicationVersion("0.1");

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("usellama", "Main");

    return app.exec();
}
