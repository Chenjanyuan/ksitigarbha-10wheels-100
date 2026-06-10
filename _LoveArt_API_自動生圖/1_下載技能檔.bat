@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo  下載 LoveArt 官方技能檔 agent_skill.py
echo ============================================
echo.
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/lovartai/lovart-skill/main/skills/lovart-skill/agent_skill.py' -OutFile 'agent_skill.py'; Write-Host '✓ 下載完成' } catch { Write-Host '✗ 下載失敗：' $_.Exception.Message }"
echo.
if exist agent_skill.py (echo ✓ 已就緒：agent_skill.py) else (echo ✗ 沒下載到，請檢查網路或手動到 github.com/lovartai/lovart-skill 下載)
echo.
pause
