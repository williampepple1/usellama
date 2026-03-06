#!/bin/bash
# UseLlama macOS Installer Script

set -e

APP_NAME="UseLlama"
APP_VERSION="0.1.0"
APP_BUNDLE="appusellama.app"
INSTALL_DIR="/Applications"
BIN_LINK="/usr/local/bin/usellama"

echo "================================"
echo "  UseLlama Installer v${APP_VERSION}"
echo "================================"
echo ""

# Check if running with proper permissions
if [ ! -w "$INSTALL_DIR" ]; then
    echo "❌ Cannot write to $INSTALL_DIR"
    echo "Please run with: sudo ./install-macos.sh"
    exit 1
fi

echo "📦 Installing UseLlama to $INSTALL_DIR..."

# Check if app bundle exists
if [ ! -d "build/$APP_BUNDLE" ]; then
    echo "❌ Error: build/$APP_BUNDLE not found!"
    echo "Please build the project first with:"
    echo "  cmake -B build -G Ninja"
    echo "  cmake --build build"
    exit 1
fi

# Remove existing installation
if [ -d "$INSTALL_DIR/$APP_BUNDLE" ]; then
    echo "🗑️  Removing existing installation..."
    rm -rf "$INSTALL_DIR/$APP_BUNDLE"
fi

# Copy app bundle
echo "📋 Copying app bundle..."
cp -R "build/$APP_BUNDLE" "$INSTALL_DIR/"

# Create command-line symlink
echo "🔗 Creating command-line launcher..."
mkdir -p "$(dirname "$BIN_LINK")"
cat > "$BIN_LINK" << 'EOF'
#!/bin/bash
exec /Applications/appusellama.app/Contents/MacOS/appusellama "$@"
EOF
chmod +x "$BIN_LINK"

# Set proper permissions
chmod -R 755 "$INSTALL_DIR/$APP_BUNDLE"

echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 Launch UseLlama from:"
echo "   • Launchpad or Applications folder"
echo "   • Terminal: usellama"
echo ""
echo "ℹ️  Make sure Ollama is running:"
echo "   ollama serve"
echo ""
echo "🗑️  To uninstall, run: sudo ./uninstall-macos.sh"
echo ""
