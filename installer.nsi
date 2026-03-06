; UseLlama NSIS Installer Script
; Requires NSIS 3.0 or later

!define APP_NAME "UseLlama"
!define APP_VERSION "0.1.0"
!define APP_PUBLISHER "UseLlama Project"
!define APP_URL "https://github.com/yourusername/usellama"
!define APP_EXE "appusellama.exe"

; Installer settings
Name "${APP_NAME} ${APP_VERSION}"
OutFile "UseLlama-${APP_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_NAME}" "Install_Dir"
RequestExecutionLevel admin

; Modern UI
!include "MUI2.nsh"
!include "FileFunc.nsh"

; Interface settings
!define MUI_ICON "app_icon.ico"
!define MUI_UNICON "app_icon.ico"
!define MUI_HEADERIMAGE
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\win.bmp"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${APP_NAME}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Languages
!insertmacro MUI_LANGUAGE "English"

; Version information
VIProductVersion "${APP_VERSION}.0"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "CompanyName" "${APP_PUBLISHER}"
VIAddVersionKey "FileDescription" "${APP_NAME} Installer"
VIAddVersionKey "FileVersion" "${APP_VERSION}"
VIAddVersionKey "LegalCopyright" "Copyright (c) 2026 ${APP_PUBLISHER}"

; Installer sections
Section "UseLlama (required)" SecCore
    SectionIn RO
    
    SetOutPath "$INSTDIR"
    
    ; Main executable
    File "build\${APP_EXE}"
    
    ; Qt 6 DLLs (MinGW)
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Core.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Gui.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Network.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Qml.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6QmlModels.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Quick.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6QuickControls2.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6QuickTemplates2.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Widgets.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6OpenGL.dll"
    File "C:\Qt\6.10.1\mingw_64\bin\Qt6Svg.dll"
    
    ; MinGW runtime
    File "C:\Qt\Tools\mingw1310_64\bin\libgcc_s_seh-1.dll"
    File "C:\Qt\Tools\mingw1310_64\bin\libstdc++-6.dll"
    File "C:\Qt\Tools\mingw1310_64\bin\libwinpthread-1.dll"
    
    ; Qt plugins
    SetOutPath "$INSTDIR\platforms"
    File "C:\Qt\6.10.1\mingw_64\plugins\platforms\qwindows.dll"
    
    SetOutPath "$INSTDIR\styles"
    File "C:\Qt\6.10.1\mingw_64\plugins\styles\qmodernwindowsstyle.dll"
    
    SetOutPath "$INSTDIR\imageformats"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qgif.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qicns.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qico.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qjpeg.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qsvg.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qtga.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qtiff.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qwbmp.dll"
    File "C:\Qt\6.10.1\mingw_64\plugins\imageformats\qwebp.dll"
    
    SetOutPath "$INSTDIR\iconengines"
    File "C:\Qt\6.10.1\mingw_64\plugins\iconengines\qsvgicon.dll"
    
    ; QML plugins
    SetOutPath "$INSTDIR\qml"
    File /r "C:\Qt\6.10.1\mingw_64\qml\QtQuick"
    File /r "C:\Qt\6.10.1\mingw_64\qml\QtQml"
    
    ; Documentation
    SetOutPath "$INSTDIR"
    File "README.md"
    File "LICENSE"
    
    ; Write registry keys
    WriteRegStr HKLM "Software\${APP_NAME}" "Install_Dir" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "URLInfoAbout" "${APP_URL}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\${APP_EXE}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
    
    ; Calculate installed size
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" "$0"
    
    ; Create uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Desktop Shortcut" SecDesktop
    CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}"
SectionEnd

Section "Start Menu Shortcuts" SecStartMenu
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\README.lnk" "$INSTDIR\README.md"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core application files (required)"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Create a desktop shortcut"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Create Start Menu shortcuts"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller section
Section "Uninstall"
    ; Remove registry keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    DeleteRegKey HKLM "Software\${APP_NAME}"
    
    ; Remove files
    Delete "$INSTDIR\${APP_EXE}"
    Delete "$INSTDIR\*.dll"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\LICENSE"
    Delete "$INSTDIR\uninstall.exe"
    
    ; Remove directories
    RMDir /r "$INSTDIR\platforms"
    RMDir /r "$INSTDIR\styles"
    RMDir /r "$INSTDIR\imageformats"
    RMDir /r "$INSTDIR\iconengines"
    RMDir /r "$INSTDIR\qml"
    RMDir "$INSTDIR"
    
    ; Remove shortcuts
    Delete "$DESKTOP\${APP_NAME}.lnk"
    Delete "$SMPROGRAMS\${APP_NAME}\*.*"
    RMDir "$SMPROGRAMS\${APP_NAME}"
SectionEnd
