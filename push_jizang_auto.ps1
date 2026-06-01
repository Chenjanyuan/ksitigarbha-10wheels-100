# 無人值守自動推送 (給排程任務用, 不會卡 Read-Host) — 地藏 repo
# 由 設定自動推送_地藏.bat 註冊的排程任務呼叫, 每 12 小時跑一次
$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
Set-Location $PSScriptRoot

$log = Join-Path $PSScriptRoot "auto_push.log"
function Log($m){ "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $m" | Tee-Object -FilePath $log -Append | Out-Null }

$OWNER = "Chenjanyuan"
$REPO  = "ksitigarbha-10wheels-100"

$tok = $env:GITHUB_TOKEN_JIZANG
if (-not $tok) { Log "ERROR: GITHUB_TOKEN_JIZANG 環境變數未設, 略過"; exit 1 }

$remoteUrl = (git config --get remote.origin.url)
if ("$remoteUrl" -notmatch "$REPO") { Log "ERROR: origin 是 '$remoteUrl', 不是 $REPO, 中止"; exit 1 }

git config user.name  "ayuan" | Out-Null
git config user.email "jack@what.com.tw" | Out-Null

# 清殘留鎖檔
Remove-Item ".git\HEAD.lock"  -Force -ErrorAction SilentlyContinue
Remove-Item ".git\index.lock" -Force -ErrorAction SilentlyContinue

git add -A 2>&1 | Out-Null

# 沒有變動就不 commit (避免空 commit)
$changes = git status --porcelain
if (-not $changes) { Log "無變動, 略過本次"; exit 0 }

Log "偵測到變動, 開始 commit + push..."
git commit -m "auto: 定時自動備份 $(Get-Date -Format 'yyyy-MM-dd HH:mm')" 2>&1 | ForEach-Object { Log $_ }

$auth = "https://$tok@github.com/$OWNER/$REPO.git"
git push $auth main 2>&1 | ForEach-Object { Log $_ }
Log "=== 本次自動推送結束 (看上方有無 main -> main) ==="
