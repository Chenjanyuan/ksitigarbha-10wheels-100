@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo  🪷 地藏經漫畫 LoveArt 自動生圖
echo ============================================
echo.
REM 金鑰從 Windows 環境變數讀（先跑過 2_設定金鑰_執行一次.bat）
python "生圖_LoveArt_API.py" %*
echo.
echo （跑完了。圖在各篇的「圖片」資料夾。紀錄在 生圖紀錄.log）
REM 排程半夜自動跑時，下面這行 pause 會被忽略；手動雙擊時會停住讓你看結果。
pause
