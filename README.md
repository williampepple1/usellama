# UseLlama

An agentic AI IDE desktop application powered exclusively by [Ollama](https://ollama.com) models. Think Cursor/Windsurf/Codex, but built from the ground up around Ollama — local and cloud.

## Features

- **Agentic AI assistant** — the AI can autonomously read, write, edit, and delete files, run shell commands, search your codebase, and create directories, all through Ollama's tool-calling API.
- **Custom code editor** — built-in editor with line numbers, syntax highlighting (C++, JavaScript/TypeScript, Python, QML), and tabbed editing.
- **File explorer** — full directory tree view of your workspace with file-type icons.
- **Integrated terminal** — run commands directly inside the IDE; the AI agent can use it too.
- **Streaming chat** — real-time token-by-token responses with tool call visualization.
- **Quick Open** (`Ctrl+P`) — fuzzy file search across your workspace.
- **Global Search** (`Ctrl+Shift+F`) — regex search across all files.
- **Workspace management** — recent projects, workspace persistence.
- **Ollama Cloud support** — configure a remote Ollama URL and API key for cloud-hosted models.
- **Auto-reconnect** — automatically detects and reconnects to Ollama.
- **Chat history** — save and load conversation history as JSON files.
- **Dark theme** — Catppuccin Mocha-inspired color scheme.

## Screenshots

*Coming soon.*

## Prerequisites

- **Qt 6.8+** (tested with Qt 6.10.1)
- **CMake 3.16+**
- **C++17 compiler** (MinGW 13+, MSVC 2022, GCC 12+, or Clang 15+)
- **Ninja** (recommended) or Make
- **Ollama** running locally or on a remote server

## Build

### Windows (MinGW)

```powershell
# Set up environment (adjust paths to your Qt installation)
$env:PATH = "C:\Qt\Tools\mingw1310_64\bin;C:\Qt\6.10.1\mingw_64\bin;C:\Qt\Tools\CMake_64\bin;C:\Qt\Tools\Ninja;$env:PATH"
$env:CMAKE_PREFIX_PATH = "C:\Qt\6.10.1\mingw_64"

# Configure and build
cmake -B build -G Ninja -DCMAKE_CXX_COMPILER=g++
cmake --build build

# Run
.\build\appusellama.exe
```

### Linux

```bash
# Install Qt 6 (Ubuntu/Debian)
sudo apt install qt6-base-dev qt6-declarative-dev qt6-tools-dev cmake ninja-build

# Configure and build
cmake -B build -G Ninja
cmake --build build

# Run
./build/appusellama
```

### macOS

```bash
# Install Qt 6 via Homebrew
brew install qt@6 cmake ninja

# Configure and build
export CMAKE_PREFIX_PATH=$(brew --prefix qt@6)
cmake -B build -G Ninja
cmake --build build

# Run
./build/appusellama.app/Contents/MacOS/appusellama
```

## Usage

1. **Start Ollama** — make sure `ollama serve` is running (or have a remote instance ready).
2. **Launch UseLlama** — run the built executable.
3. **Open a workspace** — click "Open Folder" on the welcome screen or use `Ctrl+O`.
4. **Chat with the AI** — type a message in the chat panel. The agent will use tools to read your code, make edits, run commands, and more.
5. **Configure settings** — press `Ctrl+,` to open settings where you can change the Ollama URL, API key, font size, temperature, and context length.

### Ollama Cloud / Remote Servers

To use a remote Ollama instance:

1. Open **Settings** (`Ctrl+,`)
2. Set the **URL** to your remote endpoint (e.g. `https://your-server.example.com`)
3. Enter your **API Key** (sent as `Authorization: Bearer <key>`)
4. Click **OK** — the app reconnects automatically

Leave the API key blank for local Ollama.

## Agent Tools

The AI assistant has access to these tools:

| Tool | Description |
|------|-------------|
| `read_file` | Read the contents of a file |
| `write_file` | Create or overwrite a file |
| `edit_file` | Find and replace text in a file |
| `list_directory` | List files and folders in a directory |
| `delete_file` | Delete a file or directory |
| `run_command` | Execute a shell command |
| `search_files` | Regex search across files in a directory |
| `create_directory` | Create a directory (including parents) |

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | Open folder |
| `Ctrl+P` | Quick open file |
| `Ctrl+Shift+F` | Search in files |
| `Ctrl+S` | Save current file |
| `Ctrl+L` | Toggle chat panel |
| `` Ctrl+` `` | Toggle terminal |
| `Ctrl+,` | Open settings |
| `Ctrl+Q` | Quit |

## Project Structure

```
usellama/
├── main.cpp                          Application entry point
├── CMakeLists.txt                    Build configuration
├── src/
│   ├── core/
│   │   ├── OllamaClient.h/cpp       Ollama REST API client (streaming)
│   │   ├── AgentEngine.h/cpp        Agentic tool-calling loop
│   │   ├── AgentTools.h/cpp         Tool implementations
│   │   ├── FileSystemManager.h/cpp  File I/O operations
│   │   ├── TerminalProcess.h/cpp    QProcess wrapper for terminal
│   │   ├── SyntaxHighlighter.h/cpp  Multi-language syntax highlighting
│   │   ├── WorkspaceManager.h/cpp   Recent projects and workspace state
│   │   └── Settings.h/cpp           Persistent app settings
│   └── models/
│       ├── ChatMessage.h            Chat message data structure
│       ├── ChatHistoryModel.h/cpp   Chat message list model
│       ├── FileTreeModel.h/cpp      File system tree model
│       └── ModelListModel.h/cpp     Available Ollama models
└── qml/
    ├── Main.qml                     Application shell and layout
    ├── theme/
    │   └── Theme.qml                Colors, fonts, spacing
    └── components/
        ├── ChatPanel.qml            AI chat interface
        ├── CodeEditor.qml           Code editor with line numbers
        ├── EditorTabBar.qml         File tabs
        ├── FileExplorer.qml         Directory tree sidebar
        ├── GlobalSearchDialog.qml   Regex search across files
        ├── MessageBubble.qml        Chat message rendering
        ├── QuickOpenDialog.qml      Fuzzy file finder
        ├── SettingsDialog.qml       Preferences dialog
        ├── StatusBar.qml            Bottom status bar
        ├── TerminalView.qml         Integrated terminal
        ├── ToolCallCard.qml         Agent tool call display
        └── WelcomeScreen.qml        Start screen with recent projects
```

## Technology Stack

- **Language:** C++17
- **UI Framework:** Qt 6 / QML (Qt Quick)
- **Networking:** Qt Network (`QNetworkAccessManager`)
- **Process Management:** `QProcess`
- **Build System:** CMake + Ninja
- **AI Backend:** Ollama REST API with streaming and tool calling

## License

MIT
