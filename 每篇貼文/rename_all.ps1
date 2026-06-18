# rename_all.ps1 — 把 01-12.png 重新命名為「第N篇12之M_描述.png」
# 2026-06-18 阿地 製作 (v2 阿元拍板: 不補缺張/重複不複製/重新對應)
# ★ 用 Copy-Item (複製不刪除原檔), 安全第一
# ★ 重命名後的檔案放在各篇「圖片/已修正/」子資料夾

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

# ============================================================
# 第33篇 — 第七佛輪・五毒 (偏移2: 01=11/12, 02=12/12, 03=1/12...)
# ✅ 12張齊全, 內容正確
# ============================================================
$p33 = "$base\2026-08-06_第33篇_十輪品\圖片"
$p33out = "$p33\已修正"
New-Item -ItemType Directory -Force -Path $p33out | Out-Null

Copy-Item "$p33\03.png" "$p33out\第33篇12之01_佛陀說第七佛輪.png"
Copy-Item "$p33\04.png" "$p33out\第33篇12之02_國王收伏盜賊比方.png"
Copy-Item "$p33\05.png" "$p33out\第33篇12之03_五毒貪瞋癡慢疑.png"
Copy-Item "$p33\06.png" "$p33out\第33篇12之04_對付貪看清無常.png"
Copy-Item "$p33\07.png" "$p33out\第33篇12之05_對付瞋修慈悲.png"
Copy-Item "$p33\08.png" "$p33out\第33篇12之06_對付癡學智慧.png"
Copy-Item "$p33\09.png" "$p33out\第33篇12之07_對付慢知道無我.png"
Copy-Item "$p33\10.png" "$p33out\第33篇12之08_對付疑起信心.png"
Copy-Item "$p33\11.png" "$p33out\第33篇12之09_擦窗比喻煩惱.png"
Copy-Item "$p33\12.png" "$p33out\第33篇12之10_地藏合掌發願.png"
Copy-Item "$p33\01.png" "$p33out\第33篇12之11_啟發反思.png"
Copy-Item "$p33\02.png" "$p33out\第33篇12之12_經書索取.png"
Write-Host "[OK] 第33篇 12/12 張已修正" -ForegroundColor Green

# ============================================================
# 第34篇 — 第八佛輪・五戒 (偏移2, 缺4/12不補, 重複12/12不複製)
# ⚠️ 實際內容=五戒, 共11張
# ============================================================
$p34 = "$base\2026-08-07_第34篇_十輪品\圖片"
$p34out = "$p34\已修正"
New-Item -ItemType Directory -Force -Path $p34out | Out-Null

Copy-Item "$p34\03.png" "$p34out\第34篇12之01_佛陀說第八佛輪戒律.png"
Copy-Item "$p34\04.png" "$p34out\第34篇12之02_國王立法比喻.png"
Copy-Item "$p34\05.png" "$p34out\第34篇12之03_五戒石碑.png"
# 缺 4/12 (阿元決定不補)
Copy-Item "$p34\06.png" "$p34out\第34篇12之05_不偷盜市集.png"
Copy-Item "$p34\07.png" "$p34out\第34篇12之06_不邪淫家庭.png"
Copy-Item "$p34\08.png" "$p34out\第34篇12之07_不妄語樹下.png"
Copy-Item "$p34\09.png" "$p34out\第34篇12之08_不飲酒拒酒.png"
Copy-Item "$p34\10.png" "$p34out\第34篇12之09_戒律如護欄.png"
Copy-Item "$p34\11.png" "$p34out\第34篇12之10_比丘登階梯.png"
Copy-Item "$p34\01.png" "$p34out\第34篇12之11_啟發反思.png"
Copy-Item "$p34\02.png" "$p34out\第34篇12之12_經書索取.png"
# 12.png 是經書索取重複, 不複製
Write-Host "[OK] 第34篇 11/12 張已修正 (缺4/12, 重複不複製)" -ForegroundColor Yellow

# ============================================================
# 第35篇 — 善知識・第九佛輪 (順序正確 1-12)
# ✅ 12張齊全, 內容正確
# ============================================================
$p35 = "$base\2026-08-10_第35篇_十輪品\圖片"
$p35out = "$p35\已修正"
New-Item -ItemType Directory -Force -Path $p35out | Out-Null

Copy-Item "$p35\01.png" "$p35out\第35篇12之01_佛陀坐石說第九佛輪.png"
Copy-Item "$p35\02.png" "$p35out\第35篇12之02_小沙彌餵流浪狗.png"
Copy-Item "$p35\03.png" "$p35out\第35篇12之03_小沙彌問師父.png"
Copy-Item "$p35\04.png" "$p35out\第35篇12之04_小沙彌摸狗領悟.png"
Copy-Item "$p35\05.png" "$p35out\第35篇12之05_年輕人山洞打坐.png"
Copy-Item "$p35\06.png" "$p35out\第35篇12之06_老和尚林中指導.png"
Copy-Item "$p35\07.png" "$p35out\第35篇12之07_年輕人感恩哭泣.png"
Copy-Item "$p35\08.png" "$p35out\第35篇12之08_老和尚提燈夜行.png"
Copy-Item "$p35\09.png" "$p35out\第35篇12之09_大眾菩提樹合掌.png"
Copy-Item "$p35\10.png" "$p35out\第35篇12之10_佛陀蓮座總結.png"
Copy-Item "$p35\11.png" "$p35out\第35篇12之11_啟發反思.png"
Copy-Item "$p35\12.png" "$p35out\第35篇12之12_經書索取.png"
Write-Host "[OK] 第35篇 12/12 張已修正" -ForegroundColor Green

