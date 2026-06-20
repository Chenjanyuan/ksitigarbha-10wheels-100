@echo off
chcp 65001 > nul
echo.
echo === Regenerate pian 7 clean JPG (pian7_01.jpg ~ pian7_12.jpg) ===
echo.

set "BASE=%~dp0"
set "TARGET=%BASE%每篇貼文\2026-07-01_第7篇_序品第一\FB上傳用_有序JPG"
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
echo Step 1: Clean old JPG in %TARGET%
if exist "%TARGET%" rd /s /q "%TARGET%"
echo.

echo Step 2: Run make_fb_ordered_jpg.py --serial 7
"%PY%" "%BASE%make_fb_ordered_jpg.py" --serial 7 --start "2026-07-01 08:00:00"
echo.

echo Step 3: List result
dir /b "%TARGET%"
echo.
echo === Done! 12 clean pian7_NN.jpg ready ===
pause
