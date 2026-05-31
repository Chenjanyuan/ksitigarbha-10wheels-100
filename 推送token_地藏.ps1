# Push ksitigarbha-10wheels-100 using GITHUB_TOKEN_JIZANG (token read from env, never stored)
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Location $PSScriptRoot

$OWNER = "Chenjanyuan"
$REPO  = "ksitigarbha-10wheels-100"

Write-Host "=== Push to $OWNER/$REPO ===" -ForegroundColor Cyan

$tok = $env:GITHUB_TOKEN_JIZANG
if (-not $tok) {
    Write-Host "ERROR: GITHUB_TOKEN_JIZANG environment variable not set." -ForegroundColor Red
    Write-Host "Set it in Windows env vars, then reopen this window." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"; exit 1
}

# safety: only this repo allowed
$remoteUrl = (git config --get remote.origin.url)
if ($remoteUrl -notmatch "$REPO") {
    Write-Host "ERROR: origin is '$remoteUrl', not $REPO. Abort for safety." -ForegroundColor Red
    Read-Host "Press Enter to exit"; exit 1
}

git config user.name  "ayuan" 2>$null
git config user.email "jack@what.com.tw" 2>$null

git add -A
# commit (ok if nothing to commit)
git commit -m "feat: comic-character-consistency skill v1.1 + research verification + API/LoveArt experiment" 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "(nothing new to commit, will still push existing commits)" -ForegroundColor DarkGray }

# push using token in URL at runtime only
$auth = "https://$tok@github.com/$OWNER/$REPO.git"
git push $auth main
if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: pushed to GitHub." -ForegroundColor Green
} else {
    Write-Host "PUSH FAILED. Check token scope (Contents R/W on $REPO) and network." -ForegroundColor Red
}
Read-Host "Press Enter to exit"
