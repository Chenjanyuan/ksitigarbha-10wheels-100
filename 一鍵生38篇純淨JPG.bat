@echo on
chcp 65001 > nul
echo.
echo === Generate clean pianN_NN.jpg for pian 1-38 ===
echo.

set "BASE=%~dp0"
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
cmd /k
exit /b 1

:run
echo Using Python: %PY%
echo.
"%PY%" "%BASE%batch_make_ordered_jpg.py" 1 38 --force
echo.
echo === Script done, type 'exit' to close ===
cmd /k
