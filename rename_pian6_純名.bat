@echo off
chcp 65001 > nul
echo.
echo === Rename pian 6 JPG to pure 01-12 (no 12之X prefix) ===
echo.

set "BASE=%~dp0"
set "SCRIPT=%BASE%rename_pian6_純名.py"
set "PY="

if exist "C:\Users\chenj\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" (
    set "PY=C:\Users\chenj\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
    goto run
)

where py >nul 2>nul
if not errorlevel 1 (
    set "PY=py"
    goto run
)

echo ERROR: Python not found!
pause
exit /b 1

:run
echo Using Python: %PY%
"%PY%" "%SCRIPT%"
echo.
pause
