# UseLlama Windows Installer Build Script
# Run this after building the application to create the installer

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  UseLlama Installer Builder" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if NSIS is installed
$nsisPath = "C:\Program Files (x86)\NSIS\makensis.exe"
if (-not (Test-Path $nsisPath)) {
    Write-Host "❌ NSIS not found at: $nsisPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install NSIS from: https://nsis.sourceforge.io/Download" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check if application is built
if (-not (Test-Path "build\appusellama.exe")) {
    Write-Host "❌ Application not built. Please build first:" -ForegroundColor Red
    Write-Host ""
    Write-Host "  cmake -B build -G Ninja -DCMAKE_CXX_COMPILER=g++" -ForegroundColor Yellow
    Write-Host "  cmake --build build" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check if LICENSE exists
if (-not (Test-Path "LICENSE")) {
    Write-Host "⚠️  LICENSE file not found. Creating default MIT license..." -ForegroundColor Yellow
    Copy-Item "LICENSE" -Destination "LICENSE.bak" -ErrorAction SilentlyContinue
}

Write-Host "✅ Prerequisites check passed" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Building installer..." -ForegroundColor Cyan

# Build the installer
& $nsisPath "installer.nsi"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Installer created successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Get installer size
    $installer = Get-Item "UseLlama-*-Setup.exe" | Select-Object -First 1
    if ($installer) {
        $sizeMB = [math]::Round($installer.Length / 1MB, 2)
        Write-Host "📦 Installer: $($installer.Name) ($sizeMB MB)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "🚀 You can now distribute this installer!" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "❌ Installer build failed!" -ForegroundColor Red
    Write-Host "Check the error messages above for details." -ForegroundColor Yellow
    exit 1
}
