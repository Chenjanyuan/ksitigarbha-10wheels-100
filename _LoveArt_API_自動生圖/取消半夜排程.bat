@echo off
chcp 65001 >nul
schtasks /delete /tn "地藏_LoveArt自動生圖" /f
echo ✓ 已取消半夜自動生圖排程。
pause
