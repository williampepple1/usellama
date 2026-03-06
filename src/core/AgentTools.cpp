#include "AgentTools.h"
#include "FileSystemManager.h"
#include "TerminalProcess.h"

AgentTools::AgentTools(QObject *parent)
    : QObject(parent)
{
}

void AgentTools::setFileSystemManager(FileSystemManager *fsm)
{
    m_fsm = fsm;
}

void AgentTools::setTerminalProcess(TerminalProcess *tp)
{
    m_terminal = tp;
}

QJsonArray AgentTools::toolDefinitions() const
{
    QJsonArray tools;

    auto makeTool = [](const QString &name, const QString &desc, const QJsonObject &params) {
        QJsonObject tool;
        tool["type"] = "function";
        QJsonObject function;
        function["name"] = name;
        function["description"] = desc;
        function["parameters"] = params;
        tool["function"] = function;
        return tool;
    };

    auto makeParams = [](const QJsonObject &properties, const QJsonArray &required) {
        QJsonObject params;
        params["type"] = "object";
        params["properties"] = properties;
        params["required"] = required;
        return params;
    };

    auto stringProp = [](const QString &desc) {
        QJsonObject prop;
        prop["type"] = "string";
        prop["description"] = desc;
        return prop;
    };

    // read_file
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path to the file to read");
        tools.append(makeTool("read_file", "Read the contents of a file", makeParams(props, {"path"})));
    }

    // write_file
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path to the file to write");
        props["content"] = stringProp("Content to write to the file");
        tools.append(makeTool("write_file", "Create or overwrite a file with the given content", makeParams(props, {"path", "content"})));
    }

    // edit_file
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path to the file to edit");
        props["old_text"] = stringProp("The existing text to find and replace");
        props["new_text"] = stringProp("The replacement text");
        tools.append(makeTool("edit_file", "Replace a specific string in a file with new text", makeParams(props, {"path", "old_text", "new_text"})));
    }

    // list_directory
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path to the directory to list");
        tools.append(makeTool("list_directory", "List all files and directories in a given path", makeParams(props, {"path"})));
    }

    // delete_file
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path to the file or directory to delete");
        tools.append(makeTool("delete_file", "Delete a file or directory", makeParams(props, {"path"})));
    }

    // run_command
    {
        QJsonObject props;
        props["command"] = stringProp("The shell command to execute");
        tools.append(makeTool("run_command", "Execute a shell command and return its output", makeParams(props, {"command"})));
    }

    // search_files
    {
        QJsonObject props;
        props["directory"] = stringProp("Directory to search in");
        props["pattern"] = stringProp("Regular expression pattern to search for");
        tools.append(makeTool("search_files", "Search for a regex pattern across files in a directory", makeParams(props, {"directory", "pattern"})));
    }

    // create_directory
    {
        QJsonObject props;
        props["path"] = stringProp("Absolute path of the directory to create");
        tools.append(makeTool("create_directory", "Create a new directory (including parent directories)", makeParams(props, {"path"})));
    }

    return tools;
}

QString AgentTools::executeTool(const QString &name, const QJsonObject &arguments)
{
    QString result;
    if (name == "read_file")           result = readFile(arguments);
    else if (name == "write_file")     result = writeFile(arguments);
    else if (name == "edit_file")      result = editFile(arguments);
    else if (name == "list_directory")  result = listDirectory(arguments);
    else if (name == "delete_file")    result = deleteFile(arguments);
    else if (name == "run_command")    result = runCommand(arguments);
    else if (name == "search_files")   result = searchFiles(arguments);
    else if (name == "create_directory") result = createDirectory(arguments);
    else result = "Unknown tool: " + name;

    emit toolExecuted(name, arguments, result);
    return result;
}

QString AgentTools::readFile(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    QString content = m_fsm->readFile(path);
    if (content.isNull())
        return "Error: Could not read file: " + path;
    return content;
}

QString AgentTools::writeFile(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    QString content = args["content"].toString();
    if (m_fsm->writeFile(path, content))
        return "Successfully wrote to: " + path;
    return "Error: Could not write to: " + path;
}

QString AgentTools::editFile(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    QString oldText = args["old_text"].toString();
    QString newText = args["new_text"].toString();
    if (m_fsm->editFile(path, oldText, newText))
        return "Successfully edited: " + path;
    return "Error: Could not edit file (old text not found): " + path;
}

QString AgentTools::listDirectory(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    QStringList entries = m_fsm->listDirectory(path);
    if (entries.isEmpty())
        return "Directory is empty or does not exist: " + path;
    return entries.join("\n");
}

QString AgentTools::deleteFile(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    if (m_fsm->deleteFile(path))
        return "Successfully deleted: " + path;
    return "Error: Could not delete: " + path;
}

QString AgentTools::runCommand(const QJsonObject &args)
{
    if (!m_terminal) return "Error: Terminal not available";
    QString command = args["command"].toString();
    return m_terminal->runCommandSync(command);
}

QString AgentTools::searchFiles(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString directory = args["directory"].toString();
    QString pattern = args["pattern"].toString();
    QVariantList results = m_fsm->searchFiles(directory, pattern);
    if (results.isEmpty())
        return "No matches found for pattern: " + pattern;

    QStringList output;
    for (const QVariant &r : results) {
        QVariantMap m = r.toMap();
        output.append(QString("%1:%2: %3").arg(m["file"].toString())
                      .arg(m["line"].toInt()).arg(m["content"].toString()));
    }
    return output.join("\n");
}

QString AgentTools::createDirectory(const QJsonObject &args)
{
    if (!m_fsm) return "Error: File system not available";
    QString path = args["path"].toString();
    if (m_fsm->createDirectory(path))
        return "Successfully created directory: " + path;
    return "Error: Could not create directory: " + path;
}
