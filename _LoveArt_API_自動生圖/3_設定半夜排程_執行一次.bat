@echo off
chcp 65001 >nul
cd /d "%~dp0"
REM 設定每天半夜 01:30 自動跑生圖（對上 LoveArt 半夜人少、免費無限模式）
REM 想改時間：把下面的 01:30 換成你要的（24 小時制）。
schtasks /create /tn "地藏_LoveArt自動生圖" /tr "\"%~dp0執行_自動生圖.bat\"" /sc daily /st 01:30 /f
echo.
echo ✓ 已設定：每天 01:30 自動生圖（工作名稱：地藏_LoveArt自動生圖）
echo   - 要它有效，電腦那時要『開著』（不用登入畫面，但別關機/休眠）。
echo   - 取消排程：執行『取消半夜排程.bat』或在「工作排程器」刪掉它。
echo.
pause
