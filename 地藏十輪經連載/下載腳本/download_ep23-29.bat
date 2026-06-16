@echo off
chcp 65001 >nul
echo ============================================
echo  下載第23-29篇圖片 (共84張)
echo  地藏十輪經連載 阿美媽媽生成
echo ============================================
echo.

set BASE=C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\地藏十輪經連載

REM ── 建立資料夾 ──
for %%F in (20260626 20260629 20260630 20260701 20260702 20260703 20260706) do (
    if not exist "%BASE%\%%F" mkdir "%BASE%\%%F"
)

echo [第23篇] 20260626 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/Bgst2io6gwDxJ1Ur.png' -OutFile '%BASE%\20260626\01_第一佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/YwGrNs0Egx1cX36Z.png' -OutFile '%BASE%\20260626\02_灌頂禮儀式.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/FpUHuD49YfAWPoTr.png' -OutFile '%BASE%\20260626\03_新王賑濟可憐的人.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/uZecrwJoGw1wlfrm.png' -OutFile '%BASE%\20260626\04_全民歸附新王.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/UY6EiItR4Q9aYc2n.jpg' -OutFile '%BASE%\20260626\05_佛陀轉動第一佛輪.jpg'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/F8emUzTbFmAwBxAs.png' -OutFile '%BASE%\20260626\06_九十六種外道迷惘.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/15LuHqlRJwIOVIRF.png' -OutFile '%BASE%\20260626\07_第一佛輪破外道邪論.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/iiH0KBO8XeB8N7Vq.jpg' -OutFile '%BASE%\20260626\08_眾生恍然大悟看清真相.jpg'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/HQW3rFS7QE7ou9be.png' -OutFile '%BASE%\20260626\09_三乘正道通往涅槃.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/PlbxS4RzTLLPqCam.png' -OutFile '%BASE%\20260626\10_地藏菩薩發願跟隨世尊.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/2vlBDeVL7GhjyFXv.png' -OutFile '%BASE%\20260626\11_現代人質疑求真.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/K5fMW2GkrYDDzZGf.png' -OutFile '%BASE%\20260626\12_好疑問菩薩捧經索取.png'"
echo    第23篇完成!

echo [第24篇] 20260629 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/GqURogS9Y72Q7ICe.png' -OutFile '%BASE%\20260629\01_第二佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/kU1SihhlYv1plO7F.png' -OutFile '%BASE%\20260629\02_國王平亂四大兵種.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/aN5RnnB3tICe4lZ5.png' -OutFile '%BASE%\20260629\03_四兵合力打敗怨敵.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/VISBoFEUwgBmv1on.png' -OutFile '%BASE%\20260629\04_剛強難化眾生.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/TRgrTm7BnCBcozRi.png' -OutFile '%BASE%\20260629\05_四種方法教導剛強者.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/1jrYybeiaEF91vHz.png' -OutFile '%BASE%\20260629\06_柔軟言語說法.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/qzX4E3fX4jL9WDlw.png' -OutFile '%BASE%\20260629\07_神通示現震驚.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/P3vC5xqryZHcOY6p.png' -OutFile '%BASE%\20260629\08_變化無窮引導.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/BQVfKu4NjkgEYXvH.png' -OutFile '%BASE%\20260629\09_地藏大悲心不捨任何人.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/i8WhyCeqlMG5g9Np.png' -OutFile '%BASE%\20260629\10_第二佛輪普照難化眾生.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ZSKhjXKwkTLEoX0K.png' -OutFile '%BASE%\20260629\11_現代不放棄任何人.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/YfM3hc616YLhYj2J.png' -OutFile '%BASE%\20260629\12_金剛藏菩薩捧經索取.png'"
echo    第24篇完成!

