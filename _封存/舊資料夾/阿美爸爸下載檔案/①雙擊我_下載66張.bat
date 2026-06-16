@echo off
chcp 65001 >nul
powershell -ExecutionPolicy Bypass -File "%~dp0下載66張_raw_2026-06-04.ps1"
echo.
echo ===== 下載完成，可關閉 =====
pause
