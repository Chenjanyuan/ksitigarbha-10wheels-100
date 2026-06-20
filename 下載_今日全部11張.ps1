# 下載 2026-06-20 今日阿美媽媽生的 11 張圖,存到各篇資料夾
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

$root = "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文"

# 11 張清單(URL, 篇資料夾, 檔名)
$tasks = @(
    @{ url = "https://a.lovart.ai/artifacts/agent/CTxSGJxnYUGQXIYV.png"; folder = "2026-06-30_第6篇_序品第一";  file = "第6篇12之9_大眾激動法喜充滿.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/XJBx919XPj6MSvg0.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之01_佛陀繼續開示.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/LCCGhbtUdI1N66aN.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之02_比喻一朗日.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/qJfMJgwkOpSfQP20.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之03_比喻二明炬.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/EU8nQEroQx322514.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之04_比喻三清涼月.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/15G9bfPKaz8SAUOB.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之05_比喻四車乘.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/4HiBiYLAwB55iga8.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之06_比喻五資糧.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/f9EtBwYx2I2mAbae.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之07_比喻六嚮導.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/kzZRai1hZSFVR8Oj.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之10_山頂全景大眾望南方.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/QL1ckPxeDWGcarLv.png"; folder = "2026-07-01_第7篇_序品第一";  file = "第7篇12之11_啟發反思現代場景.png" },
    @{ url = "https://a.lovart.ai/artifacts/agent/nK6GQQpGLj6eqtRB.png"; folder = "2026-07-21_第21篇_十輪品";    file = "第21篇12之9_地藏問五濁惡世.png" }
)

$ok = 0
$fail = 0

foreach ($t in $tasks) {
    $dir = Join-Path $root (Join-Path $t.folder "圖片")
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $dst = Join-Path $dir $t.file
    Write-Host ""
    Write-Host "Downloading: $($t.folder) / $($t.file)" -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $t.url -OutFile $dst -UseBasicParsing -TimeoutSec 60
        $size = [math]::Round((Get-Item $dst).Length / 1024 / 1024, 2)
        Write-Host "  OK ($size MB)" -ForegroundColor Green
        $ok++
    } catch {
        Write-Host "  FAIL: $_" -ForegroundColor Red
        $fail++
    }
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Yellow
Write-Host "Done. OK: $ok / 11 | Fail: $fail" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow
