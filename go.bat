@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0go.ps1"
echo.
echo === Finished ===
pause >nul
