@echo off
chcp 65001 > nul
echo.
echo === Run config patch ===
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0改config永久解_Playwright路徑.ps1"
echo.
echo === PowerShell done ===
echo.
pause
