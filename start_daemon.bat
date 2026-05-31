@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
cd /d "%~dp0"
title Adi Daemon - Do Not Close
echo ====================================
echo  Gemini Nano Banana Pro Daemon
echo  ** Do NOT close this window **
echo  Press Ctrl+C to stop
echo ====================================
echo.
pip install google-genai --quiet --disable-pip-version-check 2>nul
pip install "httpx[socks]" --quiet --disable-pip-version-check 2>nul
python daemon.py
pause
