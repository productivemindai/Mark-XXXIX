# Run MARK XXXIX / JARVIS on Windows.
# Run from project root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_run.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".\main.py")) {
    Write-Error "Please run this script from the project root folder where main.py exists."
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
