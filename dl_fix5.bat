@echo off
chcp 65001 > nul
cd /d "%~dp0"
echo ============================================
echo  Download 5 fix images (2026-06-20)
echo ============================================
echo.
if not exist "dl_fix5.ps1" (
    echo [ERROR] dl_fix5.ps1 not found!
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "dl_fix5.ps1"
echo.
echo ============================================
cmd /k
