@echo off
chcp 65001 > nul
cd /d "%~dp0"
echo ============================================
echo  下載 5 張補圖 (2026-06-20)
echo ============================================
echo.
if not exist "下載_5張補圖_2026-06-20.ps1" (
    echo [ERROR] 找不到 PS1 檔!
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "下載_5張補圖_2026-06-20.ps1"
echo.
echo ============================================
cmd /k
