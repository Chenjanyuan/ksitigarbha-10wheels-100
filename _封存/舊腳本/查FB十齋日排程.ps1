# -*- coding: utf-8 -*-
# 查 FB 地藏菩薩本行經 — 5/24 以後排程清單
# 純 PowerShell, 不需要 Python
# 阿地 寫 · 2026-05-22

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🔍 查 FB 地藏菩薩本行經 — 5/24 以後排程清單         ║" -ForegroundColor Cyan
Write-Host "║   只讀不改, 安全執行                                  ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 讀 .env
$envFile = Join-Path $root ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "❌ 找不到 .env" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

$env_vars = @{}
Get-Content $envFile -Encoding UTF8 | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
        $parts = $line -split "=", 2
        $key = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"').Trim("'")
        $env_vars[$key] = $value
    }
}

$pageId = $env_vars["DIZANG_PAGE_ID"]
$token  = $env_vars["DIZANG_TOKEN"]

if (-not $pageId -or -not $token) {
    Write-Host "❌ .env 缺少 DIZANG_PAGE_ID 或 DIZANG_TOKEN" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "🪷 粉專 ID: $pageId" -ForegroundColor Green
Write-Host "   Token 前 8 碼: $($token.Substring(0,8))*** (隱藏剩餘)" -ForegroundColor DarkGray
Write-Host ""

# 抓 scheduled_posts (處理分頁)
$allPosts = @()
$url = "https://graph.facebook.com/v21.0/$pageId/scheduled_posts?access_token=$token&fields=id,scheduled_publish_time,message&limit=100"

try {
    while ($url) {
        $resp = Invoke-RestMethod -Uri $url -Method GET -TimeoutSec 30
        if ($resp.data) {
            $allPosts += $resp.data
        }
        if ($resp.paging.next) {
            $url = $resp.paging.next
        } else {
            $url = $null
        }
    }
} catch {
    Write-Host "❌ Graph API 錯誤:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message -ForegroundColor Red
    }
    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "✅ 已排程貼文總數: $($allPosts.Count)" -ForegroundColor Green
Write-Host ""

# 篩 5/24 以後 (台北時間)
$cutoff = [DateTimeOffset]::new(2026, 5, 24, 0, 0, 0, [TimeSpan]::FromHours(8)).ToUnixTimeSeconds()
$tw = [TimeSpan]::FromHours(8)

$after = @()
foreach ($p in $allPosts) {
    if ($p.scheduled_publish_time -and $p.scheduled_publish_time -ge $cutoff) {
        $dt = [DateTimeOffset]::FromUnixTimeSeconds($p.scheduled_publish_time).ToOffset($tw)
        $msg = if ($p.message) { ($p.message -replace "[`r`n]", " ").Substring(0, [Math]::Min(80, $p.message.Length)) } else { "(無內文)" }
        $isZhai = $msg -match "十齋日|齋日"
        $after += [PSCustomObject]@{
            DateTime = $dt
            Id       = $p.id
            IsZhai   = $isZhai
            Preview  = $msg
        }
    }
}

$after = $after | Sort-Object DateTime

# 輸出
$outLines = @()
$outLines += "FB 粉專: 地藏菩薩本行經 ($pageId)"
$outLines += "查詢時間: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$outLines += "5/24 (含) 之後已排程貼文總數: $($after.Count) 篇"
$outLines += ""
$outLines += "=" * 100
$outLines += "{0,-20}{1,-10}{2,-35}{3}" -f "排程時間", "類型", "貼文 ID", "內文預覽"
$outLines += "=" * 100

$zhaiOnly = @()
foreach ($p in $after) {
    $flag = if ($p.IsZhai) { "✅ 十齋日" } else { "   一般" }
    $line = "{0,-20}{1,-10}{2,-35}{3}" -f $p.DateTime.ToString("yyyy-MM-dd HH:mm"), $flag, $p.Id, $p.Preview.Substring(0, [Math]::Min(60, $p.Preview.Length))
    $outLines += $line
    if ($p.IsZhai) {
        $zhaiOnly += $p
    }
}

$outLines += ""
$outLines += "=" * 100
$outLines += "★ 其中十齋日有 $($zhaiOnly.Count) 篇 (這些是阿元 要換圖的對象):"
$outLines += "=" * 100
foreach ($p in $zhaiOnly) {
    $outLines += "$($p.DateTime.ToString('yyyy-MM-dd HH:mm'))  ID=$($p.Id)  $($p.Preview.Substring(0, [Math]::Min(60, $p.Preview.Length)))"
}

$result = $outLines -join "`r`n"
Write-Host $result

# 存檔
$outFile = Join-Path $root "FB十齋日排程清單_5月24日以後.txt"
$result | Out-File -FilePath $outFile -Encoding UTF8

Write-Host ""
Write-Host "📄 清單已存到: $outFile" -ForegroundColor Green
Write-Host ""
Write-Host "★ 阿地 提醒:" -ForegroundColor Yellow
Write-Host "   1. 本腳本只 GET 不會改任何東西" -ForegroundColor Yellow
Write-Host "   2. 換圖前請阿地 二次確認再動作" -ForegroundColor Yellow
Write-Host "   3. token 不要外傳, 截圖前先遮掉" -ForegroundColor Yellow
Write-Host ""
Read-Host "按 Enter 結束 (清單已存檔, 可以複製給阿地)"
