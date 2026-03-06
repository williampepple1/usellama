#!/bin/bash
# UseLlama macOS Uninstaller Script

set -e

APP_NAME="UseLlama"
APP_BUNDLE="appusellama.app"
INSTALL_DIR="/Applications"
BIN_LINK="/usr/local/bin/usellama"

echo "================================"
echo "  UseLlama Uninstaller"
echo "================================"
echo ""

# Check if running with proper permissions
if [ ! -w "$INSTALL_DIR" ]; then
    echo "❌ Cannot write to $INSTALL_DIR"
    echo "Please run with: sudo ./uninstall-macos.sh"
    exit 1
fi

echo "🗑️  Uninstalling UseLlama..."

# Remove app bundle
if [ -d "$INSTALL_DIR/$APP_BUNDLE" ]; then
    rm -rf "$INSTALL_DIR/$APP_BUNDLE"
    echo "✓ Removed $INSTALL_DIR/$APP_BUNDLE"
fi

# Remove command-line symlink
if [ -f "$BIN_LINK" ]; then
    rm "$BIN_LINK"
    echo "✓ Removed $BIN_LINK"
fi

# Remove user settings (optional - ask user)
SETTINGS_DIR="$HOME/Library/Preferences/com.UseLlama.UseLlama.plist"
if [ -f "$SETTINGS_DIR" ]; then
    read -p "Remove user settings? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "$SETTINGS_DIR"
        echo "✓ Removed user settings"
    fi
fi

echo ""
echo "✅ UseLlama has been uninstalled."
echo ""
