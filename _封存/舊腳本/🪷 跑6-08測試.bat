@echo off
chcp 65001 >nul
cd /d "%~dp0"
pip install google-genai pillow --quiet --disable-pip-version-check 2>nul
pip install "httpx[socks]" --quiet --disable-pip-version-check 2>nul
python test_6_08.py > 6-08_log.txt 2>&1
exit
