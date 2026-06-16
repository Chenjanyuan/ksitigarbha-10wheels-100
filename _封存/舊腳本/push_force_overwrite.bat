@echo off
cd /d "%~dp0"
echo Starting Force Push...
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0push_force_overwrite.ps1"
echo.
echo === Finished. Press any key. ===
pause >nul
