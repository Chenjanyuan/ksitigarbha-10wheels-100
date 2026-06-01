@echo off
chcp 65001 >nul
REM ===== Register a Windows scheduled task: auto-push jizang repo every 12 hours =====
REM Runs at 03:00 and 15:00 daily, only when you are logged on (PC need not be off).
set "HERE=%~dp0"

schtasks /Create /TN "PushJizangAuto" /TR "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"%HERE%push_jizang_auto.ps1\"" /SC HOURLY /MO 12 /ST 03:00 /F

echo.
echo ============================================================
echo  Done. Task "PushJizangAuto" created.
echo  It runs every 12 hours (03:00 and 15:00) and auto-pushes
echo  to GitHub only when there are changes.
echo  Log file: auto_push.log  (in this folder)
echo.
echo  To STOP it later, run:
echo    schtasks /Delete /TN "PushJizangAuto" /F
echo  To RUN it once now to test:
echo    schtasks /Run /TN "PushJizangAuto"
echo ============================================================
pause
