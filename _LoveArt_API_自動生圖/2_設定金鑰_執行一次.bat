@echo off
chcp 65001 >nul
REM ╔══════════════════════════════════════════════════════════╗
REM ║  把下面兩行的 ak_xxx / sk_xxx 換成你自己的 LoveArt 金鑰      ║
REM ║  （在 LoveArt 頭像選單 → Lovart 龙虾 → AK/SK Management 拿）  ║
REM ║  改好後存檔、雙擊執行一次即可。                              ║
REM ║  ⚠ 這把鑰匙是密碼：跑完建議把本檔刪掉，別上傳 GitHub、別外傳。 ║
REM ╚══════════════════════════════════════════════════════════╝

setx LOVART_ACCESS_KEY "ak_換成你的存取金鑰"
setx LOVART_SECRET_KEY "sk_換成你的秘密金鑰"

echo.
echo ✓ 金鑰已寫入 Windows 使用者環境變數。
echo   （請『關掉這個視窗、重新開一個』才會生效）
echo.
pause
