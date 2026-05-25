# Remove MARK XXXIX / JARVIS Windows scheduled autostart task.
# Run from project root or anywhere:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_uninstall_autostart.ps1

$ErrorActionPreference = "Continue"
$TaskName = "ProductiveMind JARVIS MARK XXXIX"

Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "Removed scheduled task if it existed: $TaskName" -ForegroundColor Green
