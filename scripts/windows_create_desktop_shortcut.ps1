# Create a Windows desktop shortcut for MARK XXXIX / JARVIS.
# You can run this from any folder:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_create_desktop_shortcut.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path

if (-not (Test-Path (Join-Path $ProjectRoot "main.py"))) {
    Write-Error "Could not locate main.py from script path: $ScriptDir"
}
$RunScript = Join-Path $ProjectRoot "scripts\windows_run.ps1"
if (-not (Test-Path $RunScript)) {
    Write-Error "Missing launcher script: $RunScript"
}

$Desktop = [Environment]::GetFolderPath("Desktop")
if (-not $Desktop) {
    Write-Error "Could not locate the current user's Desktop folder."
}

$ShortcutPath = Join-Path $Desktop "JARVIS MARK XXXIX.lnk"
$PowerShellExe = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
$VenvPython = Join-Path $ProjectRoot ".venv\Scripts\python.exe"

$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $PowerShellExe
$Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$RunScript`""
$Shortcut.WorkingDirectory = $ProjectRoot
$Shortcut.Description = "Launch ProductiveMind.Ai MARK XXXIX / JARVIS"

if (Test-Path $VenvPython) {
    $Shortcut.IconLocation = "$VenvPython,0"
} else {
    $Shortcut.IconLocation = "$PowerShellExe,0"
}

$Shortcut.Save()

Write-Host "Desktop shortcut created:" -ForegroundColor Green
Write-Host "  $ShortcutPath" -ForegroundColor White
Write-Host "Double-click it to start JARVIS." -ForegroundColor Cyan
