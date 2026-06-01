# Nano Banana Pro 角色一致性 — 全球社群調查整合報告

> 阿研 2026-06-01 撰寫｜阿元交辦：派 8 個分身掃全世界論壇/部落格/社群，整合大家的實戰經驗 + 找替代工具
> 給阿元、阿地看｜全大白話

---

## 一句話結論（先講重點）

**不要放棄 Nano Banana Pro。** 全世界 2026 年的橫向評測，幾乎一面倒：**論「同一個角色跨多張圖不變臉」，Nano Banana Pro 還是現在的第一名。** 我們之前覺得「沒什麼用」，不是工具爛，是**用法沒對**——大家都踩同一個坑，社群也都找到同一套破解法。下面整理的就是「全世界公認真正有效」的做法。

另外，之前那個「Lovart 自訂角色訓練器」是官網廣告詞、實際找不到。但**「真的可以訓練一個角色」這件事是存在的**，只是要去別的平台做（後面第五段有完整清單，最便宜一隻角色台幣 60 元就能訓練）。

---

## 二、為什麼角色會「變臉」？（先懂原因才知道怎麼救）

AI 生圖的本質：**它每次畫圖都是「重新從零想像」，它根本不記得你的角色長怎樣。** 就像你請一個畫家，每次都換一個、而且都沒看過你的角色，只能憑你嘴巴講——講十次就有十種臉。

所以全世界的破解核心只有一句話：

> **「不要用嘴巴描述角色，要用『圖』把角色釘死，而且每次都拿同一張圖給它看。」**

還有一個關鍵技術事實（很多人卡在這）：

> **Nano Banana Pro 沒有「固定種子（seed）」這個功能。** 它跟 Stable Diffusion 那種「鎖種子就能重現」的玩法完全不同。所以網路上教你「鎖 seed 保持一致」的舊文章，對 NB Pro **沒用**。一致性只能靠「參考圖 + 固定講法」來達成。

---

## 三、全世界公認有效的「黃金做法」（這段最重要，阿地照做）

8 個分身掃完 Reddit、YouTube、X、知乎、方格子、Lovart 教程……不管中文英文，大家講的方法高度一致，整理成 7 步：

### 1. 先做「一張主角定裝照 / 角色表」當聖經
- 一張**乾淨、光線平均、表情中性**（不要誇張動作/表情）的全身正面圖，這張叫「Image 1 / 母版」。
- 再擴成**多角度角色表**：正面 + 四分之三側面 + 正側面 + 背面，乾淨白底、全身、光線一致。
- 這張母版 = 「角色的唯一真相來源」，之後**每一格都拿它當參考**。

### 2. 每一格都把母版丟進「參考圖」欄位（不是貼進對話框）
- 一定要放進 Image Reference 槽位 / 用 `@` 提及，不是貼到對話框講「請參考」。貼對話框 = AI 當示意圖，沒鎖定。

### 3. 每一格 prompt 都加一句「身份鎖定咒語」
全世界最多人用、最有效的一句（英文最準）：
> **"Keep the character's facial features exactly the same as the reference image. Maintain identical attire and hairstyle throughout."**
（臉、衣服、髮型，跟參考圖完全一樣，整篇都不變）

進階加強版（臉特別會跑時）：
> "Maintain the exact same facial features as the reference — same eyes, nose shape, jawline contour, and skin texture."

### 4. 一次只改「一個變數」，而且用字一模一樣
- 一格只改**鏡頭角度 or 場景 or 動作**，其中一個。不要同時改。
- 角色描述的**用字逐字不變**：第 1 格寫「emerald eyes」，第 5 格就不能改成「green eyes」，AI 會當成不同人。
- 給角色一個短代號（例：「地藏-A」），每次都用同一個。
- ❌ 不要用 "different"、"new" 這種字 → 等於叫它亂變。

### 5. 🔴 最關鍵的鐵則：永遠參考「母版」，不要參考「上一張」
這是全世界踩最慘、也最少人知道的坑：

> **不要拿「第 5 格」當「第 6 格」的參考，再拿第 6 格畫第 7 格……這樣「誤差會滾雪球」，大概到第 15 格角色就認不出來了。**
> **正確做法：第 1、2、3……格，全部都回去參考「最原始那張母版」。**

### 6. 全程在「同一個對話視窗」做
- NB Pro 在同一個 session 裡會記得上下文，定義過角色後，後面只要講動作就好。開新對話 = 失憶重來。

