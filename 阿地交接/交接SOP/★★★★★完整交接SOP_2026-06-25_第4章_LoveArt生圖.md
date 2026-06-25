# 第 4 章 — LoveArt(阿美)生圖 SOP 完整實戰

> 配合主檔:`★★★★★完整交接SOP_2026-06-25_阿地總集篇.md`
> 技能包:`anthropic-skills:loveart-amei-card-command`(召喚關鍵詞:@角色卡/生圖命令/一張一張送/防漂移)

---

## 4.1 LoveArt 是什麼

- **平台**:lovart.ai(阿美的家)
- **引擎**:All models → Nano Banana Pro(可生繁體中文 0 亂碼)
- **暱稱**:LoveArt Agent = 阿美(2026-05-17 阿元命名)
- **付費版**:阿美爸爸(免費版能用)
- **特性**:
  - ✅ 支援 @角色卡身分鎖定(85-95% 一致性)
  - ✅ Nano Banana Pro 能直接生繁體對白 + 旁白 + 頁碼
  - ✅ Edit Text 改氣泡字 / Edit Element 局部修(不用 re-roll)
  - ❌ **沒有** Custom Character 訓練功能(已查證,別找了)
  - ⛔ 連續送 N 張會觸 CAPTCHA → 一張一張送
  - ⛔ 鎖屏/最小化 → visibilityState=hidden → Slate 拒絕 type → 必須 visible+focus

---

## 4.2 開工前準備

1. **chrome 必須前景可見**(不能最小化、不能切走 tab)
2. **找到 LoveArt 畫布 tab**:`https://www.lovart.ai/canvas?projectId=XXX`
3. **檢查當下台北時間**:`bash TZ='Asia/Taipei' date`(不要憑記憶)
4. **檢查當前篇號**:`ls "每篇貼文/" | grep 第N篇` → 用真實資料夾名

---

## 4.3 ★★★★★ 標準送圖 SOP(死命令 0 + 7 + 8)

### Step 1 — 選 chip(@角色卡)

⛔ 純文字 @ 沒用!阿美看不到圖,角色會漂移。必須**從下拉選單點卡變 chip**。

```javascript
// 用 chrome MCP computer.type 觸發 dropdown:
await computer.left_click([editor 座標]);
await computer.type("@色彩飽和");  // 多打一字 debounce
// 等 1-2 秒 dropdown 出現
await computer.left_click([dropdown 第 1 項座標]);  // 變 chip
// 重複加其他卡:@地藏 / @佛陀 / @大眾 / @一般人物 / @色彩飽和度參考
```

★ chip 順序建議:
```
@色彩飽和度參考 @角色卡(主角) @大眾(配角)
```

★ chip 驗證:
```javascript
ed.querySelectorAll('span[contenteditable="false"]')  // 應有 N 個 chip
```

### Step 2 — Paste 命令(死命令骨架)

```javascript
const text = `★★★★★ 風格鎖死命令:**吉卜力 Studio Ghibli 天空之城 2D 動畫水彩風!**
高飽和、人物臉部柔和圓潤、線條清晰、平面動畫質感。⛔絕無 photo-realistic / 3D / CGI。

🎨 場景(中景, 吉卜力電影分鏡感):[場景描述]
💭 旁白方框(左上, 淺黃底, 繁體):「[旁白文字]」
🗣️ 對話氣泡(圓潤泡, 繁體白話):[角色](情緒):「[對白]」
📌 頁碼:右下角白圓黑字 N/12

✅ 吉卜力天空之城動畫水彩 + 高飽和 + 1:6 比例(不巨人) + 全繁體無簡體無錯字 + 1:1 正方形 2K 無邊框。只生成這一張。⛔本篇不出現地藏。標記「篇N之N_主題_吉卜力版」。`;

const ed = document.querySelector('[contenteditable="true"]');
ed.focus();
const range = document.createRange();
range.selectNodeContents(ed);
range.collapse(false);
const sel = window.getSelection();
sel.removeAllRanges();
sel.addRange(range);
const dt = new DataTransfer();
dt.setData('text/plain', text);
ed.dispatchEvent(new ClipboardEvent('paste', {
  bubbles: true,
  cancelable: true,
  clipboardData: dt
}));
```

★ Paste 後驗證:`ed.innerText.length > 300` 且 `tail` 含「標記...」

### Step 3 — Return 送出(永遠用 Enter)

```javascript
await computer.key("Return", tabId);  // CDP 真實 keystroke
await computer.wait(3);
// 驗證:editor 變空(innerText.length === 1)+ chat 出現命令文字 + 阿美回「使用 Nano Banana Pro 生成中」
```

