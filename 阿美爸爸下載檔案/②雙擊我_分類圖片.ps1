# 把 _raw 的 hash 圖，依對照表複製+改名到「分類_最終」（可重跑，覆蓋）
$ErrorActionPreference="SilentlyContinue"
$base="C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\阿美爸爸下載檔案"
$raw="$base\_raw"; $dst="$base\分類_最終"
function E($p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Path $p -Force | Out-Null } }
E "$dst\篇07"; Copy-Item "$raw\0mJ3pWq2Nh8FBYsf.png" "$dst\篇07\篇07-04_六比喻清涼月.png" -Force
E "$dst\篇08"; Copy-Item "$raw\0pKSwpBPZrGiY37T.png" "$dst\篇08\篇08-05_八十百千眷屬列隊.png" -Force
E "$dst\篇07"; Copy-Item "$raw\20u4XKQPAPJwTJAc.png" "$dst\篇07\篇07-06_六比喻資糧.png" -Force
E "$dst\篇10"; Copy-Item "$raw\2REIlj8JFEEyo0Fq.png" "$dst\篇10\篇10-03_久修諸苦行[第八句].png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\2RnSXH5eqOFwTWm5.png" "$dst\_待阿元確認\他比家人更近從不離開_2RnSXH5eqOFwTWm5.png" -Force
E "$dst\篇10"; Copy-Item "$raw\3TeAF29k4eHxW6op.png" "$dst\篇10\篇10-04_供事無量諸佛[第九句].png" -Force
E "$dst\篇11"; Copy-Item "$raw\3W7QK4BDGv9tdDwq.png" "$dst\篇11\篇11-04_第三波衣服.png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\4JHJumCACn9dviNj.png" "$dst\_待阿元確認\佛陀介紹地藏三摩地_4JHJumCACn9dviNj.png" -Force
E "$dst\篇07"; Copy-Item "$raw\4fOYMfgsOn4FIIHW.png" "$dst\篇07\篇07-01_六比喻開場[佛陀龍王].png" -Force
E "$dst\篇09"; Copy-Item "$raw\4fzJ2N4XxBJyJoNV.png" "$dst\篇09\篇09-04_安忍如大地[第二句].png" -Force
E "$dst\篇10"; Copy-Item "$raw\56ZWLIyPsq8QToqf.png" "$dst\篇10\篇10-10_大眾承擔落淚.png" -Force
E "$dst\篇07\_重出"; Copy-Item "$raw\5RuvebPix995fov5.png" "$dst\篇07\_重出\篇07-01_六比喻開場[地藏版_重出]_5RuvebPix995fov5.png" -Force
E "$dst\篇08"; Copy-Item "$raw\6ufEBWOWNRCnV9I3.png" "$dst\篇08\篇08-09_盛大繞佛眷屬.png" -Force
E "$dst\_疑廢無頁碼"; Copy-Item "$raw\84ueofkCkCBOHSuO.png" "$dst\_疑廢無頁碼\84ueofkCkCBOHSuO.png" -Force
E "$dst\_通用12格索取"; Copy-Item "$raw\8U72AgLqS33kKLA1.png" "$dst\_通用12格索取\觀音捧本願經[通用12]_8U72AgLqS33kKLA1.png" -Force
E "$dst\篇10"; Copy-Item "$raw\8gtuhmUCSALFNZoo.png" "$dst\篇10\篇10-11_啟發反思捐血.png" -Force
E "$dst\篇11"; Copy-Item "$raw\BAhyax52vzAE61Qi.png" "$dst\篇11\篇11-02_第一波天人撒花.png" -Force
E "$dst\_疑廢無頁碼"; Copy-Item "$raw\CFlbc48MctFMpQnr.png" "$dst\_疑廢無頁碼\CFlbc48MctFMpQnr.png" -Force
E "$dst\_疑廢無頁碼"; Copy-Item "$raw\Cw9jp7CP6G4TTi6H.png" "$dst\_疑廢無頁碼\Cw9jp7CP6G4TTi6H.png" -Force
E "$dst\篇09"; Copy-Item "$raw\FFlL4bGCzv7SqfLV.png" "$dst\篇09\篇09-10_大眾紅了眼眶.png" -Force
E "$dst\_通用12格索取"; Copy-Item "$raw\FkPgwiQPDt22T8LQ.png" "$dst\_通用12格索取\捧本願經[佛陀版_重出]_FkPgwiQPDt22T8LQ.png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\GVr0nnsudv7UQ2Wg.png" "$dst\_待阿元確認\啟發反思雙佛+現代_GVr0nnsudv7UQ2Wg.png" -Force
E "$dst\篇09"; Copy-Item "$raw\GZr6ZJQctpAqIBhb.png" "$dst\篇09\篇09-07_永絕愛網[第五句].png" -Force
E "$dst\篇10"; Copy-Item "$raw\HsPHVxKjgJDEH8c4.png" "$dst\篇10\篇10-02_本願攝穢土[第七句].png" -Force
E "$dst\篇07"; Copy-Item "$raw\KWXb9rioAFDXl0lb.png" "$dst\篇07\篇07-03_六比喻明炬.png" -Force
E "$dst\_通用12格索取"; Copy-Item "$raw\La4pQgHyLP1dkAOi.png" "$dst\_通用12格索取\觀音捧本願經_La4pQgHyLP1dkAOi.png" -Force
E "$dst\篇08"; Copy-Item "$raw\MyvJGV833nD8kFfW.png" "$dst\篇08\篇08-02_金光越靠近全場屏息.png" -Force
E "$dst\篇09"; Copy-Item "$raw\NKitfdITyJJFgw74.png" "$dst\篇09\篇09-02_地藏開口讚佛.png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\Okr52vswgXGrNYTH.png" "$dst\_待阿元確認\啟發反思公園陪伴_Okr52vswgXGrNYTH.png" -Force
E "$dst\篇11"; Copy-Item "$raw\PEat0c5Y7U37JOJ2.png" "$dst\篇11\篇11-01_大眾感動決定供養.png" -Force
E "$dst\篇09"; Copy-Item "$raw\QiND9wTaYl9NwvIb.png" "$dst\篇09\篇09-11_啟發反思說真心話.png" -Force
E "$dst\篇07"; Copy-Item "$raw\RHYrHVXaXUERuuSj.png" "$dst\篇07\篇07-02_六比喻朗日.png" -Force
E "$dst\篇10"; Copy-Item "$raw\TwHGM0PQeBER3E5w.png" "$dst\篇10\篇10-06_濟有情病死陪病.png" -Force
E "$dst\_通用12格索取"; Copy-Item "$raw\V1quUGTuXGJEFIzx.png" "$dst\_通用12格索取\觀音捧本願經_V1quUGTuXGJEFIzx.png" -Force
E "$dst\篇07"; Copy-Item "$raw\W7uaCaIPyv7tsxXy.png" "$dst\篇07\篇07-10_預告地藏南方來.png" -Force
E "$dst\篇08"; Copy-Item "$raw\YCxVlv8w1I6jTNuk.png" "$dst\篇08\篇08-08_右繞三匝.png" -Force
E "$dst\篇09"; Copy-Item "$raw\a0LpWoJYPx3OBHEJ.png" "$dst\篇09\篇09-08_如實善安住.png" -Force
E "$dst\_疑廢無頁碼"; Copy-Item "$raw\e2m0FsqLA6Kaotsr.png" "$dst\_疑廢無頁碼\e2m0FsqLA6Kaotsr.png" -Force
E "$dst\篇10"; Copy-Item "$raw\e5VFs1taL3GiRGPy.png" "$dst\篇10\篇10-01_地藏轉向講本願.png" -Force
E "$dst\篇09"; Copy-Item "$raw\eprqRQZKp820ubQq.png" "$dst\篇09\篇09-01_地藏即將開口.png" -Force
E "$dst\篇09"; Copy-Item "$raw\eq7HJzzwxXFCNopC.png" "$dst\篇09\篇09-03_慈心如天空[第一句].png" -Force
E "$dst\篇08"; Copy-Item "$raw\ffFwC0RO6U7P17fo.png" "$dst\篇08\篇08-01_南方天空金光.png" -Force
E "$dst\篇08"; Copy-Item "$raw\ghV7nBZO4D2bHoKz.png" "$dst\篇08\篇08-10_合掌站立佛前.png" -Force
E "$dst\篇09"; Copy-Item "$raw\grXZm8CXjJaB5Z6G.png" "$dst\篇09\篇09-05_佛陀殊勝相好[第三句].png" -Force
E "$dst\篇08"; Copy-Item "$raw\hFr1CvgvT9Aurutm.png" "$dst\篇08\篇08-04_全場大眾驚訝.png" -Force
E "$dst\篇10"; Copy-Item "$raw\i25kP4Ce8QAIa9Jc.png" "$dst\篇10\篇10-07_自舍多身命[十一句].png" -Force
E "$dst\篇09"; Copy-Item "$raw\mte8fvl2V7D8fRO1.png" "$dst\篇09\篇09-06_慈悲充滿諸佛國[第四句].png" -Force
E "$dst\篇08"; Copy-Item "$raw\o8JGOwD3tX7kghjT.png" "$dst\篇08\篇08-07_頂禮佛陀雙足.png" -Force
E "$dst\篇10"; Copy-Item "$raw\o8eyZnQL7fGWzIxe.png" "$dst\篇10\篇10-05_濟有情飢渴端食.png" -Force
E "$dst\_疑廢無頁碼"; Copy-Item "$raw\oYOFJllbHHBcQj01.png" "$dst\_疑廢無頁碼\oYOFJllbHHBcQj01.png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\pBKneMApcbNwZq0e.png" "$dst\_待阿元確認\佛陀介紹地藏三摩地[重出]_pBKneMApcbNwZq0e.png" -Force
E "$dst\篇11"; Copy-Item "$raw\qaTx3iIvgSCA4oXr.png" "$dst\篇11\篇11-03_第二波龍王獻寶.png" -Force
E "$dst\篇09"; Copy-Item "$raw\tbo70obC5ZAtySxf.png" "$dst\篇09\篇09-09_舍清淨國度染濁[第六句].png" -Force
E "$dst\篇07\_重出"; Copy-Item "$raw\uD9QYTr9ES6tgGpC.png" "$dst\篇07\_重出\篇07-01_六比喻開場[佛陀坐_重出]_uD9QYTr9ES6tgGpC.png" -Force
E "$dst\篇07\_重出"; Copy-Item "$raw\vQWNygmBNp2ymDpT.png" "$dst\篇07\_重出\篇07-02_六比喻朗日[重出]_vQWNygmBNp2ymDpT.png" -Force
E "$dst\篇10"; Copy-Item "$raw\vwPiUla4Ej5AxYSp.png" "$dst\篇10\篇10-09_棄自安樂[十三句].png" -Force
E "$dst\篇10"; Copy-Item "$raw\x9yDXAvqOL2Hjf0C.png" "$dst\篇10\篇10-08_舍多骨血皮[十二句].png" -Force
E "$dst\篇07"; Copy-Item "$raw\xmAPOoJtWnDQzXq1.png" "$dst\篇07\篇07-05_六比喻車乘.png" -Force
E "$dst\篇07"; Copy-Item "$raw\yc4gYu5Rdf69QXej.png" "$dst\篇07\篇07-07_六比喻嚮導.png" -Force
E "$dst\篇08"; Copy-Item "$raw\zFlYSJJgdQ51q61Q.png" "$dst\篇08\篇08-03_地藏首次登場.png" -Force
E "$dst\_待阿元確認"; Copy-Item "$raw\zb5Uk9EVYR10xJ3n.png" "$dst\_待阿元確認\佛介紹地藏無頁碼_zb5Uk9EVYR10xJ3n.png" -Force
Write-Host "✅ 分類完成 → 分類_最終 資料夾" -ForegroundColor Cyan
Get-ChildItem $dst -Directory | ForEach-Object { Write-Host ("[" + $_.Name + "] " + (Get-ChildItem $_.FullName -File).Count + " 張") }
