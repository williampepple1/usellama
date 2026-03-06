# UseLlama Installer Scripts

This directory contains installer/uninstaller scripts for all platforms.

## 🪟 Windows

### Building the Installer

1. **Install NSIS** (Nullsoft Scriptable Install System):
   - Download from: https://nsis.sourceforge.io/Download
   - Install to default location

2. **Build the application** (if not already built):
   ```powershell
   cmake -B build -G Ninja -DCMAKE_CXX_COMPILER=g++
   cmake --build build
   ```

3. **Create a LICENSE file** (required by installer):
   ```powershell
   # Create a simple MIT license or copy your existing one
   echo "MIT License..." > LICENSE
   ```

4. **Compile the installer**:
   ```powershell
   makensis installer.nsi
   ```

5. **Distribute** the generated `UseLlama-0.1.0-Setup.exe`

### What the installer includes:
- ✅ Main application executable
- ✅ All Qt 6 DLLs (Core, GUI, Network, QML, Quick, etc.)
- ✅ MinGW runtime libraries
- ✅ Qt plugins (platforms, styles, imageformats, etc.)
- ✅ QML modules (QtQuick, QtQml)
- ✅ README and LICENSE
- ✅ Desktop shortcut (optional)
- ✅ Start Menu shortcuts (optional)
- ✅ Uninstaller
- ✅ Registry entries for Windows Add/Remove Programs

### Manual Installation (without installer)

If you prefer not to use the NSIS installer:

1. Build the application
2. Copy all DLLs from Qt installation to the `build/` folder
3. Copy required Qt plugins to `build/platforms/`, `build/styles/`, etc.
4. Distribute the entire `build/` folder

---

## 🐧 Linux

### Installing

```bash
# Make the script executable
chmod +x install-linux.sh

# Run the installer (requires sudo)
sudo ./install-linux.sh
```

The installer will:
- Copy the executable to `/opt/usellama/`
- Create a symlink in `/usr/local/bin/`
- Add a desktop entry to `/usr/share/applications/`
- Make UseLlama available in your application menu

### Running

```bash
# From terminal
usellama

# Or launch from your application menu
```

### Uninstalling

```bash
chmod +x uninstall-linux.sh
sudo ./uninstall-linux.sh
```

---

## 🍎 macOS

### Installing

```bash
# Make the script executable
chmod +x install-macos.sh

# Run the installer (requires sudo)
sudo ./install-macos.sh
```

The installer will:
- Copy the app bundle to `/Applications/`
- Create a command-line launcher in `/usr/local/bin/`
- Set proper permissions

### Running

```bash
# From Launchpad or Applications folder
# Or from terminal:
usellama
```

### Uninstalling

```bash
chmod +x uninstall-macos.sh
sudo ./uninstall-macos.sh
```

---

## 📝 Notes

### Windows Notes:
- The NSIS script assumes Qt is installed at `C:\Qt\6.10.1\mingw_64\`
- Adjust paths in `installer.nsi` if your Qt installation is elsewhere
- The installer requires MinGW-compiled binaries (not MSVC)
- Total installation size: ~150-200 MB

### Linux Notes:
- Requires Qt 6 runtime libraries to be installed on the system:
  ```bash
  sudo apt install qt6-base-dev qt6-declarative-dev
  ```
- The app will use system-installed Qt libraries
- Installation size: ~5-10 MB (without Qt)

### macOS Notes:
- The app bundle includes all necessary Qt frameworks
- Code signing is NOT included — you'll need to add your developer certificate
- For distribution outside App Store, notarization is recommended
- Installation size: ~100-150 MB

---

## 🚀 Creating Releases

### Automated Release (Recommended)

Use GitHub Actions or similar CI/CD to build and package for all platforms:

```yaml
# Example: .github/workflows/release.yml
- Build Windows: compile + run NSIS
- Build Linux: compile + create .deb/.rpm
- Build macOS: compile + create .dmg
```

### Manual Release

1. Build for each platform
2. Run the appropriate installer creation script
3. Upload to GitHub Releases:
   - `UseLlama-0.1.0-Setup.exe` (Windows)
   - `usellama_0.1.0_amd64.deb` or tarball (Linux)
   - `UseLlama-0.1.0.dmg` (macOS)

---

## 🔧 Troubleshooting

### Windows: "Missing DLL" error
- Run `windeployqt build/appusellama.exe` to automatically copy Qt DLLs
- Or manually copy missing DLLs from Qt installation

### Linux: "Qt platform plugin error"
- Install Qt runtime: `sudo apt install qt6-base-dev`
- Set `QT_QPA_PLATFORM_PLUGIN_PATH` if needed

### macOS: "App is damaged" warning
- Run: `xattr -cr /Applications/appusellama.app`
- Or add code signing to the build process

---

## 📦 Distribution Checklist

Before releasing:

- [ ] Test installer on clean Windows VM
- [ ] Test Linux script on Ubuntu/Fedora
- [ ] Test macOS installer on fresh system
- [ ] Verify all features work after installation
- [ ] Check file associations (if any)
- [ ] Ensure uninstallers remove everything cleanly
- [ ] Update version numbers in all scripts
- [ ] Create release notes
- [ ] Tag release in git

---

For more information, see the main [README.md](README.md)
