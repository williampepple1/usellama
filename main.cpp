#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "src/core/OllamaClient.h"
#include "src/core/FileSystemManager.h"
#include "src/core/SyntaxHighlighter.h"
#include "src/core/AgentEngine.h"
#include "src/core/AgentTools.h"
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

    auto *settings = new Settings(&app);
    auto *ollamaClient = new OllamaClient(&app);
    auto *fileSystemManager = new FileSystemManager(&app);
    auto *terminalProcess = new TerminalProcess(&app);
    auto *agentTools = new AgentTools(&app);
    auto *agentEngine = new AgentEngine(&app);
    auto *workspaceManager = new WorkspaceManager(&app);
    auto *fileTreeModel = new FileTreeModel(&app);
    auto *chatHistoryModel = new ChatHistoryModel(&app);
    auto *modelListModel = new ModelListModel(&app);

    agentTools->setFileSystemManager(fileSystemManager);
    agentTools->setTerminalProcess(terminalProcess);
    agentEngine->setOllamaClient(ollamaClient);
    agentEngine->setAgentTools(agentTools);

    ollamaClient->setBaseUrl(settings->ollamaUrl());
    ollamaClient->setApiKey(settings->apiKey());
    QObject::connect(settings, &Settings::ollamaUrlChanged, ollamaClient, [settings, ollamaClient]() {
        ollamaClient->setBaseUrl(settings->ollamaUrl());
    });
    QObject::connect(settings, &Settings::apiKeyChanged, ollamaClient, [settings, ollamaClient]() {
        ollamaClient->setApiKey(settings->apiKey());
    });
    QObject::connect(ollamaClient, &OllamaClient::availableModelsChanged, modelListModel, [ollamaClient, modelListModel]() {
        modelListModel->setModels(ollamaClient->availableModels());
    });
    QObject::connect(fileSystemManager, &FileSystemManager::rootPathChanged, fileTreeModel, [fileSystemManager, fileTreeModel]() {
        fileTreeModel->setRootDirectory(fileSystemManager->rootPath());
    });
    QObject::connect(fileSystemManager, &FileSystemManager::rootPathChanged, terminalProcess, [fileSystemManager, terminalProcess]() {
        terminalProcess->setWorkingDirectory(fileSystemManager->rootPath());
    });

    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance("usellama", 1, 0, "OllamaClient", ollamaClient);
    qmlRegisterSingletonInstance("usellama", 1, 0, "FileSystemManager", fileSystemManager);
    qmlRegisterSingletonInstance("usellama", 1, 0, "AgentEngine", agentEngine);
    qmlRegisterSingletonInstance("usellama", 1, 0, "AgentTools", agentTools);
    qmlRegisterSingletonInstance("usellama", 1, 0, "TerminalProcess", terminalProcess);
    qmlRegisterSingletonInstance("usellama", 1, 0, "WorkspaceManager", workspaceManager);
    qmlRegisterSingletonInstance("usellama", 1, 0, "AppSettings", settings);
    qmlRegisterSingletonInstance("usellama", 1, 0, "FileTreeModel", fileTreeModel);
    qmlRegisterSingletonInstance("usellama", 1, 0, "ChatHistoryModel", chatHistoryModel);
    qmlRegisterSingletonInstance("usellama", 1, 0, "ModelListModel", modelListModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("usellama", "Main");

    return app.exec();
}
