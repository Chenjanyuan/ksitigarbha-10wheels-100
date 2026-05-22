@echo off
chcp 65001 > nul
cd /d "%~dp0"
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║          🪷  地藏經弘法・貼文審查介面                    ║
echo ║                                                          ║
echo ║   阿地準備內容,阿元預覽。OK 後一鍵推到 FB 排程 ✨        ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

REM 第一次跑會自動裝套件
python -c "import flask, docx, requests" 2>nul
if errorlevel 1 (
    echo 📦 第一次使用,正在安裝套件...
    pip install flask python-docx requests python-dotenv
    echo.
)

echo 🚀 啟動審查介面 (瀏覽器會自動打開)
echo.
echo 結束時請按 Ctrl+C 或關閉本視窗
echo.

python review.py

pause
