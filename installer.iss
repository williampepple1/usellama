; ==========================================================================
; UseLlama Installer — Inno Setup Script
; Agentic AI IDE powered by Ollama
; ==========================================================================

#define AppName      "UseLlama"
#define AppVersion   "1.0.0"
#define AppPublisher "UseLlama Project"
#define AppURL       "https://github.com/yourusername/usellama"
#define AppExeName   "appusellama.exe"

[Setup]
AppId={{B8F3A2D1-4E7C-4A9B-8D2F-1C6E5F3A7B9D}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
LicenseFile=LICENSE
OutputDir=.
OutputBaseFilename=UseLlama-1.0.0-Setup
SetupIconFile=app_icon.ico
UninstallDisplayIcon={app}\app_icon.ico
UninstallDisplayName={#AppName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
PrivilegesRequired=admin
VersionInfoVersion={#AppVersion}.0
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} — Agentic AI IDE powered by Ollama
VersionInfoCopyright=Copyright (c) 2026 {#AppPublisher}
VersionInfoProductName={#AppName}
VersionInfoProductVersion={#AppVersion}
DisableWelcomePage=no
ShowLanguageDialog=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1=Welcome to {#AppName} v{#AppVersion}
WelcomeLabel2=Thank you for choosing {#AppName} — the Agentic AI IDE powered by Ollama.%n%nWhat you get:%n  - Code editor with syntax highlighting and tabs%n  - AI assistant that reads, writes, edits files and runs commands%n  - Integrated terminal and file explorer%n  - Full workspace management with recent projects%n  - Works with both local and cloud Ollama models%n  - Right-click "Open with UseLlama" integration%n%nThis wizard will guide you through the installation.%n%nClick Next to continue.

[Tasks]
Name: "desktopicon";     Description: "Create a &desktop shortcut";                       GroupDescription: "Shortcuts:"
Name: "addtopath";       Description: "Add {#AppName} to the system &PATH";               GroupDescription: "System integration:"; Flags: unchecked
Name: "addcontextmenu";  Description: "Add ""Open with {#AppName}"" to Explorer context menu"; GroupDescription: "System integration:"

[Files]
Source: "deploy\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "app_icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}";            Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\app_icon.ico"
Name: "{group}\Uninstall {#AppName}";   Filename: "{uninstallexe}";      IconFilename: "{app}\app_icon.ico"
Name: "{autodesktop}\{#AppName}";       Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\app_icon.ico"; Tasks: desktopicon

[Registry]
; "Open with UseLlama" — right-click on folders
Root: HKCR; Subkey: "Directory\shell\UseLlama";         ValueType: string; ValueName: "";     ValueData: "Open with {#AppName}";       Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\UseLlama";         ValueType: string; ValueName: "Icon"; ValueData: """{app}\app_icon.ico""";     Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\UseLlama\command";  ValueType: string; ValueName: "";     ValueData: """{app}\{#AppExeName}"" ""%1"""; Tasks: addcontextmenu; Flags: uninsdeletekey

; "Open with UseLlama" — right-click on folder background
Root: HKCR; Subkey: "Directory\Background\shell\UseLlama";         ValueType: string; ValueName: "";     ValueData: "Open with {#AppName}";       Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\Background\shell\UseLlama";         ValueType: string; ValueName: "Icon"; ValueData: """{app}\app_icon.ico""";     Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\Background\shell\UseLlama\command";  ValueType: string; ValueName: "";     ValueData: """{app}\{#AppExeName}"" ""%V"""; Tasks: addcontextmenu; Flags: uninsdeletekey

; "Open with UseLlama" — right-click on any file
Root: HKCR; Subkey: "*\shell\UseLlama";         ValueType: string; ValueName: "";     ValueData: "Open with {#AppName}";       Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\UseLlama";         ValueType: string; ValueName: "Icon"; ValueData: """{app}\app_icon.ico""";     Tasks: addcontextmenu; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\UseLlama\command";  ValueType: string; ValueName: "";     ValueData: """{app}\{#AppExeName}"" ""%1"""; Tasks: addcontextmenu; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent

[Code]
const
  EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

procedure AddToPath();
var
  OldPath: string;
begin
  if not RegQueryStringValue(HKLM, EnvironmentKey, 'Path', OldPath) then
    OldPath := '';
  if Pos(ExpandConstant('{app}'), OldPath) = 0 then
  begin
    if OldPath <> '' then
      OldPath := OldPath + ';';
    OldPath := OldPath + ExpandConstant('{app}');
    RegWriteExpandStringValue(HKLM, EnvironmentKey, 'Path', OldPath);
  end;
end;

procedure RemoveFromPath();
var
  OldPath, AppDir, NewPath: string;
  P: Integer;
begin
  if not RegQueryStringValue(HKLM, EnvironmentKey, 'Path', OldPath) then
    Exit;
  AppDir := ExpandConstant('{app}');
  P := Pos(';' + AppDir, OldPath);
  if P > 0 then
  begin
    NewPath := Copy(OldPath, 1, P - 1) + Copy(OldPath, P + Length(';' + AppDir), MaxInt);
    RegWriteExpandStringValue(HKLM, EnvironmentKey, 'Path', NewPath);
    Exit;
  end;
  P := Pos(AppDir + ';', OldPath);
  if P > 0 then
  begin
    NewPath := Copy(OldPath, 1, P - 1) + Copy(OldPath, P + Length(AppDir + ';'), MaxInt);
    RegWriteExpandStringValue(HKLM, EnvironmentKey, 'Path', NewPath);
    Exit;
  end;
  P := Pos(AppDir, OldPath);
  if P > 0 then
  begin
    NewPath := Copy(OldPath, 1, P - 1) + Copy(OldPath, P + Length(AppDir), MaxInt);
    RegWriteExpandStringValue(HKLM, EnvironmentKey, 'Path', NewPath);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('addtopath') then
      AddToPath();
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveFromPath();
end;