### 7. 參考圖「6 張封頂」，不要塞滿
- NB Pro 雖然號稱吃 14 張，但**實測 6 張高品質就到頂，超過 10 張反而變差**。質比量重要。
- 每張至少 1024×1024，光線一致，正面 + 兩個側角。

---

## 四、衣服永遠比臉難固定 → 專門破解法（阿元最頭痛的）

大家公認：**臉好固定，衣服超難固定**（領口、扣子數量、布料花紋每次都飄）。社群找到的專門解法：

### 把「衣服」當成一個「商品」單獨給一張參考圖
這是最重要的技術內幕：Nano Banana Pro 的參考圖其實分**兩種槽位**：
- **角色一致槽（5 個）**：放「人」——鎖臉。
- **物品保真槽（6 個）**：放「東西」——鎖一個特定物品（像鎖一雙紅球鞋的顏色/logo）。

👉 **把主角的法袍/服裝，當成「一個商品」放進「物品保真槽」**，跟「臉的參考圖」分開放。這樣「誰」和「穿什麼」就變成兩個各自釘死的錨點，衣服就穩很多。

### 衣服 prompt 用「只改衣服、其他全鎖」的句型
- 換裝：「**Replace ONLY the clothing with [X]. Do NOT change the person, face, body, hair, pose, or background.**」
- 保持同一套衣服跨場景：把衣服描述寫成**逐字不變的固定字串**，放在 prompt 最前面，只改場景。
- 加負面指令：「no different outfit, no clothing change, no style change」。

### 終極招：先脫光生角色，再用 AI 換裝工具統一穿衣
官方部落格自己也建議：先生「中性姿勢的素體角色」，再用換裝工具統一套上同一套衣服。

---

## 五、什麼情況一定會壞（先有心理準備，不要怪自己）

| 會壞的狀況 | 說明 | 對策 |
|---|---|---|
| **超過 5 個角色同框** | 臉會「平均化」，每個人都有點像又都不像 | 一格最多 2-3 個主角；多角色要明寫「A 在左、B 在中、C 在右」 |
| **打鬥/激烈動作** | 手腳、透視會崩 | 動作格預期要重生，或改靜態構圖 |
| **連續很多格之後** | 誤差滾雪球 | 每「一章」重新拉一次母版當錨點 |
| **prompt 自相矛盾** | 例：又要「廣角」又指定「50mm」→ 直接失敗 | 直接問模型「幫我檢查 prompt 有沒有衝突」 |
| **圖內中文字 / 漢字** | 容易出錯字 | 生完到 Canva / PS / Figma 補字 |
| **小瑕疵（多一隻手）** | 用 prompt 改不掉 | 局部框起來重生那一塊（inpainting），不要整張重來 |

**業界天花板就是 85%**：50 張圖裡有 1-2 成需要手動修，這是現在所有工具的物理極限，不是你的問題。抱「60 分快速迭代」心態，不要追 100%。

---

## 六、如果想要「真正訓練一個角色」（Lovart 廣告詞的真實版）

「丟 10-20 張訓練 → 之後叫名字就出來 >90% 一致」這件事**真的做得到**，但要去**會訓練 LoRA 的平台**。給阿元（不會寫程式、自己家裡用）的推薦排序：

### 最適合不會寫程式的人
| 平台 | 怎麼收費 | 好在哪 | 注意 |
|---|---|---|---|
| **Leonardo.ai** | 月費約 US$12 起 | 介面最親民、一站搞定、可訓練可參考 | 一致性約 80-92%，要手修一點 |
| **Scenario.gg** | 月費 US$45 起 | 角色鎖定最強、支援多角色、專為量產設計 | 要備資料集，偏工作室用 |
| **Civitai 線上訓練** | Buzz 點數（可免費賺） | 最適合新手、預設值就能跑、教學最多 | — |

### 最便宜 / 最快（一次性設定划算）
| 平台 | 一隻角色成本 | 速度 |
|---|---|---|
| **Replicate** | 約 US$1.85（台幣 ~60 元） | 2-20 分鐘 |
| **fal.ai**（portrait trainer） | 約 US$2.40 | ~10 分鐘 |
| **TensorArt / SeaArt / PixAI** | 有免費額度 | PixAI 專攻動漫角色 |

