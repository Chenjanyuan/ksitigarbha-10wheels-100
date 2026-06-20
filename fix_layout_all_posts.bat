@echo off
chcp 65001 > nul
echo.
echo === Fix FB post text layout ===
echo.

set "BASE=%~dp0"
set "SCRIPT=%BASE%fix_layout_all_posts.py"
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
echo Install from: https://www.python.org/downloads/
echo.
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
