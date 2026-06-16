@echo off
cd /d "%~dp0"
echo ============================================
echo  補下載第27篇10-12 + 第28-29篇 (共27張)
echo ============================================
powershell -NoProfile -ExecutionPolicy Bypass -File "download_27to29_補.ps1"
echo.
echo ============================================
pause
