@echo off
chcp 65001 >nul
echo ============================================
echo   篇38 圖片下載腳本 (12張)
echo   目標資料夾: %~dp0
echo ============================================
echo.

set "DIR=%~dp0"

echo [1/12] 下載 P1 佛陀勸誡在家俗人不應毀辱出家人...
curl -s -o "%DIR%01_佛陀勸誡不毀辱出家人.png" "https://a.lovart.ai/artifacts/agent/0eCf2uIzY35BOUTH.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [2/12] 下載 P2 常見場景俗人見破戒沙門就罵...
curl -s -o "%DIR%02_常見場景俗人見破戒就罵.png" "https://a.lovart.ai/artifacts/agent/3lF56PPM35GkntWn.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [3/12] 下載 P3 果報一口生惡瘡三日不能言...
curl -s -o "%DIR%03_果報一口生惡瘡.png" "https://a.lovart.ai/artifacts/agent/uK9P6a5dmG7fsWGa.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [4/12] 下載 P4 果報二舌生燋爛食不知味...
curl -s -o "%DIR%04_果報二舌生燋爛.png" "https://a.lovart.ai/artifacts/agent/3HQPbswU1j7eedO3.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [5/12] 下載 P5 果報三親屬離散家不和...
curl -s -o "%DIR%05_果報三親屬離散.png" "https://a.lovart.ai/artifacts/agent/T6N8k7GUrYDNh4ey.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [6/12] 下載 P6 果報四財物耗散漸至貧困...
curl -s -o "%DIR%06_果報四財物耗散.png" "https://a.lovart.ai/artifacts/agent/g2X8fhTtbeLOZ6Ee.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [7/12] 下載 P7 若至誠懺悔罪業可減重者轉輕...
curl -s -o "%DIR%07_若至誠懺悔罪業可減.png" "https://a.lovart.ai/artifacts/agent/DzmDUIdZ7N5U5EZB.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [8/12] 下載 P8 敬僧者得大福報子孫和睦...
curl -s -o "%DIR%08_敬僧者得大福報.png" "https://a.lovart.ai/artifacts/agent/XXBBKE7uE7JWlvSh.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [9/12] 下載 P9 敬僧者家庭和樂衣食無缺...
curl -s -o "%DIR%09_敬僧者家庭和樂.png" "https://a.lovart.ai/artifacts/agent/pOvOt72cfK8o3wLB.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [10/12] 下載 P10 佛陀勸誡敬僧得福毀者得殃...
curl -s -o "%DIR%10_佛陀勸誡敬僧得福.png" "https://a.lovart.ai/artifacts/agent/WWZOhek6nDJfv3Uo.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [11/12] 下載 P11 聖嚴法師開示口下留情就是口下積德...
curl -s -o "%DIR%11_啟發反思.png" "https://a.lovart.ai/artifacts/agent/kjBeLrFtXv3pFxTU.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo [12/12] 下載 P12 免費索取地藏菩薩本願經結緣...
curl -s -o "%DIR%12_經書索取.png" "https://a.lovart.ai/artifacts/agent/21kmAOZoDXBkIS19.png"
if %errorlevel%==0 (echo   ✓ 完成) else (echo   ✗ 失敗!)

echo.
echo ============================================
echo   下載完成! 請確認 12 張圖片都在:
echo   %DIR%
echo ============================================
dir "%DIR%*.png" /b
echo.
pause
