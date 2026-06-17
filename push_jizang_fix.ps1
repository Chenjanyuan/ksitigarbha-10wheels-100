# Push fix - pull 遠端 + merge + push
# 阿地 2026-06-17
$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
Set-Location $PSScriptRoot

$OWNER = "Chenjanyuan"
$REPO  = "ksitigarbha-10wheels-100"

Write-Host "=== Push Fix: pull + merge + push ===" -ForegroundColor Cyan
Write-Host ""

$tok = $env:GITHUB_TOKEN_JIZANG
if (-not $tok) {
    Write-Host "ERROR: GITHUB_TOKEN_JIZANG not set" -ForegroundColor Red
    Read-Host "Press Enter to exit"; exit 1
}

git config user.name  "ayuan" | Out-Null
git config user.email "jack@what.com.tw" | Out-Null

# 清 git lock
Remove-Item ".git\HEAD.lock"  -Force -ErrorAction SilentlyContinue
Remove-Item ".git\index.lock" -Force -ErrorAction SilentlyContinue

# Step 1: 先把改名變動 commit (現在還是 untracked + deleted 狀態)
Write-Host "Step 1: 把本地改名動作 commit..." -ForegroundColor Yellow
git add -A 2>&1 | Out-Null
$status = git status -s 2>&1
if ($status) {
    git commit -m "refactor: 連載100篇資料夾改名 2026-05-XX -> 2026-06-23 起算工作日 (阿地 2026-06-17)" 2>&1 | Write-Host
} else {
    Write-Host "  (沒新變動需要 commit)" -ForegroundColor DarkGray
}

Write-Host ""

# Step 2: 拉遠端 + merge (-X ours 衝突時保留本地版 — 因為本地是最新整理)
Write-Host "Step 2: git pull (合併遠端的 12 個 commit, 衝突時保留本地)..." -ForegroundColor Yellow
$auth = "https://$tok@github.com/$OWNER/$REPO.git"
git pull $auth main --no-rebase --strategy-option=ours --no-edit 2>&1 | Write-Host

Write-Host ""

# Step 3: 檢查有沒有 merge 失敗
$mergeStatus = git status 2>&1 | Out-String
if ($mergeStatus -match "Unmerged paths|both modified|both added") {
    Write-Host "❌ Merge 有衝突需要人工解決!" -ForegroundColor Red
    Write-Host "請阿元 看上面訊息, 或開 GitHub Desktop 視覺化處理" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"; exit 1
}

# Step 4: Push
Write-Host "Step 3: Push to GitHub..." -ForegroundColor Yellow
git push $auth main 2>&1 | Write-Host

Write-Host ""
Write-Host "=== FINISHED. 找 'main -> main' 那行 = 成功 ===" -ForegroundColor Green
Read-Host "Press Enter to close"
