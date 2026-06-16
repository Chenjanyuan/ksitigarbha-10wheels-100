# PowerShell - Push to GitHub (Force Overwrite 強制覆蓋舊內容)
$ErrorActionPreference = "Continue"
chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "==============================================" -ForegroundColor Red
Write-Host "  Force Push - 強制覆蓋 GitHub repo 舊內容" -ForegroundColor Red
Write-Host "==============================================" -ForegroundColor Red
Write-Host ""
Write-Host "⚠️  注意: 這會把 GitHub 上原來的內容全部蓋掉!" -ForegroundColor Yellow
Write-Host "    用我們今天整理好的新內容取代" -ForegroundColor Yellow
Write-Host ""
Write-Host "適用情境:"
Write-Host "  你有舊 repo (Composio 建的), 想把舊內容清掉,"
Write-Host "  改放我們新的 100 篇生成命令 + docx"
Write-Host ""
Read-Host "按 Enter 繼續, 或 Ctrl+C 取消"

# 確認 git
$gitVer = git --version 2>$null
if (-not $gitVer) {
    Write-Host "ERROR: git 沒裝" -ForegroundColor Red
    Read-Host "按 Enter 離開"
    exit 1
}
Write-Host "git OK: $gitVer" -ForegroundColor Green

# 初始化 (如果還沒)
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "✓ git repo 初始化好" -ForegroundColor Green
}

# 設定 user
$userName = (git config user.name) 2>$null
if (-not $userName) {
    $name = Read-Host "請輸入你的名字"
    $email = Read-Host "請輸入 GitHub email"
    git config user.name "$name"
    git config user.email "$email"
}

# 設 remote
Write-Host ""
Write-Host "請貼上你要覆蓋的 GitHub repo URL" -ForegroundColor Yellow
Write-Host "範例: https://github.com/你的帳號/repo-name.git"
$url = Read-Host "URL"

# 移除舊 remote (如果有), 加新的
git remote remove origin 2>$null | Out-Null
git remote add origin "$url"

# 預覽
Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  即將執行 - 請最後確認" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
git add .
$count = (git status --porcelain | Measure-Object).Count
Write-Host ""
Write-Host "  目標 repo: $url" -ForegroundColor White
Write-Host "  要 push 檔案數: $count" -ForegroundColor White
Write-Host "  動作: FORCE PUSH (蓋掉原 repo 所有內容)" -ForegroundColor Red
Write-Host ""
$ok = Read-Host "確認執行? 輸入 YES (大寫) 確認"
if ($ok -ne "YES") {
    Write-Host "已取消, 沒做任何事" -ForegroundColor Yellow
    Read-Host "按 Enter 離開"
    exit 0
}

# Commit + Force Push
Write-Host ""
Write-Host "Committing..." -ForegroundColor Yellow
$msg = "地藏十輪經 100 篇 (Force Overwrite) - " + (Get-Date -Format "yyyy-MM-dd HH:mm")
git commit -m "$msg"

Write-Host "Force pushing..." -ForegroundColor Yellow
Write-Host "(可能會跳出 GitHub 登入視窗)" -ForegroundColor Yellow
git push --force -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "  完成! 舊內容已蓋掉, 新內容上去了!" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "去 GitHub 看: $url"
} else {
    Write-Host "Force push failed - see error above" -ForegroundColor Red
}
Write-Host ""
Read-Host "按 Enter 離開"
