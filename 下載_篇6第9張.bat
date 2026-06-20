@echo off
chcp 65001 > nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://a.lovart.ai/artifacts/agent/CTxSGJxnYUGQXIYV.png' -OutFile 'C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-30_第6篇_序品第一\圖片\第6篇12之9_大眾激動法喜充滿.png' -UseBasicParsing; Write-Host 'Done!' -ForegroundColor Green; Get-Item 'C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-30_第6篇_序品第一\圖片\第6篇12之9_大眾激動法喜充滿.png' | Select-Object Name, Length, LastWriteTime"
echo.
pause
