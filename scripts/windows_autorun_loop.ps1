# MARK XXXIX / JARVIS persistent launcher for Windows.
# Keeps JARVIS running and restarts it if it exits unexpectedly.
# This file is intended to be launched by Windows Task Scheduler at user logon.

param(
    [int]$RestartDelaySeconds = 10
)

$ErrorActionPreference = "Continue"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$PythonExe = Join-Path $ProjectRoot ".venv\Scripts\python.exe"
$MainPy = Join-Path $ProjectRoot "main.py"
$LogDir = Join-Path $ProjectRoot "logs"
$LogFile = Join-Path $LogDir "jarvis_autorun.log"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

function Write-Log($Message) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$stamp] $Message"
}

Write-Log "Persistent launcher starting. ProjectRoot=$ProjectRoot"

if (-not (Test-Path $PythonExe)) {
    Write-Log "ERROR: Virtual environment Python not found at $PythonExe"
    Write-Log "Run setup first: python -m venv .venv; .\.venv\Scripts\python.exe -m pip install -r requirements.txt"
    exit 1
}

if (-not (Test-Path $MainPy)) {
    Write-Log "ERROR: main.py not found at $MainPy"
    exit 1
}

if (-not (Test-Path (Join-Path $ProjectRoot "config\api_keys.json"))) {
    Write-Log "ERROR: config\api_keys.json missing. JARVIS needs the Gemini API key config before autorun."
    exit 1
}

while ($true) {
    Write-Log "Starting JARVIS..."
    Push-Location $ProjectRoot
    try {
        & $PythonExe $MainPy *>> $LogFile
        $exitCode = $LASTEXITCODE
        Write-Log "JARVIS exited with code $exitCode. Restarting in $RestartDelaySeconds seconds."
    }
    catch {
        Write-Log "JARVIS crashed: $($_.Exception.Message). Restarting in $RestartDelaySeconds seconds."
    }
    finally {
        Pop-Location
    }
    Start-Sleep -Seconds $RestartDelaySeconds
}
