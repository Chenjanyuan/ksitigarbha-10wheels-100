@echo off
chcp 65001 > nul
echo.
echo === Download 11 LoveArt images today (2026-06-20) ===
echo.

set "BASE=%~dp0"
set "SCRIPT=%BASE%下載_今日全部11張.py"
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

where python >nul 2>nul
if not errorlevel 1 (
    set "PY=python"
    goto run
)

echo ERROR: Python not found!
pause
exit /b 1

:run
echo Using Python: %PY%
echo Running: %SCRIPT%
echo.
"%PY%" "%SCRIPT%"
set "RC=%ERRORLEVEL%"
echo.
echo === Done, exit code %RC% ===
echo.
pause
exit /b %RC%
