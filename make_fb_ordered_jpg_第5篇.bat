@echo off
setlocal
set "PY=C:\Users\chenj\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
set "BASE=%~dp0"
set "POST=2026-06-29"

"%PY%" "%BASE%make_fb_ordered_jpg.py" --serial 5 --start "2026-06-29 08:00:00"
echo.
pause