⛔ **絕對禁止**:`sendBtn.click()` / `left_click [send 座標]` / `Ctrl+Enter`

### Step 4 — 親眼驗圖(死命令 8)

不是只看 busy → idle,要**三件齊備**:
1. 阿美回「讓我生成」
2. 「生成中」
3. 「✅ 創作完成」+ **真的多一張 N/12 圖在 chat 區**

```javascript
// 用 screenshot 確認看到新圖,不要只信 status
```

★ 如果只看到「使用 Nano Banana Pro」但沒進度條 / 沒新圖出現超過 5 分鐘 → **阿美卡住,立刻 reload**(死命令 -1)

---

## 4.4 paste 失敗的備案

實測常遇到:DataTransfer paste event 被 React 忽略,editor 還是 1 字。

### 備案 A — chrome computer.type 直接輸入

```javascript
await computer.left_click([editor 座標]);
await computer.wait(1);
await computer.type("★★★★★ 風格鎖死命令:...完整命令", tabId);
await computer.key("Return", tabId);
```

★ 中文 type 慢但**永遠成功**,適合救急

### 備案 B — Lexical 內部 setEditorState

```javascript
// 取得 lexical editor instance:
const editor = document.querySelector('[contenteditable="true"]').__lexicalEditor;
editor.update(() => {
  // ... 用 Lexical API 插文字
});
```

(複雜但最穩,要查 Lexical API)

### 備案 C — windows-mcp Clipboard + Ctrl+V

```javascript
// 阿元電腦寫 clipboard:
await windows.Clipboard("set", text);
// chrome:
await computer.left_click([editor 座標]);
await computer.key("ctrl+v", tabId);
```

---

## 4.5 卡住 SOP(死命令 -1)

### 症狀
- editor 已送(清空),但 chat 無新回應
- 「Nano Banana Pro 排隊中」異常長(10+ 分鐘)
- 連續送多張後 silent block

### Reload 步驟
```javascript
await chrome.javascript_tool({
  tabId: XXX,
  text: "window.location.reload();"
});
await computer.wait(10);  // 等載入
// 重 paste 命令 + Enter
```

★ Reload **一次為限**,不連續(會觸 CAPTCHA)
★ Reload 後若顯示 hCaptcha → 等阿元手動勾,別硬上

---

## 4.6 ⛔ 死命令 6 — 不要誤刪畫布參考圖

血淚教訓:用 `ctrl+a + Backspace` 試圖清 editor → 焦點跑到畫布 → 所有圖被刪!Ctrl+Z 才救回。

### ✅ 正確清空 editor

```javascript
const ed = document.querySelector('[contenteditable="true"]');
ed.focus();  // ★ 確保焦點在 editor
const range = document.createRange();
range.selectNodeContents(ed);
const sel = window.getSelection();
sel.removeAllRanges();
sel.addRange(range);
document.execCommand('delete', false);
// 驗證:ed.innerText.length === 0 或 1
```

### ⛔ 絕對禁止
- 用 chrome computer 的 `ctrl+a` 鍵盤組合
- 任何 select all 範圍可能擴到畫布

### 清空前後必做截圖
- clear 前 screenshot,確認畫布有圖
- clear 後 screenshot,確認畫布還在(只 editor 變空)

---

## 4.7 chip dropdown 常見錯選

dropdown 順序會隨「最近用過」變動,**座標 click 容易選錯**。

### 症狀
- 想選「人物參考-4」結果選到「文殊菩薩」
- 想選「地藏王菩薩」結果選到「金剛藏菩薩」

### 解法
```javascript
// 用 JS 找 dropdown 項目 by text:
const items = document.querySelectorAll('[role="option"]');
const target = Array.from(items).find(i => i.innerText.includes('地藏王'));
target?.click();
```

### Backup:DOM 移除錯 chip
```javascript
ed.querySelectorAll('span[contenteditable="false"]').forEach(c => {
  if (c.innerText.includes('文殊') && 不該有文殊) c.remove();
});
```

⚠️ React 可能 re-render 把 chip 加回 → 多試一次或忽略(阿美仍以命令文字為準)

---

## 4.8 LoveArt API daemon(半夜衝量)

當阿元睡了想夜衝 50 張時:

### 召喚技能包
`anthropic-skills:loveart-auto-generate`