⚠️ 提醒：**getimg.ai 的訓練功能 2026/2 已停掉**，改成參考式，別在它上面建流程。動漫風 → PixAI 最強；寫實人像 → Leonardo / Higgsfield。

---

## 七、專門做「漫畫」的工具（內建分鏡 + 對話框，最省事）

我們的用途是 12 格連環漫畫，其實有**專門做漫畫**的工具，內建角色訓練 + 分鏡排版 + 對話框：

| 工具 | 強項 | 適合 |
|---|---|---|
| **Dashtoon Studio** ⭐ | 公認漫畫類角色一致性最強、一鍵建角色、內建分鏡/對話框 | **第一個該試的** |
| **AnifuSion** | LoRA 訓練 + 出版級匯出（可上 Amazon KDP） | 走日漫風 / 要印成書 |
| **ComicAI** | 上傳照片秒變漫畫、免費額度 | 隨手玩，但長篇會飄 |
| **Canva** | 排版/對話框/中文字最強，但**不是**做一致性的 | 當「最後組版工具」配上面任一個 |

**搭配建議**：用 Dashtoon / NB Pro 生角色圖 → 丟 Canva 排版 + 補中文字。

---

## 八、給技術控的「最高天花板」路線（阿地參考，非必須）

如果哪天要追求極致一致性，最高天花板是開源技術流（但要顯卡或租雲端 GPU，純技術用）：
- **Flux Kontext**：連載漫畫一致性最強，比 IP-Adapter 好。
- **Flux PuLID**：純鎖臉 94-96%，最高。
- **角色 LoRA + IP-Adapter FaceID + ControlNet**：最穩的量產組合。
- **不想本機裝**：上 **RunComfy / ThinkDiffusion** 雲端，瀏覽器直接跑現成工作流。

---

## 九、阿地的下一步（3 步驟，今天就能試）

1. **做一張「地藏菩薩母版定裝照」**：中性站姿、正面、乾淨背景，擴成正/側/背三視圖角色表。存好。
2. **每一格都這樣生**：母版丟參考槽 → 衣服特寫丟「物品保真槽」 → 貼身份鎖定咒語 → 一格只改鏡頭/場景 → **永遠參考母版、不要參考上一張**。
3. **試 1 章 12 格**，並排檢查，飄掉的那 1-2 格局部重生。完成寫一份測試結果，4 維度自評，阿元拍板。

---

## 附錄：重點來源（精選，完整清單在各分身回報）

**官方 / 能力事實**
- Google 官方發表：https://blog.google/innovation-and-ai/products/nano-banana-pro/
- 參考圖上限拆解（6 物品 + 5 角色）：https://help.apiyi.com/en/gemini-14-reference-images-object-fidelity-character-consistency-guide-en.html

**英文實戰（第一手）**
- 5 頁漫畫實測（單一 prompt、角色全程一致）：https://medium.com/@todasco/nano-banana-pro-can-make-a-comic-book-9def1e4736e0
- Reddit 社群手法整理：https://www.remio.ai/post/nano-banana-pro-manga-experiments-3-creative-use-cases-showcased-by-the-reddit-community
- Chase Jarvis 模組化建角色（Weavy）：https://chasejarvis.com/blog/how-to-build-characters-from-a-sketch-with-nano-banana-weavy/
- 衣服一致性 7 解法：https://www.neolemon.com/blog/why-do-my-ai-characters-keep-changing/

**中文實戰（建議優先讀）**
- 方格子 Thomas《500 張圖後我學會和香蕉對話》：https://vocus.cc/article/68c6c9f2fd897800010ebd42
- 創作邦 Kevin《Nano Banana 超完整攻略》：https://blog.creatorhome.tw/nano-banana/
- Lovart 實戰教程（沉默王二）：https://javabetter.cn/sidebar/itwanger/ai/nano-banana-2-lovart.html

**替代工具**
- 漫畫工具評比：https://www.comicink.ai/blog/best-ai-comic-generators-2026
- Leonardo 角色一致：https://leonardo.ai/news/character-consistency-with-leonardo-character-reference-6-examples
- Scenario 訓練角色：https://help.scenario.com/en/articles/train-a-consistent-character-model/
- Replicate 訓練 Flux：https://replicate.com/blog/fine-tune-flux

---
_阿研 2026-06-01｜8 個分身平行調查整合｜下一棒可續：阿地測試結果回來後更新「實測 vs 理論」對照_
