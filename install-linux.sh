#!/bin/bash
# UseLlama Linux Installer Script

set -e

APP_NAME="usellama"
APP_VERSION="0.1.0"
APP_DISPLAY_NAME="UseLlama"
INSTALL_DIR="/opt/$APP_NAME"
BIN_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/icons/hicolor/256x256/apps"

echo "================================"
echo "  UseLlama Installer v${APP_VERSION}"
echo "================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "📦 Installing UseLlama to $INSTALL_DIR..."

# Create installation directory
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"

# Copy executable
if [ -f "build/appusellama" ]; then
    cp build/appusellama "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/appusellama"
else
    echo "❌ Error: build/appusellama not found!"
    echo "Please build the project first with:"
    echo "  cmake -B build -G Ninja"
    echo "  cmake --build build"
    exit 1
fi

# Copy additional files
cp README.md "$INSTALL_DIR/" 2>/dev/null || true
cp LICENSE "$INSTALL_DIR/" 2>/dev/null || true

# Create symlink in /usr/local/bin
ln -sf "$INSTALL_DIR/appusellama" "$BIN_DIR/$APP_NAME"

# Create desktop entry
cat > "$DESKTOP_DIR/$APP_NAME.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_DISPLAY_NAME
Comment=Agentic AI IDE powered by Ollama
Exec=$BIN_DIR/$APP_NAME
Terminal=false
Categories=Development;IDE;TextEditor;
Keywords=ai;ide;editor;ollama;llama;
EOF

chmod 644 "$DESKTOP_DIR/$APP_NAME.desktop"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 You can now run UseLlama by typing: $APP_NAME"
echo "   Or find it in your application menu."
echo ""
echo "📍 Installation location: $INSTALL_DIR"
echo ""
echo "ℹ️  Make sure Ollama is running:"
echo "   ollama serve"
echo ""
echo "🗑️  To uninstall, run: sudo ./uninstall-linux.sh"
echo ""