### 啟動 daemon
```
1. 阿元電腦執行 start_daemon.bat(沙箱跑不了,403 被擋)
2. daemon 讀每篇「生成命令_LoveArt.md」
3. 自動帶角色卡參考圖
4. 用 OpenClaw skill + Nano Banana Pro API
5. 生圖存進該篇「圖片/」夾
```

### 為什麼要在阿元電腦跑
- LoveArt CDN 認 Referer,沙箱 IP 被擋(實測 HTTP 403)
- 阿元電腦的 chrome session cookie 已登入
- 阿研已驗證 API 法 ≈ LoveArt 法(同命令 + 同 ref → 95% 相同結果)

---

## 4.9 下載生好的圖

阿美生完圖在畫布上,要下載到 `每篇貼文/yyyy-mm-dd_第N篇_品/圖片/`。

### 召喚技能包
`anthropic-skills:loveart-download-skill`

### 核心技術:Windows PS1 + UTF-8 BOM

```powershell
# 第一行必須:chcp 65001 > nul
$ProgressPreference = 'SilentlyContinue'
$headers = @{
  "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/130.0.0.0"
  "Referer" = "https://www.lovart.ai/"  # ★ 沒這行 403
}
$urls = @(
  "https://a.lovart.ai/artifacts/agent/xxx1.png",
  # ...
)
# 用 Python urllib(PS Invoke-WebRequest 對 LoveArt 沒效)
```

★ 完整範本見技能包 `loveart-download-skill`

### 為什麼要 BOM
PS 5.1 用 ANSI 解析中文會 ParserError → .ps1 檔案必須存成 UTF-8 BOM 才能跑中文路徑

---

## 4.10 篇 12 經書索取 — 觀音菩薩

第 12 張固定是「《地藏菩薩本願經》紙本索取 promo」:

```
🎨 場景:@觀音菩薩 漢傳造型(華麗金色漢式天冠、冠中阿彌陀佛化佛、
       白金紅綠天衣、瓔珞莊嚴),雙手恭敬向上捧著一本紙本經書;
       經書封面用清楚的繁體楷書金字寫著「地藏菩薩本願經」七個字
       (務必「本願經」,絕不可寫成「十輪經」)
💭 旁白:「免費索取《地藏菩薩本願經》紙本經書」
🗣️ 對話:「私訊我們『我要索取地藏經』🌸」
📌 頁碼 12/12
```

⚠️ 經書封面文字**鐵則檢查**:必須「**本願經**」不是「十輪經」(這篇是十輪經連載,但贈書是本願經入門)

---

## 4.11 一張一張送 vs Batch

### 阿元拍板(2026-05-21):一張一張送

血淚教訓:
- batch 5 / 12 張 → 頁碼不一致 / 阿美只做後半
- 阿美「魔法咒語」(2026-05-23 試過,12 張一次送)→ 不穩
- 一張一張送 → 85-95% 角色一致性(死命令 8)

### 例外:阿研滾動參考法(2026-06-01)
- 不鏈上一張(會雪崩)
- **母版鎖定**:固定餵原始 ref + 對應 8K 角色卡
- 一格只改一變數逐字不變
- ref 最多 6 張封頂

---

## 4.12 完整命令範本(v8 — 100 篇通用)

```
★★★★★ 風格鎖死命令:**吉卜力 Studio Ghibli 天空之城/神隱少女 2D 動畫水彩風!**
色彩高飽和、人物臉部柔和圓潤、線條清晰、平面動畫質感。
⛔絕無 photo-realistic / 3D / CGI。

🎨 場景(中景, 吉卜力電影分鏡感, 動畫水彩感):
[詳細場景:時代古印度 2500 年前 / 棕膚 / 印度服飾 / 菩薩漢傳造型]
[人物動作、表情、姿態]
[背景:菩提樹 / 古印度村落 / 暖金光束 / 丁達爾光柱 / 藍天]

💭 旁白方框(左上, 淺黃底, 繁體):「[場景旁白白話]」
🗣️ 對話氣泡(圓潤泡, 繁體白話):[角色](情緒):「[對白]」
📌 頁碼:右下角白圓黑字 N/12

✅ 吉卜力天空之城動畫水彩 + 極高飽和度、色彩鮮豔明亮飽滿、避免灰淡霧化
+ 水粉質感 + 丁達爾光 + 成人 1:6 比例(不巨人)
+ 全繁體無簡體無錯字
+ 1:1 正方形 2K 無邊框

只生成這一張。⛔本篇不出現地藏(篇 8 才出場)。
標記「篇N之N_主題_吉卜力版」。
```

---

🪷 一張一張送,親眼驗圖,守護承諾如守護初心
