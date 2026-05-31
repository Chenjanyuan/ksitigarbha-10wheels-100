---
name: comic-character-consistency
description: >-
  製作 AI 連環漫畫（多格 panel）時，維持「同一個角色跨格不變臉、不變裝、不漂移」的完整 SOP。
  適用任何角色與專案 — 地藏十輪經 100 篇、WhatDog 狗狗連環漫畫等。涵蓋 Nano Banana Pro
  引擎（LoveArt 平台 與 直接 Gemini API daemon 兩條路）、Character Bible、Sequential Art
  滾動參考、Custom Character 訓練、prompt 工程、85% 法則。當使用者要做連環漫畫、角色設定、
  跨格一致性、storyboard、分鏡圖時使用。
---

# AI 連環漫畫角色一致性製作 SOP

> 阿地6號 + 阿研2號 2026-05-31 整理。來源：Google Cloud 官方 prompting 指南 + Lovart 官方一致性指南 + 我們自己的受控實驗。
> **通用技能** — 地藏專案（阿地）、WhatDog 狗狗漫畫（阿狗）皆適用。

---

## 0. 一頁速查（趕時間看這個）

1. **引擎都是 Nano Banana Pro**（= Gemini 3 Pro Image）。兩條路出圖品質同級、可互換：
   - **LoveArt 平台**：免費、慢(5-7分/張)、會觸 CAPTCHA、平台會自行擴寫 prompt。
   - **API daemon**：每張~NT$5、30-50秒、穩、不觸 CAPTCHA、送什麼收什麼。**衝量建議用這條。**
2. **鎖角色＝丟一張好參考圖當錨點**（官方：一張 ≥1024、光線清楚、正面/3-4側、背景單純就夠，多張只多 5-10%）。
3. **prompt 用結構化 brief，不要堆關鍵字**：`[主角+特徵][動作][場景][構圖][光線][風格][文字]`。
4. **要顯示的文字用雙引號**鎖定：`對話氣泡寫 "南無地藏王菩薩"`。
5. **同篇多格用 Sequential Art**：第 2 格起，把前 1-2 張完成圖也當參考。
6. **改圖用 Edit 局部改，不要整張 re-roll**（re-roll 會變）。
7. **85% 是天花板**：每篇預留 15% 修圖，1-2 張需修是正常，別追 100%。
8. **服裝比臉難固定** → 服裝單獨給一張特寫當 ref，且 prompt 明寫 `exact same outfit`。
9. **長期最高 ROI：訓練 Custom Character**（10-20 張、30-60 分、>90% 一致，之後 @角色名 呼叫）。出現在 50 張以上的角色都該做。

---

## 1. 為什麼角色會漂移（原理）

AI 圖像生成器**不「認識」你的角色**。每次生成都是從符合 prompt 的機率分佈重新取樣，對特定角色沒有持續記憶。即使同 prompt，兩次生成也會在細節上累積成不同臉孔。

Nano Banana Pro 是 **Thinking model**：它會先「理解」prompt，並對參考圖建立一個暫時的「隱形 3D 模型」鎖住角色，再上色。所以：
- **給它真實參考圖像素** → 它真的「看到」角色去複製 → 鎖得住。
- **只給文字描述** → 它自由發揮 → 漂移。
- **把前一格也當參考** → 它認得是同一個 3D → 自然延續。

> ⚠️ 我們實測：同一段 prompt + 同一張參考圖，丟 API 和 LoveArt，出圖 95% 相同。
> 結論：**差異主因是「命令/參考圖給法不同」，不是引擎差。** 控制好變因，兩邊可互換。

---

## 2. 三層解法

### 第一層 — 基礎（必做，解 60%）
1. **用參考圖鎖定**（上傳真實圖，不要只用文字描述；不要只貼 URL 文字，引擎看不到 URL）。
2. **角色卡 + 服裝特寫 + 場景，分開給**（服裝單獨一張，因為服裝最會變）。
3. **結構化 brief**（見第 4 章框架）。

### 第二層 — 中階（解 90%）
4. prompt 加英文片語：`exact same outfit` / `consistent character design` / `same face`。
5. **Sequential Art 滾動參考**（見第 3 章）。
6. **Character Bible**（見第 5 章）— prompt 細節從固定文件複製，不靠記憶。

### 第三層 — 專家（長期收益最大）
7. **Custom Character Trainer**（Lovart）：10-20 張訓練 → @角色名 >90% 一致。
8. **Edit 不 Re-roll**：80% 對的圖用對話局部改。
9. **背景/角色分開生再合成**（Composite）：一致性 95%+。

---

## 3. Sequential Art 滾動參考（解「12 張不像同一個故事」）

每張新 panel 的參考圖 = **角色卡 + 服裝 + 場景 + 最近 1-2 張完成的 panel**。

```
Panel 1: ref = 角色卡 + 服裝 + 場景            ← 做到完美！這是「種子」
Panel 2: ref = 角色卡 + 服裝 + 場景 + Panel1
Panel 3: ref = 角色卡 + 服裝 + 場景 + Panel1 + Panel2
...
Panel N: ref = 角色卡 + 服裝 + 場景 + Panel(N-2) + Panel(N-1)
```
（Nano Banana Pro 單一 prompt 最多吃 14 張參考圖，足夠）

