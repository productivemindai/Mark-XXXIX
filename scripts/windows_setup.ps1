# MARK XXXIX / JARVIS Windows Setup
# Run from the project root in PowerShell:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "== MARK XXXIX / JARVIS Windows Setup ==" -ForegroundColor Cyan

if (-not (Test-Path ".\main.py")) {
    Write-Error "Please run this script from the project root folder where main.py exists."
}

$python = Get-Command py -ErrorAction SilentlyContinue
if ($python) {
    $PythonCmd = "py"
    $PythonArgs = @("-3")
} else {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) {
        Write-Error "Python was not found. Install Python 3.11+ from https://www.python.org/downloads/ and check 'Add Python to PATH'."
    }
    $PythonCmd = "python"
    $PythonArgs = @()
}

Write-Host "Creating virtual environment..." -ForegroundColor Yellow
& $PythonCmd @PythonArgs -m venv .venv

$VenvPython = ".\.venv\Scripts\python.exe"
if (-not (Test-Path $VenvPython)) {
    Write-Error "Virtual environment Python was not created at $VenvPython"
}

Write-Host "Upgrading pip tooling..." -ForegroundColor Yellow
& $VenvPython -m pip install --upgrade pip setuptools wheel

Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
& $VenvPython -m pip install -r requirements.txt

Write-Host "Installing Playwright Chromium browser..." -ForegroundColor Yellow
& $VenvPython -m playwright install chromium

Write-Host "Validating project..." -ForegroundColor Yellow
& $VenvPython scripts\validate_project.py

if (-not (Test-Path ".\config\api_keys.json")) {
    Write-Host ""
    Write-Host "API config is not set yet." -ForegroundColor Yellow
    Write-Host "Run this next:" -ForegroundColor Yellow
    Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\windows_set_api_key.ps1" -ForegroundColor White
}

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "To create a desktop shortcut:" -ForegroundColor Cyan
Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\windows_create_desktop_shortcut.ps1" -ForegroundColor White
Write-Host "To run JARVIS manually:" -ForegroundColor Cyan
Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\windows_run.ps1" -ForegroundColor White
