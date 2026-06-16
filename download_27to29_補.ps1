$ErrorActionPreference = "Continue"
$BASE = "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文"

Write-Host "補下載: 第27篇 10-12 + 第28篇 + 第29篇 (共 27 張)" -ForegroundColor Cyan

if (-not (Test-Path $BASE)) { Write-Host "ERROR: $BASE 不存在" -ForegroundColor Red; Read-Host; exit 1 }

function DL($url, $out) {
    try { Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -EA Stop; Write-Host "  OK: $(Split-Path $out -Leaf)" -ForegroundColor Green }
    catch { Write-Host "  FAIL: $(Split-Path $out -Leaf) - $_" -ForegroundColor Red }
}
function EnsureDir($path) { if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null } }

# ── 第27篇補 10~12 ──
$d27 = "$BASE\2026-07-02_第27篇_十輪品\圖片"
EnsureDir $d27
DL "https://a.lovart.ai/artifacts/agent/UO9ECB3mPjnMrSWg.png" "$d27\10_.png"
DL "https://a.lovart.ai/artifacts/agent/9tnGjbEL5u4d1Ij5.png" "$d27\11_.png"
DL "https://a.lovart.ai/artifacts/agent/OQ2ZlOUAM8976Umo.png" "$d27\12_.png"

# ── 第28篇 1~12 ──
$d28 = "$BASE\2026-07-03_第28篇_十輪品\圖片"
EnsureDir $d28
DL "https://a.lovart.ai/artifacts/agent/eaf6KnhhKzIVjecZ.png" "$d28\01_.png"
DL "https://a.lovart.ai/artifacts/agent/J7x4T13E83HkF8Z5.png" "$d28\02_.png"
DL "https://a.lovart.ai/artifacts/agent/zzfKWVI55a8eoWC0.png" "$d28\03_.png"
DL "https://a.lovart.ai/artifacts/agent/fCbexI6CDYCzDOX5.png" "$d28\04_.png"
DL "https://a.lovart.ai/artifacts/agent/7iS8d2plI03iufGs.png" "$d28\05_.png"
DL "https://a.lovart.ai/artifacts/agent/ys1oxx68ZZ6MMBZB.png" "$d28\06_.png"
DL "https://a.lovart.ai/artifacts/agent/1gu8SVm8CNCZ2J1f.png" "$d28\07_.png"
DL "https://a.lovart.ai/artifacts/agent/pHMI7Whb4dCkzm2X.png" "$d28\08_.png"
DL "https://a.lovart.ai/artifacts/agent/xlCKkBmsHdKDTKQG.png" "$d28\09_.png"
DL "https://a.lovart.ai/artifacts/agent/PYgmaOihUz4tsVZ4.png" "$d28\10_.png"
DL "https://a.lovart.ai/artifacts/agent/6r8CiSbWw04C14zA.png" "$d28\11_.png"
DL "https://a.lovart.ai/artifacts/agent/YcBu1gsz5e1WOzqK.png" "$d28\12_.png"

# ── 第29篇 1~12 ──
$d29 = "$BASE\2026-07-06_第29篇_十輪品\圖片"
EnsureDir $d29
DL "https://a.lovart.ai/artifacts/agent/XhYMb9eGexHUTjnE.png" "$d29\01_.png"
DL "https://a.lovart.ai/artifacts/agent/MPgQUqJAorHs2zja.png" "$d29\02_.png"
DL "https://a.lovart.ai/artifacts/agent/ubmcJzOTufJNsHVE.png" "$d29\03_.png"
DL "https://a.lovart.ai/artifacts/agent/8EReZFbkWcAxR3pD.png" "$d29\04_.png"
DL "https://a.lovart.ai/artifacts/agent/NTBfE5UUpr2YAVIp.png" "$d29\05_.png"
DL "https://a.lovart.ai/artifacts/agent/WOHM47mCzt1Ywu2p.png" "$d29\06_.png"
DL "https://a.lovart.ai/artifacts/agent/ctDI4DKDz7FF6KNo.png" "$d29\07_.png"
DL "https://a.lovart.ai/artifacts/agent/YahKQHSjWaH2rVvs.png" "$d29\08_.png"
DL "https://a.lovart.ai/artifacts/agent/1m0MsOKLOy1U66Rx.png" "$d29\09_.png"
DL "https://a.lovart.ai/artifacts/agent/WOpSFLWsOKIQ0Uha.png" "$d29\10_.png"
DL "https://a.lovart.ai/artifacts/agent/3bdafb2FzYIEFqSk.png" "$d29\11_.png"
DL "https://a.lovart.ai/artifacts/agent/e6TAFUNk7T3W3aYl.png" "$d29\12_.png"

Write-Host ""
Write-Host "補下載完成！共 27 張" -ForegroundColor Cyan
Read-Host "按 Enter 關閉"
