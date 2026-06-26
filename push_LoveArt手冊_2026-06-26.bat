@echo off
chcp 65001 > nul
cd /d "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經"

echo === 阿地 14 號 LoveArt 完整操作手冊 + 血淚提醒 推送 GitHub ===
echo.

git add "阿地交接/技術報告/★★★LoveArt完整操作手冊_給阿墨_2026-06-26.md"
git add "阿地交接/技術報告/★★★血淚提醒_LoveArt畫布絕不可寫文字_2026-06-26.md"

echo.
echo === git status ===
git status --short

echo.
echo === commit ===
git commit -m "★ LoveArt 完整操作手冊 + 血淚提醒(給 Codex 阿墨用,WhatDog 10角色卡 SOP)"

echo.
echo === push ===
git push origin main

echo.
echo === 完成!======================================
echo 阿墨 git pull 就能拿到。
echo.
cmd /k
