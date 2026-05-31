# Push ksitigarbha-10wheels-100 using GITHUB_TOKEN_JIZANG (token read from env, never stored)
$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
Set-Location $PSScriptRoot

$OWNER = "Chenjanyuan"
$REPO  = "ksitigarbha-10wheels-100"

Write-Host "=== Push to $OWNER/$REPO ===" -ForegroundColor Cyan

$tok = $env:GITHUB_TOKEN_JIZANG
if (-not $tok) {
    Write-Host "ERROR: GITHUB_TOKEN_JIZANG not set. Set it in Windows env vars, reopen window." -ForegroundColor Red
    Read-Host "Press Enter to exit"; exit 1
}

$remoteUrl = (git config --get remote.origin.url)
if ("$remoteUrl" -notmatch "$REPO") {
    Write-Host "ERROR: origin is '$remoteUrl', not $REPO. Abort." -ForegroundColor Red
    Read-Host "Press Enter to exit"; exit 1
}

git config user.name  "ayuan" | Out-Null
git config user.email "jack@what.com.tw" | Out-Null

# clear any stale git locks left by interrupted processes
Remove-Item ".git\HEAD.lock"  -Force -ErrorAction SilentlyContinue
Remove-Item ".git\index.lock" -Force -ErrorAction SilentlyContinue

Write-Host "Staging (git add -A)..." -ForegroundColor Yellow
git add -A 2>&1 | Out-Null

Write-Host "Committing..." -ForegroundColor Yellow
git commit -m "feat: comic-character-consistency skill v1.1 + research verification + API/LoveArt experiment" 2>&1 | Write-Host

Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
$auth = "https://$tok@github.com/$OWNER/$REPO.git"
git push $auth main 2>&1 | Write-Host

Write-Host ""
Write-Host "=== FINISHED. Check lines above: 'main -> main' = success; 403/401 = token scope; 404 = repo name. ===" -ForegroundColor Green
Read-Host "Press Enter to close"
