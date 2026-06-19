@echo off
setlocal

set "BASE=%~dp0"
set "LOG=%TEMP%\codex_playwright_config_patch.log"
set "SCRIPT="

for %%F in ("%BASE%*.ps1") do (
  echo %%~nxF | findstr /I "Playwright" > nul
  if not errorlevel 1 set "SCRIPT=%%~fF"
)

echo.
echo === Codex Playwright config patch ===
echo.

if not defined SCRIPT (
  echo Cannot find Playwright ps1 script in:
  echo %BASE%
  echo.
  pause
  exit /b 1
)

echo Script: %SCRIPT%
echo Log: %LOG%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" 1> "%LOG%" 2>&1
set "RC=%ERRORLEVEL%"

type "%LOG%"
echo.
echo === PowerShell done, exit code %RC% ===
echo Log: %LOG%
echo.
pause
exit /b %RC%
