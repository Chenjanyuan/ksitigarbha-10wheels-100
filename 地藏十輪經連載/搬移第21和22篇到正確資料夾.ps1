# 把瀏覽器剛下載的第21篇和第22篇圖片搬到正確位置
# 執行方法：右鍵 → 用 PowerShell 執行

$downloadsDir = "$env:USERPROFILE\Downloads"
$baseDir = $PSScriptRoot

Write-Host "=== 搬移第21篇 → 20260624 ===" -ForegroundColor Cyan
$dir21 = Join-Path $baseDir "20260624"
if (-not (Test-Path $dir21)) { New-Item -ItemType Directory -Path $dir21 | Out-Null }

$files21 = @(
    "01_序品結束新品將始.png",
    "02_地藏菩薩起身整理袈裟.png",
    "03_地藏菩薩走向佛陀全場屏息.png",
    "04_地藏菩薩頂禮佛足.png",
    "05_地藏菩薩恭敬請問姿勢.png",
    "06_地藏菩薩以詩偈請問.png",
    "07_佛陀允許發問地藏歡喜.png",
    "08_地藏菩薩訴說十三大劫苦行.png",
    "09_地藏菩薩悲憫望向苦難世間.png",
    "10_地藏菩薩懇切問出關鍵問題.png",
    "11_現代人對心發問.png",
    "12_虛空藏菩薩捧經索取.png"
)

$moved21 = 0
foreach ($file in $files21) {
    $src = Join-Path $downloadsDir $file
    $dst = Join-Path $dir21 $file
    if (Test-Path $src) {
        Move-Item $src $dst -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
        $moved21++
    } elseif (Test-Path $dst) {
        Write-Host "  ⚠️  已存在：$file" -ForegroundColor Yellow
        $moved21++
    } else {
        Write-Host "  ❌ 找不到：$file" -ForegroundColor Red
    }
}
Write-Host "第21篇：移入 $moved21/12 張`n"

Write-Host "=== 搬移第22篇 → 20260625 ===" -ForegroundColor Cyan
$dir22 = Join-Path $baseDir "20260625"
if (-not (Test-Path $dir22)) { New-Item -ItemType Directory -Path $dir22 | Out-Null }

$files22 = @(
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

$moved22 = 0
foreach ($file in $files22) {
    $src = Join-Path $downloadsDir $file
    $dst = Join-Path $dir22 $file
    if (Test-Path $src) {
        Move-Item $src $dst -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
        $moved22++
    } elseif (Test-Path $dst) {
        Write-Host "  ⚠️  已存在：$file" -ForegroundColor Yellow
        $moved22++
    } else {
        Write-Host "  ❌ 找不到：$file" -ForegroundColor Red
    }
}
Write-Host "第22篇：移入 $moved22/12 張`n"

Write-Host "完成！第21篇 $moved21/12，第22篇 $moved22/12" -ForegroundColor Yellow
Read-Host "按 Enter 關閉"
