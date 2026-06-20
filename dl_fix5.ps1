$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$BASE = "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文"
Write-Host "===== Download 5 fix images =====" -ForegroundColor Cyan
if (-not (Test-Path $BASE)) { Write-Host "ERROR" -ForegroundColor Red; Read-Host; exit 1 }

function DL($url, $out) {
    try { Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -EA Stop; Write-Host "  OK: $(Split-Path $out -Leaf)" -ForegroundColor Green }
    catch { Write-Host "  FAIL: $(Split-Path $out -Leaf) - $_" -ForegroundColor Red }
}
function EnsureDir($path) { if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null } }

Write-Host "[p22_11]" -ForegroundColor Yellow
$d = "$BASE\2026-07-22_第22篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/1lNg7FfkMg3ep6x5.png" "$d\第22篇12之11_啟發反思.png"

Write-Host "[p23_05]" -ForegroundColor Yellow
$d = "$BASE\2026-07-23_第23篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/0g6G5P5lEB9E7e5o.png" "$d\05_灌頂大王賑濟貧苦.png"

Write-Host "[p23_08]" -ForegroundColor Yellow
$d = "$BASE\2026-07-23_第23篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/Ta5HdwSmuQ8o0Dq5.png" "$d\08_第一佛輪摧破外道.png"

Write-Host "[p30_04]" -ForegroundColor Yellow
$d = "$BASE\2026-08-03_第30篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/Rjf3JLsWiU77dyLZ.png" "$d\第30篇12之4_第1戒不殺生.png"

Write-Host "[p30_11]" -ForegroundColor Yellow
$d = "$BASE\2026-08-03_第30篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/Imz178rVP1AG3QLf.png" "$d\第30篇12之11_啟發反思現代場景.png"

Write-Host "===== Done! =====" -ForegroundColor Cyan
Read-Host "Press Enter to close"