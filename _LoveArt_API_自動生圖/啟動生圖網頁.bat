@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo  Starting Image-Gen UI ...
echo  If the browser does not open automatically,
echo  open your browser and go to:
echo      http://127.0.0.1:8770
echo  Keep this black window OPEN (it is the server).
echo ============================================
echo.
python launch.py 2> error_log.txt
echo.
echo ===== error log (if startup failed) =====
type error_log.txt
echo =========================================
echo (Screenshot this window for 阿研 if it failed)
pause
