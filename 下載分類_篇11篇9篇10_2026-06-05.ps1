# ============================================================
# 地藏十輪經 圖片下載分類腳本  2026-06-05  阿地9號
# 自動下載阿美媽媽畫布生成的 10 張原圖，分類存到各篇資料夾
# 用法：對著本檔右鍵 → 用 PowerShell 執行；或雙擊同名 .bat
# ============================================================
$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$base = 'https://a.lovart.ai/artifacts/agent/'

$jobs = @(
  # ---- 篇11 大眾供養 (上刊 2026-06-09) ----
  @{ id='9MUzBubLuuAVzsF4'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='05_第四波_幢幡蓋.png' },
  @{ id='TWNzOuaZFS7CyDY5'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='06_地藏菩薩微笑接受.png' },
  @{ id='sCTaHoWj3L3T1l33'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='07_山頂變花海寶山_全景.png' },
  @{ id='HPvtFm4nlx37vcRR'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='08_很多人邊獻邊掉淚.png' },
  @{ id='xS5hVd6Or1E1aoZz'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='09_大眾齊聲讚嘆.png' },
  @{ id='dLX03UNmUuIwxe1L'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='10_地藏溫柔特寫.png' },
  @{ id='IQPVfuBZwKFhsiCu'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='11_啟發反思_現代小供養.png' },
  @{ id='w6XJ1Lxb8iLm1J5U'; dir='地藏十輪經連載\20260609_篇11_大眾供養'; name='12_經書索取_虛空藏菩薩.png' },
  # ---- 篇9 讚佛六句 (上刊 2026-06-05) 只補第12索取 ----
  @{ id='bdokANlJuJDjMA1M'; dir='地藏十輪經連載\20260605_篇9_讚佛六句'; name='12_經書索取_普賢菩薩.png' },
  # ---- 篇10 本願苦行 (上刊 2026-06-08) 只補第12索取 ----
  @{ id='usVXDvOL9H4atOfv'; dir='地藏十輪經連載\20260608_篇10_本願苦行'; name='12_經書索取_彌勒菩薩.png' }
)

$ok = 0; $fail = 0
foreach ($j in $jobs) {
  $d = Join-Path $root $j.dir
  if (!(Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
  $out = Join-Path $d $j.name
  $url = $base + $j.id + '.png'
  try {
    Write-Host ("下載中: " + $j.dir + "\" + $j.name)
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -TimeoutSec 60
    $ok++
  } catch {
    Write-Host ("  !! 失敗: " + $j.id + "  " + $_.Exception.Message) -ForegroundColor Red
    $fail++
  }
}
Write-Host ""
Write-Host ("===== 完成: 成功 " + $ok + " 張, 失敗 " + $fail + " 張 =====") -ForegroundColor Green
Write-Host "圖片已分類存到 地藏十輪經連載\ 各篇資料夾。"
Read-Host "按 Enter 關閉"
