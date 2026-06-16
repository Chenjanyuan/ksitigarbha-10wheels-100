@echo off
cd /d "%~dp0"
echo ============================================
echo  下載第23-29篇 (84張)
echo ============================================
if not exist "download_23to29.ps1" (
    echo [ERROR] 找不到 download_23to29.ps1！
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "download_23to29.ps1"
echo.
echo ============================================
pause
