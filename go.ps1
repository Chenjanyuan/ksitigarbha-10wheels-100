$ErrorActionPreference = "Continue"
chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "=== 繼續 Push 到 GitHub ===" -ForegroundColor Cyan
Write-Host ""

# 已經有 remote 了 (上次設過), 直接 commit + push
git add .

Write-Host "Committing..." -ForegroundColor Yellow
$msg = "地藏十輪經 100 篇 - " + (Get-Date -Format "yyyy-MM-dd HH:mm")
git commit -m "$msg"

Write-Host ""
Write-Host "Force Pushing... (可能跳出 GitHub 登入)" -ForegroundColor Yellow
git push --force -u origin main

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "=== 完成! ===" -ForegroundColor Green
    Write-Host "去看: https://github.com/Chenjanyuan/ksitigarbha-10wheels-100"
} else {
    Write-Host "=== 失敗, 看上面錯誤訊息 ===" -ForegroundColor Red
}
Write-Host ""
Read-Host "按 Enter 離開 (千萬不要直接關視窗! 不然看不到結果)"
