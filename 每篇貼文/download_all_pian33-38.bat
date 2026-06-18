@echo off
chcp 65001 >nul
echo ============================================
echo   Download ALL Pian33-38 (72 images)
echo ============================================

call "%~dp0\2026-08-06_第33篇_十輪品\圖片\download_pian33.bat" < nul
call "%~dp0\2026-08-07_第34篇_十輪品\圖片\download_pian34.bat" < nul
call "%~dp0\2026-08-10_第35篇_十輪品\圖片\download_pian35.bat" < nul
call "%~dp0\2026-08-11_第36篇_十輪品\圖片\download_pian36.bat" < nul
call "%~dp0\2026-08-12_第37篇_十輪品\圖片\download_pian37.bat" < nul
call "%~dp0\2026-08-13_第38篇_十輪品\圖片\download_pian38.bat" < nul

echo ============================================
echo   ALL DONE! 72 images downloaded.
echo   Check each folder for 01.png - 12.png
echo ============================================
pause
