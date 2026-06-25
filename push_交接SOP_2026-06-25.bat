@echo off
chcp 65001 > nul
cd /d "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經"

echo === 阿地 14 號完整交接 SOP 2026-06-25 推送到 GitHub ===
echo.

REM === 加新交接檔 ===
git add "阿地交接/交接SOP/★★★★★完整交接SOP_2026-06-25_阿地總集篇.md"
git add "阿地交接/交接SOP/★★★★★完整交接SOP_2026-06-25_第4章_LoveArt生圖.md"
git add "阿地交接/交接SOP/★★★★★完整交接SOP_2026-06-25_第5章_Meta上稿.md"
git add "阿地交接/交接SOP/★★★★★完整交接SOP_2026-06-25_第6-9章_下載十齋日GitHub排程.md"
git add "阿地交接/交接SOP/★★★★★完整交接SOP_2026-06-25_第10-12章_技能包排錯接班.md"
git add "阿地交接/交接SOP/一鍵貼_給下一棒阿地_2026-06-25.md"
git add CLAUDE.md

echo.
echo === git status ===
git status --short

echo.
echo === commit ===
git commit -m "★阿地14號完整交接SOP 2026-06-25 總集篇:角色+15死命令+LoveArt+Meta+下載+十齋日+GitHub+115行事曆+8技能包+20雷+接班3步"

echo.
echo === push ===
git push origin main

echo.
echo === 完成!======================================
echo 阿元可以在 GitHub 看到 6 個新 .md 檔。
echo.
cmd /k
