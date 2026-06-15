# 下載第22篇（十輪品・什麼是「十輪」）12張圖片
# 執行方法：右鍵 → 用 PowerShell 執行

$destDir = "$PSScriptRoot"

$images = @(
    @{ num="01"; name="佛陀宣說本願力十種佛輪"; url="https://a.lovart.ai/artifacts/agent/SFIiooeoVkHBDyjj.png" },
    @{ num="02"; name="十種佛輪守護世界"; url="https://a.lovart.ai/artifacts/agent/HTZGBelXVnAG7FC6.png" },
    @{ num="03"; name="五濁惡世眾生受苦"; url="https://a.lovart.ai/artifacts/agent/qw8kl5mKS4FrJhH5.png" },
    @{ num="04"; name="退沒一切白淨善法"; url="https://a.lovart.ai/artifacts/agent/sGArGfNCsOKJ97n7.png" },
    @{ num="05"; name="匱乏所有七聖財寶"; url="https://a.lovart.ai/artifacts/agent/XnHoYnva5NEStfGt.png" },
    @{ num="06"; name="被斷常羅網覆蔽"; url="https://a.lovart.ai/artifacts/agent/JdiAdR12YX67hykb.png" },
    @{ num="07"; name="常乘惡趣車不怕後世苦"; url="https://a.lovart.ai/artifacts/agent/KmMZ2NZz37E4wgFi.png" },
    @{ num="08"; name="佛陀如大仙尊位"; url="https://a.lovart.ai/artifacts/agent/q0kvCUzHxsTDTFAv.png" },
    @{ num="09"; name="佛輪轉動降伏魔王外道"; url="https://a.lovart.ai/artifacts/agent/UhJEtBYpx1EIC1YV.png" },
    @{ num="10"; name="佛王統治無王亂世"; url="https://a.lovart.ai/artifacts/agent/CB2vdpUavk9YMN9O.png" },
    @{ num="11"; name="最壞時代看到最深慈悲"; url="https://a.lovart.ai/artifacts/agent/ewsUlByzFtK3atg6.jpg"; ext="jpg" },
    @{ num="12"; name="金剛藏菩薩捧經索取"; url="https://a.lovart.ai/artifacts/agent/0Imr5gfSFgJO9haN.png" }
)

Write-Host "開始下載第22篇 12張圖片到：$destDir" -ForegroundColor Cyan

foreach ($img in $images) {
    $ext = if ($img.ext) { $img.ext } else { "png" }
    $filename = "$($img.num)_$($img.name).$ext"
    $filepath = Join-Path $destDir $filename

    try {
        Invoke-WebRequest -Uri $img.url -OutFile $filepath -UserAgent "Mozilla/5.0"
        Write-Host "✅ $filename" -ForegroundColor Green
    } catch {
        Write-Host "❌ 下載失敗：$filename - $_" -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 500
}

Write-Host "`n完成！請確認 $destDir 內有12張圖片。" -ForegroundColor Yellow
Read-Host "按 Enter 關閉"
