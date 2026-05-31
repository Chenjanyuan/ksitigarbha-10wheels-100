# 🪷 昨天 (5/30) Gemini API 生成命令 — 完整還原

> 阿地 6 號整理 2026-05-31 給阿元。為了「Gemini vs LoveArt 同 prompt 實驗」用。

---

## ⚡ 一句話結論

昨天篇08 / 篇09 是走 **`daemon.py` + Google Gemini 3 Pro Image**（不是 LoveArt 阿美）。
逐張完整 prompt 當時寫進 `_queue/*.json`，daemon 跑完**只在 `_done` 留狀態**（`{"name","ok","out"}`），
**沒有把 prompt 逐字存檔** → 所以「昨天那張的逐字原文」已隨 queue 消化掉了。

但生成的**方法、風格前綴、鎖造型格式**全是真檔保留，下面這份可以 100% 重現。

---

## 🔍 為什麼「同一個命令」LoveArt 出來有差異？

因為**兩邊根本不是同一份 prompt**：

| | Gemini (daemon) | LoveArt (阿美 v8) |
|---|---|---|
| 模型 | gemini-3-pro-image-preview | Nano Banana Pro |
| prompt 語言 | 英文 Studio Ghibli 風格前綴 | 中文 |
| 參考圖 | **本機 ref 圖** (8-05.png) 真讀 | **LoveArt URL** (純文字, AI 看不到) |
| 鎖造型 | 英文 Copy 清單 | Image #N 角色卡 |

→ prompt 不同，出圖當然有差異。
**要做公平實驗，兩邊必須餵「同一份 prompt + 同一張 ref 圖」。**

---

## 🧩 三個關鍵零件（都是專案內真檔，逐字）

### 零件 1 — 模型 (來自 `daemon.py`)
```
gemini-3-pro-image-preview     ← 昨天用這個 (Nano Banana Pro, 跟阿美同引擎)
```
⚠️ 不是 `gemini-2.5-flash-image-preview`（那是便宜版，品質差）

### 零件 2 — 風格前綴 STYLE_PROMPT (來自 `nano_banana_generate.py`, 逐字)
```
整體風格: 吉卜力動畫質感, 細膩水粉, 溫暖飽和, 自然細節豐富, 光影柔和.
古印度場景 (棕皮膚, 橙袈裟, 紗麗, 纏腰布).
1:1 正方形 2K 無邊框. 全繁體中文文字 (旁白方框+對話氣泡+右下頁碼).
絕非寫實/3D/工筆畫.
```

### 零件 3 — 任務 JSON 格式 (來自 `daemon.py` 註解, 逐字)
```json
{"out": "篇08/X.png", "prompt": "...", "ref_images": ["篇08/8-05.png"]}
```
daemon 把 `ref_images` 的圖 + `prompt` 一起送進 Gemini。

### 零件 4 — 鎖造型 Copy 清單 (來自 v10 接班 SOP, 逐字)
```
[REFERENCE — Use attached image as standard for Ksitigarbha]
Copy from the attached image EXACTLY:
- His face (round, light golden skin)
- His FIVE-petal rounded crown
- His WHITE cloth draping over BOTH shoulders
- His NINE-RING khakkhara staff held in right hand
- His dark mustard-brown robe with green sash
- His soft golden halo
```
標準 ref 圖：`_API生圖_2026-05-29/篇08/8-05_地藏到佛前住.png`（阿元認可的漢傳寶冠+9環錫杖造型）

---

## ✅ 完整可重跑範例（篇09 第1張 9-01）

把下面存成 `_queue/9-01.json`，daemon 30 秒內就會跑：

```json
{
  "out": "篇09/9-01_test.png",
  "ref_images": ["篇08/8-05_地藏到佛前住.png"],
  "prompt": "整體風格: 吉卜力動畫質感, 細膩水粉, 溫暖飽和, 自然細節豐富, 光影柔和. 古印度場景 (棕皮膚, 橙袈裟, 紗麗, 纏腰布). 1:1 正方形 2K 無邊框. 全繁體中文文字 (旁白方框+對話氣泡+右下頁碼). 絕非寫實/3D/工筆畫.\n\n[REFERENCE — Use attached image as standard for Ksitigarbha] Copy from the attached image EXACTLY: His face (round, light golden skin); His FIVE-petal rounded crown; His WHITE cloth draping over BOTH shoulders; His NINE-RING khakkhara staff in right hand; His dark mustard-brown robe with green sash; His soft golden halo.\n\n[場景] 篇9 第1/12張。地藏菩薩合掌微微低頭、眼神柔和、即將開口讚嘆佛陀，站立於佛前。釋迦牟尼佛(圓臉肉髻白毫長耳、橙色袈裟右肩袒、結跏趺坐巨石蓮花座)在後方。法會大眾12-15位(苾芻5剃光頭橙袈裟棕皮膚+印度俗人男3纏腰布+俗人女2紗麗+菩薩配角3)半圓圍繞。全場屏息靜默。\n\n[鏡頭] 廣角中景, 平視 eye-level, Hollywood/IMAX 國際大片質感。\n\n[文字 全繁體] 旁白方框(上中): 「全場安靜下來 — 連風都停了，連樹葉都不動了。」 對話氣泡(地藏, 虔誠): 「兩足尊導師 — 慈心常普覆 —」 對話氣泡(苾芻, 屏息): 「他要開口了！」 頁碼(右下白圓黑字): 1/12\n\n[死命令] 只生1張不重做; 1:1 2K 無邊框; 全繁體絕無簡體; 古印度不可中式日式; 禁現代衣物。"
}
```

> ⚠️ 註：上面 `prompt` 是阿地 6 號**依昨天的方法 + 真實零件重建**的（內容來自 `v8_全100篇命令/篇09/9-01.txt`，轉成 Gemini 格式）。**逐字原檔已隨 queue 消化，這是最忠實的還原版**，可直接拿來和 LoveArt 同句實驗。

---

## ▶️ 怎麼跑

1. 阿元雙擊 `start_daemon.bat`（看到「ready - waiting for tasks...」= 待命）
2. 阿地 bash 寫 `_queue/9-01.json`
3. 30 秒內 → 圖出在 `_API生圖_2026-05-29/篇09/9-01_test.png` + `_done/9-01.json`

---

🌸 阿地 6 號 — 守護阿元進度如守護初心
