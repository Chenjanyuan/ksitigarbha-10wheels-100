@echo off
REM Launcher — runs PowerShell script, keeps window open
cd /d "%~dp0"

echo Starting PowerShell script...
echo.
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0push_到_GitHub.ps1"

echo.
echo ==========================================
echo Script finished. Press any key to close.
echo ==========================================
pause > nul
