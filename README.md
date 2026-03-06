<div align="center">

# 🦙 UseLlama

### An Agentic AI IDE Powered by Ollama

*Think Cursor meets Windsurf, but 100% Ollama — local first, cloud ready*

[![Qt](https://img.shields.io/badge/Qt-6.8+-41CD52?style=for-the-badge&logo=qt&logoColor=white)](https://www.qt.io/)
[![C++](https://img.shields.io/badge/C++-17-00599C?style=for-the-badge&logo=cplusplus&logoColor=white)](https://isocpp.org/)
[![Ollama](https://img.shields.io/badge/Ollama-Powered-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

![Version](https://img.shields.io/badge/version-0.1.0-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey?style=flat-square)

---

</div>

## ✨ Features

<table>
<tr>
<td width="50%">

### 🤖 **Agentic AI Assistant**
The AI autonomously reads, writes, edits files, runs commands, searches code — all through Ollama's tool-calling API.

### 📝 **Custom Code Editor**
Built-in editor with line numbers, syntax highlighting (C++, JS/TS, Python, QML), and tabbed editing.

### 📁 **File Explorer**
Full directory tree with file-type icons and quick navigation.

### 💻 **Integrated Terminal**
Run commands directly in the IDE. The agent can use it too!

</td>
<td width="50%">

### ⚡ **Quick Open** (`Ctrl+P`)
Fuzzy file search across your entire workspace.

### 🔍 **Global Search** (`Ctrl+Shift+F`)
Regex search across all files instantly.

### ☁️ **Ollama Cloud Support**
Works with local Ollama *and* remote cloud endpoints with API keys.

### 🎨 **Beautiful Dark Theme**
Catppuccin Mocha-inspired UI that's easy on the eyes.

</td>
</tr>
</table>

---

## 🎯 What Makes UseLlama Special?

> **🔒 Privacy First** — Your code never leaves your machine when using local Ollama  
> **🛠️ Truly Agentic** — The AI doesn't just suggest, it *does* (with your permission)  
> **🌐 Cloud Ready** — Seamlessly switch between local and cloud-hosted Ollama models  
> **🚀 Lightweight** — Native desktop app, no Electron bloat  
> **🎨 Modern UI** — Built with Qt 6 and QML for a smooth, native experience  

---

## 📸 Screenshots

<div align="center">
<i>🚧 Coming soon! The app is hot off the press 🚧</i>
</div>

---

## 🛠️ Prerequisites

| Requirement | Version | Notes |
|------------|---------|-------|
| **Qt** | 6.8+ | Tested with Qt 6.10.1 |
| **CMake** | 3.16+ | Build system |
| **C++ Compiler** | C++17 | MinGW 13+, MSVC 2022, GCC 12+, or Clang 15+ |
| **Ninja** | Latest | Recommended (or Make) |
| **Ollama** | Latest | Running locally or on a remote server |

---

## 🚀 Build Instructions

### 🪟 Windows (MinGW)

```powershell
# Set up environment (adjust paths to your Qt installation)
$env:PATH = "C:\Qt\Tools\mingw1310_64\bin;C:\Qt\6.10.1\mingw_64\bin;C:\Qt\Tools\CMake_64\bin;C:\Qt\Tools\Ninja;$env:PATH"
$env:CMAKE_PREFIX_PATH = "C:\Qt\6.10.1\mingw_64"

# Configure and build
cmake -B build -G Ninja -DCMAKE_CXX_COMPILER=g++
cmake --build build

# Run 🎉
.\build\appusellama.exe
```

### 🐧 Linux

```bash
# Install Qt 6 (Ubuntu/Debian)
sudo apt install qt6-base-dev qt6-declarative-dev qt6-tools-dev cmake ninja-build

# Configure and build
cmake -B build -G Ninja
cmake --build build

# Run 🎉
./build/appusellama
```

### 🍎 macOS

```bash
# Install Qt 6 via Homebrew
brew install qt@6 cmake ninja

# Configure and build
export CMAKE_PREFIX_PATH=$(brew --prefix qt@6)
cmake -B build -G Ninja
cmake --build build

# Run 🎉
./build/appusellama.app/Contents/MacOS/appusellama
```

---

## 🎮 Usage Guide

### Getting Started

1. **🦙 Start Ollama** — Ensure `ollama serve` is running (or have a remote instance ready)
2. **🚀 Launch UseLlama** — Run the built executable
3. **📂 Open a workspace** — Click "Open Folder" or press `Ctrl+O`
4. **💬 Chat with AI** — Type in the chat panel and watch the agent work its magic
5. **⚙️ Configure** — Press `Ctrl+,` for settings (Ollama URL, API key, temperature, etc.)

### ☁️ Ollama Cloud / Remote Servers

To connect to a remote Ollama instance:

1. Open **Settings** (`Ctrl+,`)
2. Set **URL** to your endpoint (e.g., `https://your-server.example.com`)
3. Enter your **API Key** (sent as `Authorization: Bearer <key>`)
4. Click **OK** — automatic reconnection!

> 💡 **Tip:** Leave the API key blank for local Ollama

---

## 🔧 Agent Tools

The AI assistant has access to these powerful tools:

| Tool | Description | Example Use |
|------|-------------|-------------|
| 🔍 `read_file` | Read file contents | Inspect existing code before editing |
| ✏️ `write_file` | Create or overwrite a file | Generate new source files |
| 🔄 `edit_file` | Find and replace text in a file | Update function implementations |
| 📋 `list_directory` | List files and folders | Explore project structure |
| 🗑️ `delete_file` | Delete a file or directory | Clean up generated files |
| 🖥️ `run_command` | Execute a shell command | Build, test, or deploy |
| 🔎 `search_files` | Regex search across files | Find all usages of a symbol |
| 📁 `create_directory` | Create directories (with parents) | Set up project scaffolding |

---

## ⌨️ Keyboard Shortcuts

<table>
<tr>
<td width="50%">

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | 📂 Open folder |
| `Ctrl+P` | ⚡ Quick open file |
| `Ctrl+Shift+F` | 🔍 Search in files |
| `Ctrl+S` | 💾 Save current file |

</td>
<td width="50%">

| Shortcut | Action |
|----------|--------|
| `Ctrl+L` | 💬 Toggle chat panel |
| `` Ctrl+` `` | 💻 Toggle terminal |
| `Ctrl+,` | ⚙️ Open settings |
| `Ctrl+Q` | 🚪 Quit |

</td>
</tr>
</table>

---

## 📦 Project Structure

```
usellama/
├── 🎯 main.cpp                          # Application entry point
├── 🔧 CMakeLists.txt                    # Build configuration
├── 📂 src/
│   ├── 💼 core/
│   │   ├── OllamaClient.h/cpp          # Ollama REST API client (streaming)
│   │   ├── AgentEngine.h/cpp           # Agentic tool-calling loop
│   │   ├── AgentTools.h/cpp            # Tool implementations
│   │   ├── FileSystemManager.h/cpp     # File I/O operations
│   │   ├── TerminalProcess.h/cpp       # QProcess wrapper for terminal
│   │   ├── SyntaxHighlighter.h/cpp     # Multi-language syntax highlighting
│   │   ├── WorkspaceManager.h/cpp      # Recent projects and workspace state
│   │   └── Settings.h/cpp              # Persistent app settings
│   └── 📊 models/
│       ├── ChatMessage.h               # Chat message data structure
│       ├── ChatHistoryModel.h/cpp      # Chat message list model
│       ├── FileTreeModel.h/cpp         # File system tree model
│       └── ModelListModel.h/cpp        # Available Ollama models
└── 🎨 qml/
    ├── Main.qml                         # Application shell and layout
    ├── theme/
    │   └── Theme.qml                    # Colors, fonts, spacing
    └── components/
        ├── ChatPanel.qml                # AI chat interface
        ├── CodeEditor.qml               # Code editor with line numbers
        ├── EditorTabBar.qml             # File tabs
        ├── FileExplorer.qml             # Directory tree sidebar
        ├── GlobalSearchDialog.qml       # Regex search across files
        ├── MessageBubble.qml            # Chat message rendering
        ├── QuickOpenDialog.qml          # Fuzzy file finder
        ├── SettingsDialog.qml           # Preferences dialog
        ├── StatusBar.qml                # Bottom status bar
        ├── TerminalView.qml             # Integrated terminal
        ├── ToolCallCard.qml             # Agent tool call display
        └── WelcomeScreen.qml            # Start screen with recent projects
```

---

## 🧰 Technology Stack

<div align="center">

| Component | Technology |
|-----------|-----------|
| **Language** | ![C++](https://img.shields.io/badge/C++-17-00599C?style=flat&logo=cplusplus&logoColor=white) |
| **UI Framework** | ![Qt](https://img.shields.io/badge/Qt-6%20%2F%20QML-41CD52?style=flat&logo=qt&logoColor=white) |
| **Networking** | Qt Network (`QNetworkAccessManager`) |
| **Process Mgmt** | `QProcess` |
| **Build System** | ![CMake](https://img.shields.io/badge/CMake-064F8C?style=flat&logo=cmake&logoColor=white) + Ninja |
| **AI Backend** | ![Ollama](https://img.shields.io/badge/Ollama-API-000000?style=flat&logo=ollama&logoColor=white) (streaming + tool calling) |

</div>

---

## 🗺️ Roadmap

- [ ] 📸 Add screenshots and demo GIF
- [ ] 🎬 Record demo video
- [ ] 🔌 Plugin system for custom tools
- [ ] 🌍 Multi-language support (i18n)
- [ ] 📊 Token usage tracking
- [ ] 🎨 Light theme option
- [ ] 🔗 Git integration
- [ ] 🧪 Unit tests

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests
- 📖 Improve documentation

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 💖 Built with love and powered by Ollama

**Star ⭐ this repo if you find it useful!**

[🐛 Report Bug](https://github.com/yourusername/usellama/issues) · [✨ Request Feature](https://github.com/yourusername/usellama/issues) · [💬 Discussions](https://github.com/yourusername/usellama/discussions)

</div>
