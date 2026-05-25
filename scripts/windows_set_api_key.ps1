# Save your Gemini API key locally for MARK XXXIX / JARVIS.
# This writes config/api_keys.json, which is ignored by Git.
# Run from project root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows_set_api_key.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".\main.py")) {
    Write-Error "Please run this script from the project root folder where main.py exists."
}

if (-not (Test-Path ".\config")) {
    New-Item -ItemType Directory -Path ".\config" | Out-Null
}

$key = Read-Host "Paste your Gemini API key"
if ([string]::IsNullOrWhiteSpace($key)) {
    Write-Error "No API key entered."
}

$config = [ordered]@{
    gemini_api_key = $key.Trim()
    os_system = "windows"
}

$json = $config | ConvertTo-Json -Depth 4
Set-Content -Path ".\config\api_keys.json" -Value $json -Encoding UTF8

Write-Host "Saved config/api_keys.json locally. Do not commit this file." -ForegroundColor Green
