# 把剛才瀏覽器下載的第22篇圖片從 Downloads 搬到此資料夾
# 執行方法：右鍵 → 用 PowerShell 執行

$downloadsDir = "$env:USERPROFILE\Downloads"
$destDir = $PSScriptRoot

$files = @(
    "01_佛陀宣說本願力十種佛輪.png",
    "02_十種佛輪守護世界.png",
    "03_五濁惡世眾生受苦.png",
    "04_退沒一切白淨善法.png",
    "05_匱乏所有七聖財寶.png",
    "06_被斷常羅網覆蔽.png",
    "07_常乘惡趣車不怕後世苦.png",
    "08_佛陀如大仙尊位.png",
    "09_佛輪轉動降伏魔王外道.png",
    "10_佛王統治無王亂世.png",
    "11_最壞時代看到最深慈悲.jpg",
    "12_金剛藏菩薩捧經索取.png"
)

Write-Host "搬移第22篇圖片：Downloads → $destDir" -ForegroundColor Cyan

$moved = 0
$missing = 0
foreach ($file in $files) {
    $src = Join-Path $downloadsDir $file
    $dst = Join-Path $destDir $file
    if (Test-Path $src) {
        Move-Item $src $dst -Force
        Write-Host "✅ $file" -ForegroundColor Green
        $moved++
    } elseif (Test-Path $dst) {
        Write-Host "⚠️  已存在（跳過）：$file" -ForegroundColor Yellow
        $moved++
    } else {
        Write-Host "❌ 找不到：$file" -ForegroundColor Red
        $missing++
    }
}

Write-Host "`n完成！移入 $moved 張，找不到 $missing 張。" -ForegroundColor Yellow
Write-Host "目的地：$destDir"
Read-Host "按 Enter 關閉"
