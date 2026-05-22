# PowerShell 版 — 中文友善
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🪷  地藏十輪經 100 篇 — Push 到 GitHub" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "阿元 你好! 我會幫你把專案 push 到 GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "開始前請確認:"
Write-Host "  1. 已裝 git (GitHub Desktop 有裝過就 OK)"
Write-Host "  2. 已在 GitHub 網站建好 repo (https://github.com/new)"
Write-Host "     建議 repo 名: dizang-shilun-fb-content"
Write-Host "     ★ 建議選 Private (私人) 因為含未發布內容"
Write-Host ""
Read-Host "按 Enter 繼續"

# ─────────────────────────────────────────
# Step 1: 確認 git 已裝
# ─────────────────────────────────────────
$gitVersion = git --version 2>$null
if (-not $gitVersion) {
    Write-Host "❌ 沒裝 git! 請先裝 GitHub Desktop 或 Git for Windows" -ForegroundColor Red
    Read-Host "按 Enter 離開"
    exit 1
}
Write-Host "✅ git 已裝: $gitVersion" -ForegroundColor Green

# ─────────────────────────────────────────
# Step 2: 初始化 git repo
# ─────────────────────────────────────────
if (-not (Test-Path ".git")) {
    Write-Host ""
    Write-Host "📦 初始化 git repo..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "✅ git repo 建好" -ForegroundColor Green
} else {
    Write-Host "✅ 已是 git repo" -ForegroundColor Green
}

# ─────────────────────────────────────────
# Step 3: 設定 git user
# ─────────────────────────────────────────
$userName = git config user.name 2>$null
if (-not $userName) {
    Write-Host ""
    Write-Host "📝 設定 git user (一次性)" -ForegroundColor Yellow
    $name = Read-Host "請輸入你的名字 (例如: 阿元)"
    $email = Read-Host "請輸入你的 GitHub email"
    git config user.name "$name"
    git config user.email "$email"
}

# ─────────────────────────────────────────
# Step 4: 設定 remote
# ─────────────────────────────────────────
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host ""
    Write-Host "🔗 設定 GitHub repo URL" -ForegroundColor Yellow
    Write-Host "範例: https://github.com/你的帳號/dizang-shilun-fb-content.git"
    $repoUrl = Read-Host "請貼上 GitHub repo URL"
    git remote add origin "$repoUrl"
    Write-Host "✅ remote 設好" -ForegroundColor Green
} else {
    Write-Host "✅ remote 已設: $remoteUrl" -ForegroundColor Green
}

# ─────────────────────────────────────────
# Step 5: 預覽
# ─────────────────────────────────────────
Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📋 預覽 — 以下檔案會被 push (扣掉 .gitignore 排除的):" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
git add . --dry-run 2>&1 | Select-Object -First 30
Write-Host ""
$fileCount = (git status --porcelain | Measure-Object).Count
Write-Host "總共 $fileCount 個檔案會被加入" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "確認 push? (Y/N)"
if ($confirm -notmatch "^[Yy]") {
    Write-Host "已取消, 沒做任何事" -ForegroundColor Yellow
    Read-Host "按 Enter 離開"
    exit 0
}

# ─────────────────────────────────────────
# Step 6: 加入 + commit
# ─────────────────────────────────────────
Write-Host ""
Write-Host "📥 加入所有檔案..." -ForegroundColor Yellow
git add .
Write-Host ""
Write-Host "💬 commit..." -ForegroundColor Yellow
$commitMsg = "📿 地藏十輪經 100 篇 — $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m "$commitMsg"

# ─────────────────────────────────────────
# Step 7: push
# ─────────────────────────────────────────
Write-Host ""
Write-Host "🚀 Push 到 GitHub..." -ForegroundColor Yellow
Write-Host "★ 如果跳出登入視窗, 用瀏覽器登入 GitHub" -ForegroundColor Yellow
Write-Host ""
git push -u origin main

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "🎉 完成! 100 篇 + 生成命令 都在 GitHub 了!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "你的 repo: " -NoNewline
    git remote get-url origin
} else {
    Write-Host "❌ Push 失敗! 看上面的錯誤訊息" -ForegroundColor Red
}
Write-Host ""
Read-Host "按 Enter 離開"