echo [第25篇] 20260630 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/gD2ZPczy4l3v747v.png' -OutFile '%BASE%\20260630\01_第三佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/35JvxAaPCD2KlAtg.png' -OutFile '%BASE%\20260630\02_國王賞罰百官.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/HuQJgo9pOsJdE80W.png' -OutFile '%BASE%\20260630\03_賞善罰惡清楚分明.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ZTnOQh8jbbLdqC9i.png' -OutFile '%BASE%\20260630\04_業報如影隨形.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/Yrb09ehnNU3aFLRg.png' -OutFile '%BASE%\20260630\05_善業帶來好報.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/1DrSDqHr8c38MUlx.png' -OutFile '%BASE%\20260630\06_惡業帶來苦報.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/e9QruCsFQ93opdtJ.png' -OutFile '%BASE%\20260630\07_畜生也能得救.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/aPCFu1paTLHElXvM.png' -OutFile '%BASE%\20260630\08_佛陀慈悲連畜生都度.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/GSh2Y8kHHb3CEMju.png' -OutFile '%BASE%\20260630\09_佛輪轉動畜生聽懂人話.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/xnJJPvffCZ8pra0N.png' -OutFile '%BASE%\20260630\10_地藏菩薩大願地獄不空.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/INqI5u3IWy7aVRIK.png' -OutFile '%BASE%\20260630\11_現代不放棄無可救藥之人.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/fAphJbwZ9hHwmJga.png' -OutFile '%BASE%\20260630\12_觀音菩薩捧經結緣.png'"
echo    第25篇完成!

echo [第26篇] 20260701 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/cb559TA0v7Hs6Wd8.png' -OutFile '%BASE%\20260701\01_第四佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/BwjxbGuS06Eugqbd.png' -OutFile '%BASE%\20260701\02_國王平定邊疆比喻.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ORBzogX4zsAvO6cr.png' -OutFile '%BASE%\20260701\03_邊地深山高原偏鄉.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/txdrfza45TCwf3gP.png' -OutFile '%BASE%\20260701\04_邊地沙漠孤島遠方.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/bbb9QabBTcBguFQk.png' -OutFile '%BASE%\20260701\05_大城市心靈邊地.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/hDFUu1Rr5K2J52sV.png' -OutFile '%BASE%\20260701\06_觀念上的邊地迷信.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/olW0ttPlbDEoIrVM.png' -OutFile '%BASE%\20260701\07_菩薩化身當地人引導.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/raJikZztTOKIO04c.png' -OutFile '%BASE%\20260701\08_善知識出現點醒.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/mfB5o8os9jE1CjU5.png' -OutFile '%BASE%\20260701\09_法寶經書漂流點亮.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/FVIxLi42Q09LduSE.png' -OutFile '%BASE%\20260701\10_因緣安排心轉向佛.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/4h2O6sSz0p9DRJ9a.png' -OutFile '%BASE%\20260701\11_現代心中邊地被照亮.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/hUHvtxi2Wz4rZSgn.png' -OutFile '%BASE%\20260701\12_普賢菩薩捧經結緣.png'"
echo    第26篇完成!

echo [第27篇] 20260702 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/lqH0wi3l0e1IAQWK.png' -OutFile '%BASE%\20260702\01_第五佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/5t4FYYu7Jk4tCnsR.png' -OutFile '%BASE%\20260702\02_國王攻城智慧兵法.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/zV98EAfSm65joke7.png' -OutFile '%BASE%\20260702\03_不同方法攻克難關.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/I34BklvCEXD4Za4x.png' -OutFile '%BASE%\20260702\04_佛法對症下藥.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/fhPdCnTBELbnL2ab.png' -OutFile '%BASE%\20260702\05_三種根器眾生.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/CqmaVeuiEX5asdRz.png' -OutFile '%BASE%\20260702\06_上根聽聞即悟.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/DWyo3pLyCk9wnRFd.png' -OutFile '%BASE%\20260702\07_中根漸漸引導.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/7bKkE8jb3r18roms.png' -OutFile '%BASE%\20260702\08_下根廣說法要.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/3GbvZ0Y0IN8eRfL2.png' -OutFile '%BASE%\20260702\09_地藏菩薩耐心等待.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/UO9ECB3mPjnMrSWg.png' -OutFile '%BASE%\20260702\10_第五佛輪普化三根眾生.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/9tnGjbEL5u4d1Ij5.png' -OutFile '%BASE%\20260702\11_現代不同學習方式.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/OQ2ZlOUAM8976Umo.png' -OutFile '%BASE%\20260702\12_文殊菩薩捧經結緣.png'"
echo    第27篇完成!

