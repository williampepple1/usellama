# UseLlama Installer Build Script (Inno Setup)
# Run this after building the application to create the installer

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  UseLlama Installer Builder" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Inno Setup is installed
$isccPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $isccPath)) {
    Write-Host "X Inno Setup 6 not found at: $isccPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install it: winget install JRSoftware.InnoSetup" -ForegroundColor Yellow
    Write-Host "Or download: https://jrsoftware.org/isdl.php" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check if application is built
if (-not (Test-Path "build\appusellama.exe")) {
    Write-Host "X Application not built. Please build first:" -ForegroundColor Red
    Write-Host ""
    Write-Host "  cmake -B build -G Ninja -DCMAKE_CXX_COMPILER=g++" -ForegroundColor Yellow
    Write-Host "  cmake --build build" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check if deploy directory exists, run windeployqt if not
if (-not (Test-Path "deploy\appusellama.exe")) {
    Write-Host ">> Creating deployment directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path "deploy" | Out-Null
    Copy-Item "build\appusellama.exe" "deploy\"
    windeployqt6 --qmldir qml --no-translations "deploy\appusellama.exe"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "X windeployqt6 failed!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[OK] Prerequisites check passed" -ForegroundColor Green
Write-Host ""
Write-Host ">> Building installer with Inno Setup..." -ForegroundColor Cyan

& $isccPath "installer.iss"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[OK] Installer created successfully!" -ForegroundColor Green
    Write-Host ""

    $installer = Get-Item "UseLlama-Setup.exe" -ErrorAction SilentlyContinue
    if ($installer) {
        $sizeMB = [math]::Round($installer.Length / 1MB, 2)
        Write-Host ">> Installer: $($installer.Name) ($sizeMB MB)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host ">> Ready to distribute!" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "X Installer build failed!" -ForegroundColor Red
    Write-Host "Check the error messages above for details." -ForegroundColor Yellow
    exit 1
}
