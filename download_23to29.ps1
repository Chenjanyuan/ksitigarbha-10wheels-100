$BASE = "C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文"
Write-Host "下載第23-29篇 (84張) → 每篇貼文/XXX/圖片/" -ForegroundColor Cyan
if (-not (Test-Path $BASE)) { Write-Host "ERROR: $BASE 不存在" -ForegroundColor Red; Read-Host; exit 1 }

function DL($url, $out) {
    try { Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -EA Stop; Write-Host "  OK: $(Split-Path $out -Leaf)" -ForegroundColor Green }
    catch { Write-Host "  FAIL: $(Split-Path $out -Leaf) - $_" -ForegroundColor Red }
}

function EnsureDir($path) { if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null } }

# 第23篇
Write-Host "[第23篇] 2026-06-26_第23篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-06-26_第23篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/Bgst2io6gwDxJ1Ur.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/YwGrNs0Egx1cX36Z.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/FpUHuD49YfAWPoTr.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/uZecrwJoGw1wlfrm.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/UY6EiItR4Q9aYc2n.jpg" "$d\05_.jpg"
DL "https://a.lovart.ai/artifacts/agent/F8emUzTbFmAwBxAs.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/15LuHqlRJwIOVIRF.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/iiH0KBO8XeB8N7Vq.jpg" "$d\08_.jpg"
DL "https://a.lovart.ai/artifacts/agent/HQW3rFS7QE7ou9be.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/PlbxS4RzTLLPqCam.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/2vlBDeVL7GhjyFXv.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/K5fMW2GkrYDDzZGf.png" "$d\12_.png"

# 第24篇
Write-Host "[第24篇] 2026-06-29_第24篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-06-29_第24篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/GqURogS9Y72Q7ICe.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/kU1SihhlYv1plO7F.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/aN5RnnB3tICe4lZ5.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/VISBoFEUwgBmv1on.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/TRgrTm7BnCBcozRi.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/1jrYybeiaEF91vHz.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/qzX4E3fX4jL9WDlw.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/P3vC5xqryZHcOY6p.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/BQVfKu4NjkgEYXvH.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/i8WhyCeqlMG5g9Np.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/ZSKhjXKwkTLEoX0K.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/YfM3hc616YLhYj2J.png" "$d\12_.png"

# 第25篇
Write-Host "[第25篇] 2026-06-30_第25篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-06-30_第25篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/gD2ZPczy4l3v747v.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/35JvxAaPCD2KlAtg.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/HuQJgo9pOsJdE80W.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/ZTnOQh8jbbLdqC9i.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/Yrb09ehnNU3aFLRg.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/1DrSDqHr8c38MUlx.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/e9QruCsFQ93opdtJ.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/aPCFu1paTLHElXvM.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/GSh2Y8kHHb3CEMju.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/xnJJPvffCZ8pra0N.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/INqI5u3IWy7aVRIK.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/fAphJbwZ9hHwmJga.png" "$d\12_.png"

# 第26篇
Write-Host "[第26篇] 2026-07-01_第26篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-07-01_第26篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/cb559TA0v7Hs6Wd8.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/BwjxbGuS06Eugqbd.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/ORBzogX4zsAvO6cr.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/txdrfza45TCwf3gP.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/bbb9QabBTcBguFQk.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/hDFUu1Rr5K2J52sV.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/olW0ttPlbDEoIrVM.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/raJikZztTOKIO04c.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/mfB5o8os9jE1CjU5.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/FVIxLi42Q09LduSE.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/4h2O6sSz0p9DRJ9a.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/hUHvtxi2Wz4rZSgn.png" "$d\12_.png"

# 第27篇
Write-Host "[第27篇] 2026-07-02_第27篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-07-02_第27篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/lqH0wi3l0e1IAQWK.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/5t4FYYu7Jk4tCnsR.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/zV98EAfSm65joke7.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/I34BklvCEXD4Za4x.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/fhPdCnTBELbnL2ab.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/CqmaVeuiEX5asdRz.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/DWyo3pLyCk9wnRFd.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/7bKkE8jb3r18roms.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/3GbvZ0Y0IN8eRfL2.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/UO9ECB3mPjnMrSWg.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/9tnGjbEL5u4d1Ij5.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/OQ2ZlOUAM8976Umo.png" "$d\12_.png"

# 第28篇
Write-Host "[第28篇] 2026-07-03_第28篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-07-03_第28篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/eaf6KnhhKzIVjecZ.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/J7x4T13E83HkF8Z5.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/zzfKWVI55a8eoWC0.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/fCbexI6CDYCzDOX5.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/7iS8d2plI03iufGs.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/ys1oxx68ZZ6MMBZB.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/1gu8SVm8CNCZ2J1f.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/pHMI7Whb4dCkzm2X.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/xlCKkBmsHdKDTKQG.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/PYgmaOihUz4tsVZ4.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/6r8CiSbWw04C14zA.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/YcBu1gsz5e1WOzqK.png" "$d\12_.png"

# 第29篇
Write-Host "[第29篇] 2026-07-06_第29篇_十輪品" -ForegroundColor Yellow
$d = "$BASE\2026-07-06_第29篇_十輪品\圖片"
EnsureDir $d
DL "https://a.lovart.ai/artifacts/agent/XhYMb9eGexHUTjnE.png" "$d\01_.png"
DL "https://a.lovart.ai/artifacts/agent/MPgQUqJAorHs2zja.png" "$d\02_.png"
DL "https://a.lovart.ai/artifacts/agent/ubmcJzOTufJNsHVE.png" "$d\03_.png"
DL "https://a.lovart.ai/artifacts/agent/8EReZFbkWcAxR3pD.png" "$d\04_.png"
DL "https://a.lovart.ai/artifacts/agent/NTBfE5UUpr2YAVIp.png" "$d\05_.png"
DL "https://a.lovart.ai/artifacts/agent/WOHM47mCzt1Ywu2p.png" "$d\06_.png"
DL "https://a.lovart.ai/artifacts/agent/ctDI4DKDz7FF6KNo.png" "$d\07_.png"
DL "https://a.lovart.ai/artifacts/agent/YahKQHSjWaH2rVvs.png" "$d\08_.png"
DL "https://a.lovart.ai/artifacts/agent/1m0MsOKLOy1U66Rx.png" "$d\09_.png"
DL "https://a.lovart.ai/artifacts/agent/WOpSFLWsOKIQ0Uha.png" "$d\10_.png"
DL "https://a.lovart.ai/artifacts/agent/3bdafb2FzYIEFqSk.png" "$d\11_.png"
DL "https://a.lovart.ai/artifacts/agent/e6TAFUNk7T3W3aYl.png" "$d\12_.png"

Write-Host "全部完成！共 84 張" -ForegroundColor Cyan
Read-Host "按 Enter 關閉"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     