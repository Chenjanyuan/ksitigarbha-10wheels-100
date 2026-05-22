# PowerShell - Push to GitHub
$ErrorActionPreference = "Stop"
chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  地藏十輪經 100 篇 - Push 到 GitHub" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "阿元 你好! 我會幫你把專案 push 到 GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "開始前請確認:"
Write-Host "  1. 已裝 git (GitHub Desktop 有裝過就 OK)"
Write-Host "  2. 已在 https://github.com/new 建好 repo (建議 Private)"
Write-Host ""
Read-Host "按 Enter 繼續"

# Check git
try {
    $gitVer = git --version
    Write-Host "git OK: $gitVer" -ForegroundColor Green
} catch {
    Write-Host "ERROR: git not installed" -ForegroundColor Red
    Read-Host "按 Enter 離開"
    exit 1
}

# Init repo
if (-not (Test-Path ".git")) {
    Write-Host "Init git repo..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "Done" -ForegroundColor Green
} else {
    Write-Host "Already a git repo" -ForegroundColor Green
}

# Set user
$userName = (git config user.name) 2>$null
if (-not $userName) {
    $name = Read-Host "請輸入名字"
    $email = Read-Host "請輸入 email"
    git config user.name "$name"
    git config user.email "$email"
}

# Set remote
$remoteUrl = $null
try { $remoteUrl = git remote get-url origin } catch {}
if (-not $remoteUrl) {
    Write-Host ""
    Write-Host "請貼上 GitHub repo URL" -ForegroundColor Yellow
    Write-Host "範例: https://github.com/your-name/dizang-shilun.git"
    $url = Read-Host "URL"
    git remote add origin "$url"
}

# Preview
Write-Host ""
Write-Host "預覽 - 會 push 的檔案 (前 20 個):" -ForegroundColor Cyan
git add . --dry-run | Select-Object -First 20

$count = (git status --porcelain | Measure-Object).Count
Write-Host ""
Write-Host "總共 $count 個檔案" -ForegroundColor Yellow
Write-Host ""
$ok = Read-Host "確認 push? (Y/N)"
if ($ok -notmatch "^[Yy]") {
    Write-Host "已取消"
    Read-Host "按 Enter 離開"
    exit 0
}

# Add + commit + push
Write-Host "Adding files..." -ForegroundColor Yellow
git add .

Write-Host "Committing..." -ForegroundColor Yellow
$msg = "地藏十輪經 100 篇 - " + (Get-Date -Format "yyyy-MM-dd HH:mm")
git commit -m "$msg"

Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "(可能會跳出 GitHub 登入視窗)" -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor Green
    Write-Host "  完成! 100 篇都在 GitHub 了!" -ForegroundColor Green
    Write-Host "===========================================" -ForegroundColor Green
} else {
    Write-Host "Push failed - see error above" -ForegroundColor Red
}
Write-Host ""
Read-Host "按 Enter 離開"
