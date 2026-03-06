#!/bin/bash
# UseLlama Linux Uninstaller Script

set -e

APP_NAME="usellama"
APP_DISPLAY_NAME="UseLlama"
INSTALL_DIR="/opt/$APP_NAME"
BIN_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/icons/hicolor/256x256/apps"

echo "================================"
echo "  UseLlama Uninstaller"
echo "================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "🗑️  Uninstalling UseLlama..."

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "✓ Removed $INSTALL_DIR"
fi

# Remove symlink
if [ -L "$BIN_DIR/$APP_NAME" ]; then
    rm "$BIN_DIR/$APP_NAME"
    echo "✓ Removed $BIN_DIR/$APP_NAME"
fi

# Remove desktop entry
if [ -f "$DESKTOP_DIR/$APP_NAME.desktop" ]; then
    rm "$DESKTOP_DIR/$APP_NAME.desktop"
    echo "✓ Removed desktop entry"
fi

# Remove icon if exists
if [ -f "$ICON_DIR/$APP_NAME.png" ]; then
    rm "$ICON_DIR/$APP_NAME.png"
    echo "✓ Removed icon"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo ""
echo "✅ UseLlama has been uninstalled."
echo ""