echo [第28篇] 20260703 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/eaf6KnhhKzIVjecZ.png' -OutFile '%BASE%\20260703\01_第六佛輪登場.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/J7x4T13E83HkF8Z5.png' -OutFile '%BASE%\20260703\02_國王寶藏打開分享.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/zzfKWVI55a8eoWC0.png' -OutFile '%BASE%\20260703\03_佛法是無盡寶藏.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/fCbexI6CDYCzDOX5.png' -OutFile '%BASE%\20260703\04_布施功德廣大.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/7iS8d2plI03iufGs.png' -OutFile '%BASE%\20260703\05_持戒功德清淨.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ys1oxx68ZZ6MMBZB.png' -OutFile '%BASE%\20260703\06_忍辱功德堅固.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/1gu8SVm8CNCZ2J1f.png' -OutFile '%BASE%\20260703\07_精進功德勇猛.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/pHMI7Whb4dCkzm2X.png' -OutFile '%BASE%\20260703\08_禪定功德安住.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/xlCKkBmsHdKDTKQG.png' -OutFile '%BASE%\20260703\09_智慧功德圓滿.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/PYgmaOihUz4tsVZ4.png' -OutFile '%BASE%\20260703\10_地藏菩薩六度萬行.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/6r8CiSbWw04C14zA.png' -OutFile '%BASE%\20260703\11_現代生活六度實踐.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/YcBu1gsz5e1WOzqK.png' -OutFile '%BASE%\20260703\12_彌勒菩薩捧經結緣.png'"
echo    第28篇完成!

echo [第29篇] 20260706 (12張)...
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/XhYMb9eGexHUTjnE.png' -OutFile '%BASE%\20260706\01_心是五個煩惱賊的老巢.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/MPgQUqJAorHs2zja.png' -OutFile '%BASE%\20260706\02_五個煩惱賊藏在心中.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ubmcJzOTufJNsHVE.png' -OutFile '%BASE%\20260706\03_五個煩惱賊.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/8EReZFbkWcAxR3pD.png' -OutFile '%BASE%\20260706\04_對付貪看清無常.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/NTBfE5UUpr2YAVIp.png' -OutFile '%BASE%\20260706\05_對付瞋修慈悲.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/WOHM47mCzt1Ywu2p.png' -OutFile '%BASE%\20260706\06_對付癡學智慧.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/ctDI4DKDz7FF6KNo.png' -OutFile '%BASE%\20260706\07_對付慢知道無我.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/YahKQHSjWaH2rVvs.png' -OutFile '%BASE%\20260706\08_對付疑起信心.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/1m0MsOKLOy1U66Rx.png' -OutFile '%BASE%\20260706\09_煩惱如灰塵擦掉見光.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/WOpSFLWsOKIQ0Uha.png' -OutFile '%BASE%\20260706\10_地藏菩薩發願擦心窗.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/3bdafb2FzYIEFqSk.png' -OutFile '%BASE%\20260706\11_現代人心靈淨化啟示.png'"
powershell -Command "Invoke-WebRequest 'https://a.lovart.ai/artifacts/agent/e6TAFUNk7T3W3aYl.png' -OutFile '%BASE%\20260706\12_虛空藏菩薩捧經結緣.png'"
echo    第29篇完成!

echo.
echo ============================================
echo  全部下載完成！共7篇 x 12張 = 84張
echo  存放於: %BASE%\
echo ============================================
pause
