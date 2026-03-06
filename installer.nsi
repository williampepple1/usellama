; ============================================================================
; UseLlama NSIS Installer Script
; Agentic AI IDE powered by Ollama
; ============================================================================

!define APP_NAME "UseLlama"
!define APP_VERSION "0.1.0"
!define APP_PUBLISHER "UseLlama Project"
!define APP_URL "https://github.com/yourusername/usellama"
!define APP_EXE "appusellama.exe"
!define APP_DESC "Agentic AI IDE powered by Ollama. Code with AI that can read, write, edit files and run commands — all using local or cloud Ollama models."

Name "${APP_NAME} ${APP_VERSION}"
OutFile "UseLlama-${APP_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_NAME}" "Install_Dir"
RequestExecutionLevel admin
SetCompressor /SOLID lzma

; ============================================================================
; Modern UI 2
; ============================================================================
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinMessages.nsh"
!include "x64.nsh"
!include "WordFunc.nsh"

; ---- Branding ----
!define MUI_ICON "app_icon.ico"
!define MUI_UNICON "app_icon.ico"
BrandingText "${APP_NAME} v${APP_VERSION} — AI IDE for Ollama"

; ---- Welcome page ----
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${APP_NAME} Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will install ${APP_NAME} v${APP_VERSION} on your computer.$\r$\n$\r$\n${APP_DESC}$\r$\n$\r$\nFeatures:$\r$\n  * Agentic AI assistant (reads, writes, edits code)$\r$\n  * Custom code editor with syntax highlighting$\r$\n  * Integrated terminal$\r$\n  * File explorer & workspace management$\r$\n  * Works with local and cloud Ollama$\r$\n$\r$\nClick Next to continue."
!define MUI_WELCOMEFINISHPAGE_BITMAP "installer_sidebar.bmp"

; ---- Header image ----
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "installer_header.bmp"
!define MUI_HEADERIMAGE_RIGHT

; ---- Abort warning ----
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Are you sure you want to cancel ${APP_NAME} installation?"

; ---- Finish page ----
!define MUI_FINISHPAGE_TITLE "${APP_NAME} Installation Complete"
!define MUI_FINISHPAGE_TEXT "${APP_NAME} has been installed on your computer.$\r$\n$\r$\nMake sure Ollama is running (ollama serve) to use AI features.$\r$\n$\r$\nClick Finish to close the wizard."
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${APP_NAME} now"
!define MUI_FINISHPAGE_LINK "Visit ${APP_NAME} on GitHub"
!define MUI_FINISHPAGE_LINK_LOCATION "${APP_URL}"
!define MUI_UNFINISHPAGE_BITMAP "installer_sidebar.bmp"

; ---- Pages ----
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; ---- Language ----
!insertmacro MUI_LANGUAGE "English"

; ---- Version info embedded in .exe ----
VIProductVersion "${APP_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${APP_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${APP_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${APP_NAME} — Agentic AI IDE for Ollama"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${APP_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright (c) 2026 ${APP_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${APP_VERSION}"

; ============================================================================
; Installer Sections
; ============================================================================

Section "${APP_NAME} (required)" SecCore
    SectionIn RO

    SetOutPath "$INSTDIR"

    ; Copy entire deployed directory
    File /r "deploy\*.*"

    ; Copy icon and docs
    File "app_icon.ico"
    File "README.md"
    File "LICENSE"

    ; Write application registry keys
    WriteRegStr HKLM "Software\${APP_NAME}" "Install_Dir" "$INSTDIR"
    WriteRegStr HKLM "Software\${APP_NAME}" "Version" "${APP_VERSION}"

    ; Add/Remove Programs entry
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME} — Agentic AI IDE"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "URLInfoAbout" "${APP_URL}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\app_icon.ico"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1

    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" "$0"

    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; ---- Desktop Shortcut ----
Section "Desktop Shortcut" SecDesktop
    CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\app_icon.ico" 0
SectionEnd

; ---- Start Menu ----
Section "Start Menu Shortcuts" SecStartMenu
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\app_icon.ico" 0
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\app_icon.ico" 0
SectionEnd

; ---- Add to PATH ----
Section "Add to PATH" SecPath
    ; Add install dir to system PATH
    ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    StrCpy $0 "$0;$INSTDIR"
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0"
    ; Notify Windows of environment change
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

; ---- Open With UseLlama (context menu) ----
Section '"Open with ${APP_NAME}" context menu' SecContext
    ; Folder background context menu
    WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "" "Open with ${APP_NAME}"
    WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "Icon" '"$INSTDIR\app_icon.ico"'
    WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}\command" "" '"$INSTDIR\${APP_EXE}" "%V"'

    ; Right-click on folder
    WriteRegStr HKCR "Directory\shell\${APP_NAME}" "" "Open with ${APP_NAME}"
    WriteRegStr HKCR "Directory\shell\${APP_NAME}" "Icon" '"$INSTDIR\app_icon.ico"'
    WriteRegStr HKCR "Directory\shell\${APP_NAME}\command" "" '"$INSTDIR\${APP_EXE}" "%1"'

    ; Right-click on any file
    WriteRegStr HKCR "*\shell\${APP_NAME}" "" "Open with ${APP_NAME}"
    WriteRegStr HKCR "*\shell\${APP_NAME}" "Icon" '"$INSTDIR\app_icon.ico"'
    WriteRegStr HKCR "*\shell\${APP_NAME}\command" "" '"$INSTDIR\${APP_EXE}" "%1"'
SectionEnd

; ============================================================================
; Section Descriptions
; ============================================================================
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core ${APP_NAME} application files. This includes the editor, AI chat, terminal, and all required libraries. (Required)"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Place a ${APP_NAME} shortcut on your desktop for quick access."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Create ${APP_NAME} entries in the Windows Start Menu."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPath} "Add ${APP_NAME} to the system PATH so you can launch it from any command prompt or terminal by typing: usellama"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecContext} 'Add "Open with ${APP_NAME}" to the right-click context menu for files and folders in Windows Explorer.'
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ============================================================================
; Uninstaller
; ============================================================================

Section "Uninstall"
    ; Remove context menu entries
    DeleteRegKey HKCR "Directory\Background\shell\${APP_NAME}"
    DeleteRegKey HKCR "Directory\shell\${APP_NAME}"
    DeleteRegKey HKCR "*\shell\${APP_NAME}"

    ; Remove from PATH
    ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    ${WordReplace} "$0" ";$INSTDIR" "" "+" $1
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$1"
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

    ; Remove registry keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    DeleteRegKey HKLM "Software\${APP_NAME}"

    ; Remove all installed files
    RMDir /r "$INSTDIR"

    ; Remove shortcuts
    Delete "$DESKTOP\${APP_NAME}.lnk"
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
SectionEnd