**每張 prompt 加 4 行 Story State：**
```
This is panel [X] of 12 in the same story.
Previous panel showed: [一句話描述上一張]
This panel continues: [這張要演什麼]
KEEP EXACT: same character, same outfit, consistent style.
```

**超快「一張延伸法」**（趕進度）：做出完美 Panel 1 → 上傳 Panel 1 + prompt「Continue this story. Same character, same outfit. Next moment: [動作]」→ Panel 2 連貫性 95%+ → Panel 3 用 Panel 2 延伸。

---

## 4. Prompt 工程（官方驗證）

**生成公式**：`[主角+特徵] [動作] [場景/context] [構圖] [光線] [風格] [氛圍] [限制]`

**多參考圖公式**：`[參考圖們] + [關係指令] + [新情境]`（例：用附圖的臉當主角，畫他在市集中）

8 大原則：
1. 結構化 brief，不要堆關鍵字（當導演，不是貼標籤）。
2. **要渲染的文字用雙引號** `"..."`，可指定字體。
3. **Edit 不 Re-roll**：改圖明講「Keep everything the same, change [X] to [Y]」。
4. 鏡頭講明：Wide / Medium / Close-up、俯瞰 / 仰拍。
5. 光線具體：晨光 / 黃昏金光 / 神聖光暈。
6. 氛圍用感受詞：Serene / Solemn / Compassionate。
7. **整篇鎖一個畫風**，不要混。
8. **用正面描述取代禁止清單**（官方：要「空街道」勝過寫「沒有車」）。禁止清單精簡放尾段就好。
   ⚠️ 我們專案經驗一致：「禁過度強調禁止語」。

---

## 5. Character Bible（角色聖經）

專業漫畫家一定有一份角色設定文件，每次寫 prompt **從這份複製**，不靠記憶 → 細節不變。

- **空白範本**：見 `reference/character_bible_範本.md`（阿狗做 WhatDog 狗狗直接填這個）。
- **地藏官方填好版**：見 `reference/character_bible_地藏菩薩_官方.md`（寶冠9環版，⛔ 不可改）。

> 🚨 重要：通用方法可照搬，但**每個角色的長相一定用該專案鎖定的官方版**。
> 例：地藏 = 漢傳寶冠、白布披雙肩、9環錫杖、深芥末褐袈裟＋綠腰帶、**不光頭**。
> 絕不可用任何「通用範本」的預設長相覆蓋已鎖定的官方造型。

---

## 6. 兩條生成路線操作

### A. API daemon（衝量首選）
- 模型：`gemini-3-pro-image-preview`（不是 flash 便宜版）。
- 寫 `_queue/X.json`：`{"out":"篇09/9-01.png","ref_images":["篇08/8-05.png"],"prompt":"..."}`
- daemon 30 秒內處理 → 圖出在輸出資料夾 + `_done/` 記狀態。
- 預算：每張~NT$5，上限由阿元拍板。

### B. LoveArt（免費，要顧 CAPTCHA）
- 送 prompt **一律用真實 Enter**（`chrome key "Return"`，CDP keystroke，不觸機器人），**不點 send 按鈕**。
- 長 prompt 用 `clipboard.writeText` + 真實 `Ctrl+V`（DataTransfer 對長文常失敗）。
- **上傳本機圖技巧**（LoveArt 無現成 file input，點「+→上傳文件」會跳原生視窗）：見 `reference/loveart_自動上傳技巧.md`。
- 卡 5 分鐘無回應 → `window.location.reload()` 一次（不可連續 reload）。
- 一張一張送，等「✅完成」再送下一張（queue limit=1，連送會 silent block）。

---

## 7. 完整工作流

**一次性準備**：寫 Character Bible → 生角色卡(三視圖) → 生服裝特寫 → 生場景 refs → (進階)訓練 Custom Character → 存素材庫命名清楚。

**每篇**：讀原文 → 白話故事化 → 拆 12 panel 分鏡 → 鎖畫風 → Panel 1 做到完美(種子) → Panel 2-12 滾動參考 → 並排檢查、漂移的局部修 → 升 4K、加字幕 → 4 維度自評 → 寫 handoff。

---

## 8. 務實期待（85% 法則）

| 項目 | 業界天花板 | 目標 |
|---|:---:|:---:|
| 臉一致性 | 95% | 90% |
| 服裝一致性 | 85% | 80% |
| 風格統一 | 95% | 90% |

舊法每篇 4-5 張要修；新法 1-2 張要修（正常）。**接受 85%，預留 15% 修圖，追 100% 是完成的敵人。**

---

## 來源
- Google Cloud — Ultimate Nano Banana prompting guide (2026-03)
- Lovart 官方 — 2026 AI 角色一致性設計完整指南
- 我們自己的受控實驗 2026-05-31（API vs LoveArt 同命令同 ref → 95% 相同）

🌸 南無地藏王菩薩 / WhatDog 旺！
