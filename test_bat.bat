@echo on
echo Hello!
echo Current dir: %CD%
echo Script path: %~dp0
echo Looking for Python...
where python
where py
if exist "C:\Users\chenj\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" (
    echo Codex Python found
) else (
    echo Codex Python NOT FOUND
)
echo.
echo === Press any key to close ===
cmd /k
