# 下載第21篇（十輪品・地藏菩薩請問）12張圖片
# 執行方法：右鍵 → 用 PowerShell 執行

$destDir = $PSScriptRoot

$images = @(
    @{ num="01"; name="序品結束新品將始"; url="https://a.lovart.ai/artifacts/agent/47RAqPhKSc1zTYlH.png" },
    @{ num="02"; name="地藏菩薩起身整理袈裟"; url="https://a.lovart.ai/artifacts/agent/NHsGROu70JCrVTzE.png" },
    @{ num="03"; name="地藏菩薩走向佛陀全場屏息"; url="https://a.lovart.ai/artifacts/agent/MBXXbuF2z0LM4Urd.png" },
    @{ num="04"; name="地藏菩薩頂禮佛足"; url="https://a.lovart.ai/artifacts/agent/9uYiLGwXMA3g0a5j.png" },
    @{ num="05"; name="地藏菩薩恭敬請問姿勢"; url="https://a.lovart.ai/artifacts/agent/Wq1KDtWKATHH4vRX.png" },
    @{ num="06"; name="地藏菩薩以詩偈請問"; url="https://a.lovart.ai/artifacts/agent/0812MMXdmJH8JS1s.png" },
    @{ num="07"; name="佛陀允許發問地藏歡喜"; url="https://a.lovart.ai/artifacts/agent/Hr9NX70Axh43eiWm.png" },
    @{ num="08"; name="地藏菩薩訴說十三大劫苦行"; url="https://a.lovart.ai/artifacts/agent/abVfMtcBjJFKfqcP.png" },
    @{ num="09"; name="地藏菩薩悲憫望向苦難世間"; url="https://a.lovart.ai/artifacts/agent/kSV6ouvmrsIIdTev.png" },
    @{ num="10"; name="地藏菩薩懇切問出關鍵問題"; url="https://a.lovart.ai/artifacts/agent/YBQZ6vX4Fq1hmmur.png" },
    @{ num="11"; name="現代人對心發問"; url="https://a.lovart.ai/artifacts/agent/2y9MOMAu04Gde1XR.png" },
    @{ num="12"; name="虛空藏菩薩捧經索取"; url="https://a.lovart.ai/artifacts/agent/5xQiWy4u5pA2e1Ew.png" }
)

Write-Host "開始下載第21篇 12張圖片到：$destDir" -ForegroundColor Cyan

$ok = 0
foreach ($img in $images) {
    $filename = "$($img.num)_$($img.name).png"
    $filepath = Join-Path $destDir $filename
    try {
        Invoke-WebRequest -Uri $img.url -OutFile $filepath -UserAgent "Mozilla/5.0"
        Write-Host "✅ $filename" -ForegroundColor Green
        $ok++
    } catch {
        Write-Host "❌ 下載失敗：$filename" -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 500
}

Write-Host "`n完成！共下載 $ok/12 張。" -ForegroundColor Yellow
Read-Host "按 Enter 關閉"
