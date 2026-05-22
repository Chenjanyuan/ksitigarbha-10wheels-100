@echo off
cd /d "%~dp0"
echo Starting...
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0push_to_github.ps1"
echo.
echo === Finished. Press any key to close. ===
pause >nul
