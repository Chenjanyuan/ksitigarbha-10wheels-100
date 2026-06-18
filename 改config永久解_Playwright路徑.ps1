# 自動改 Claude Desktop config 加 Playwright --allow-unrestricted-file-access flag
# 雙擊 .bat 跑這支

$ErrorActionPreference = 'Stop'

$configPath = "$env:APPDATA\Claude\claude_desktop_config.json"

Write-Host ""
Write-Host "=== 自動改 config 永久解 Playwright 路徑限制 ==="
Write-Host ""
Write-Host "目標: $configPath"
Write-Host ""

if (-not (Test-Path $configPath)) {
    Write-Host "X 找不到 $configPath"
    Write-Host "  請確認 Cowork(Claude Desktop) 有安裝"
    Read-Host "按 Enter 結束"
    exit
}

# 備份
$backup = "$configPath.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $configPath $backup
Write-Host "v 備份: $backup"

# 讀取 + 解析
$raw = Get-Content $configPath -Raw -Encoding UTF8
$config = $raw | ConvertFrom-Json

# 找 playwright server
if (-not $config.mcpServers) {
    Write-Host "X config 內沒 mcpServers,結構不對"
    Read-Host "按 Enter 結束"
    exit
}

if (-not $config.mcpServers.playwright) {
    Write-Host "X config 內沒 playwright,結構不對"
    Read-Host "按 Enter 結束"
    exit
}

$pw = $config.mcpServers.playwright
Write-Host ""
Write-Host "現在的 args:"
$pw.args | ForEach-Object { Write-Host "  - $_" }

# 檢查是否已加 flag
$flag = "--allow-unrestricted-file-access"
if ($pw.args -contains $flag) {
    Write-Host ""
    Write-Host "v 已經有 $flag flag 了!不用改"
    Read-Host "按 Enter 結束"
    exit
}

# 加 flag(放在 args 最後)
$pw.args = $pw.args + $flag

# 寫回
$newRaw = $config | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($configPath, $newRaw, (New-Object System.Text.UTF8Encoding $false))

Write-Host ""
Write-Host "v 改好! 新 args:"
$pw.args | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Write-Host "=== 接下來請阿元做 ==="
Write-Host "1. 完全關閉 Cowork(Claude Desktop) - 系統匣右下角右鍵 Quit"
Write-Host "2. 重新開啟 Cowork"
Write-Host "3. 跟阿地說「config 改好重啟好了」"
Write-Host ""
Write-Host "改完後阿地上稿 100 篇,直接用專案路徑,0 cp 步驟!"
Write-Host ""
Read-Host "按 Enter 關閉視窗"