# ============================================================
# 第36篇 — 涅槃・第十佛輪 (順序正確 1-12)
# ✅ 12張齊全, 內容正確
# ============================================================
$p36 = "$base\2026-08-11_第36篇_十輪品\圖片"
$p36out = "$p36\已修正"
New-Item -ItemType Directory -Force -Path $p36out | Out-Null

Copy-Item "$p36\01.png" "$p36out\第36篇12之01_佛陀說涅槃.png"
Copy-Item "$p36\02.png" "$p36out\第36篇12之02_佛陀問追求什麼.png"
Copy-Item "$p36\03.png" "$p36out\第36篇12之03_佛陀說世間苦.png"
Copy-Item "$p36\04.png" "$p36out\第36篇12之04_大眾反思.png"
Copy-Item "$p36\05.png" "$p36out\第36篇12之05_苾芻問涅槃.png"
Copy-Item "$p36\06.png" "$p36out\第36篇12之06_佛陀大笑解說.png"
Copy-Item "$p36\07.png" "$p36out\第36篇12之07_年輕人懸崖喻涅槃.png"
Copy-Item "$p36\08.png" "$p36out\第36篇12之08_老人湖邊喻涅槃.png"
Copy-Item "$p36\09.png" "$p36out\第36篇12之09_老鷹飛翔喻脫離.png"
Copy-Item "$p36\10.png" "$p36out\第36篇12之10_佛陀總結十佛輪.png"
Copy-Item "$p36\11.png" "$p36out\第36篇12之11_啟發反思.png"
Copy-Item "$p36\12.png" "$p36out\第36篇12之12_經書索取.png"
Write-Host "[OK] 第36篇 12/12 張已修正" -ForegroundColor Green

# ============================================================
# 第37篇 — 王十輪 (前2張是EP36涅槃重複=不複製, 缺11/12和12/12不補)
# 共10張
# ============================================================
$p37 = "$base\2026-08-12_第37篇_十輪品\圖片"
$p37out = "$p37\已修正"
New-Item -ItemType Directory -Force -Path $p37out | Out-Null

# 01.png 和 02.png 是涅槃(EP36)重複, 不複製
Copy-Item "$p37\03.png" "$p37out\第37篇12之01_佛陀講王十輪.png"
Copy-Item "$p37\04.png" "$p37out\第37篇12之02_苾芻問好國王.png"
Copy-Item "$p37\05.png" "$p37out\第37篇12之03_國王好名聲.png"
Copy-Item "$p37\06.png" "$p37out\第37篇12之04_國王眾人歡笑.png"
Copy-Item "$p37\07.png" "$p37out\第37篇12之05_美名傳十方.png"
Copy-Item "$p37\08.png" "$p37out\第37篇12之06_天神護持.png"
Copy-Item "$p37\09.png" "$p37out\第37篇12之07_小國王拒打仗.png"
Copy-Item "$p37\10.png" "$p37out\第37篇12之08_小國王施政濟民.png"
Copy-Item "$p37\11.png" "$p37out\第37篇12之09_鄰國臣服.png"
Copy-Item "$p37\12.png" "$p37out\第37篇12之10_佛陀總結.png"
# 缺 11/12 和 12/12 (阿元決定不補)
Write-Host "[OK] 第37篇 10/12 張已修正 (涅槃重複不複製, 缺11+12不補)" -ForegroundColor Yellow

# ============================================================
# 第38篇 — 壞國王 (偏移2, 最後12.png是EP37袈裟=不複製, 缺10/12不補)
# 共11張
# ============================================================
$p38 = "$base\2026-08-13_第38篇_十輪品\圖片"
$p38out = "$p38\已修正"
New-Item -ItemType Directory -Force -Path $p38out | Out-Null

Copy-Item "$p38\03.png" "$p38out\第38篇12之01_壞國王登場.png"
Copy-Item "$p38\04.png" "$p38out\第38篇12之02_不信因果.png"
Copy-Item "$p38\05.png" "$p38out\第38篇12之03_欺壓百姓.png"
Copy-Item "$p38\06.png" "$p38out\第38篇12之04_驅逐僧人.png"
Copy-Item "$p38\07.png" "$p38out\第38篇12之05_毀壞寺廟.png"
Copy-Item "$p38\08.png" "$p38out\第38篇12之06_天災降臨.png"
Copy-Item "$p38\09.png" "$p38out\第38篇12之07_百姓受苦.png"
Copy-Item "$p38\10.png" "$p38out\第38篇12之08_國王後悔.png"
Copy-Item "$p38\11.png" "$p38out\第38篇12之09_瘟疫大旱.png"
# 缺 10/12 (阿元決定不補)
Copy-Item "$p38\01.png" "$p38out\第38篇12之11_啟發反思.png"
Copy-Item "$p38\02.png" "$p38out\第38篇12之12_經書索取.png"
# 12.png 是EP37袈裟功德重複, 不複製
Write-Host "[OK] 第38篇 11/12 張已修正 (袈裟重複不複製, 缺10不補)" -ForegroundColor Yellow

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "全部完成!" -ForegroundColor Cyan
Write-Host "修正後的檔案在各篇「圖片\已修正\」資料夾" -ForegroundColor Cyan
Write-Host "原始 01-12.png 不動, 安全備份" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "統計:" -ForegroundColor White
Write-Host "  第33篇: 12/12 OK" -ForegroundColor Green
Write-Host "  第34篇: 11/12 (缺4/12)" -ForegroundColor Yellow
Write-Host "  第35篇: 12/12 OK" -ForegroundColor Green
Write-Host "  第36篇: 12/12 OK" -ForegroundColor Green
Write-Host "  第37篇: 10/12 (缺11+12)" -ForegroundColor Yellow
Write-Host "  第38篇: 11/12 (缺10)" -ForegroundColor Yellow
Write-Host "  合計: 68/72 張" -ForegroundColor White
