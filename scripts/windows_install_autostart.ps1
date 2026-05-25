# Install MARK XXXIX / JARVIS as a Windows scheduled task.
# Run from project root in PowerShell:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_install_autostart.ps1
#
# Behavior:
# - Starts JARVIS when you log in.
# - Uses scripts\windows_autorun_loop.ps1 to relaunch JARVIS if it exits.
# - Runs in your interactive user session so desktop/audio automation can work.

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".\main.py")) {
    Write-Error "Please run this script from the project root folder where main.py exists."
}

$ProjectRoot = (Resolve-Path ".").Path
$LoopScript = Join-Path $ProjectRoot "scripts\windows_autorun_loop.ps1"
$TaskName = "ProductiveMind JARVIS MARK XXXIX"

if (-not (Test-Path $LoopScript)) {
    Write-Error "Missing $LoopScript"
}

if (-not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Error "Missing .venv. Run setup first, then install autostart."
}

if (-not (Test-Path ".\config\api_keys.json")) {
    Write-Error "Missing config\api_keys.json. Add your Gemini API key first."
}

$PowerShellExe = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$LoopScript`""

$Action = New-ScheduledTaskAction -Execute $PowerShellExe -Argument $Arguments -WorkingDirectory $ProjectRoot
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -RestartCount 999 `
    -RestartInterval (New-TimeSpan -Minutes 1)

$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel LeastPrivilege

try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
} catch {}

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal | Out-Null

Write-Host "Installed scheduled task: $TaskName" -ForegroundColor Green
Write-Host "Starting it now..." -ForegroundColor Cyan
Start-ScheduledTask -TaskName $TaskName
Write-Host "Done. JARVIS should now start at login and relaunch if it exits." -ForegroundColor Green
Write-Host "Log file:" -ForegroundColor Cyan
Write-Host "  $ProjectRoot\logs\jarvis_autorun.log"
