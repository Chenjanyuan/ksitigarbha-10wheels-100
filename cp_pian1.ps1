# Cp 篇 1 的 12 張圖到 Playwright Temp
$src = 'C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-23_第1篇_序品第一\圖片'
$dst = 'C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\pian1'

Write-Host ""
Write-Host "=== Cp 篇 1 的 12 張圖到 Playwright Temp ==="
Write-Host ""
Write-Host "來源: $src"
Write-Host "目的: $dst"
Write-Host ""

if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
}

# 修正:用 Get-ChildItem $src 加 -Filter 分別跑
$pngs = Get-ChildItem -Path $src -Filter '*.png' -File
$jpgs = Get-ChildItem -Path $src -Filter '*.jpg' -File
$imgs = @($pngs) + @($jpgs)

Write-Host "找到 $($imgs.Count) 張圖"
Write-Host ""

foreach ($img in $imgs) {
    Copy-Item -Path $img.FullName -Destination $dst -Force
    Write-Host "  v $($img.Name)"
}

Write-Host ""
$total = (Get-ChildItem $dst -File).Count
Write-Host "=== 完成! 目的地內共 $total 張圖 ==="
Write-Host ""
Read-Host "按 Enter 關閉視窗"
