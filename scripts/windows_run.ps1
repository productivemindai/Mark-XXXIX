# Run MARK XXXIX / JARVIS on Windows.
# You can run this from any folder:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_run.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path
Set-Location $ProjectRoot

if (-not (Test-Path ".\main.py")) {
    Write-Error "Could not locate main.py from script path: $ScriptDir"
}

$VenvPython = ".\.venv\Scripts\python.exe"
if (-not (Test-Path $VenvPython)) {
    Write-Host "Virtual environment not found. Running setup first..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\windows_setup.ps1
}

if (-not (Test-Path ".\config\api_keys.json")) {
    Write-Host "Missing config/api_keys.json." -ForegroundColor Yellow
    Write-Host "Run this first:" -ForegroundColor Yellow
    Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\windows_set_api_key.ps1" -ForegroundColor White
    exit 1
}

Write-Host "Starting JARVIS..." -ForegroundColor Cyan
& $VenvPython .\main.py
