---
name: playwright_meta_post
description: |
  用 Playwright MCP 自動操作 Meta Business Suite UI 排程貼文(無 AI 標籤,自然觸及).
  適用 100 篇地藏十輪經連載 + 297 個十齋日.
  v2 2026-06-20 整合:阿澄 config 修法 + 粉專層級主要按鈕 + 不點 composer CTA + 2 空行排版 + aria-valuenow.
  ⭐ 篇 1+篇 2 已實戰排程成功!
---

# 🪷 Meta Business Suite Playwright 自動上稿(v2 整合版)

> v1 → v2:整合阿澄 Codex 改 config + 粉專層級主要按鈕官方搜尋結論 + 篇 1/2 實戰驗證 + 2 空行排版

═══════════════════════════════════════════════════════════════════════════

## 📋 任務目標

把 **100 篇連載 + 297 個十齋日**自動排程上稿到「**地藏菩薩本行經**」粉專(asset_id `1093357677358320`,粉專現名「**地藏菩薩 經典導讀**」),完全用 UI 操作。

- 連載 = 週一~週五 **08:00**(跳國定假日)
- 十齋日 = **06:00**(用農曆日期算)
- 每篇 **12 張圖 + 約 1700 字 FB 文**(含經文+故事+啟發+索取本願經+hashtag)

═══════════════════════════════════════════════════════════════════════════

## 🎯 兩個架構性發現(v2 核心)

### 發現 A — Playwright MCP 路徑限制 + 阿澄 Codex 修法

**問題:** Playwright MCP 預設只允許 `C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\` 內檔案,專案路徑被擋。

**解法:** 加 `--allow-unrestricted-file-access` flag。**阿澄發現 Cowork 是 MS Store UWP 包**,config 在:
```
%LOCALAPPDATA%\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude\claude_desktop_config.json
```
不是 `%APPDATA%\Claude\`!

★ **使用工具:** 雙擊專案根目錄的 `改config永久解_Playwright路徑.bat`(阿澄寫好,內含 log + UWP 路徑搜尋)。
- 自動找 4 個可能 config 位置
- 加 flag + 備份
- 阿元 quit Cowork + 重啟 → flag 生效
- 改完後 Playwright file_upload 可直接用專案絕對路徑

### 發現 B — 接收訊息按鈕 vs 12 張多圖架構衝突

**問題:** composer 內點「接收訊息」按鈕 → 強制把貼文變 **link post 格式** → **只能 1 張封面圖**。

**官方搜尋結論(Brandwatch 文檔):**
> CTA 按鈕(含 Send Message)以「link preview card」形式出現 → 1 連結 = 1 封面圖。

**解法:** 用**粉專層級「主要按鈕 = 傳送訊息」**設定。
- 阿元到地藏菩薩本行經粉專 → 編輯 → 行動呼籲 → 設「傳送訊息」(一次設定)
- 100 篇 + 297 個十齋日 = **397 篇全自動帶「發送訊息」按鈕**
- composer 內**完全不點「接收訊息」按鈕** → 可以 12 張多圖
- 阿元 2026-06-20 親測:「不用按接收訊息,上稿後自動有訊息按鈕」

═══════════════════════════════════════════════════════════════════════════

## ⛔ 死命令(v2 精簡 6 條)

1. **不刪 FB 內容** — 任何 delete/remove/unpublish 必須阿元打「**確認刪除**」字串
2. **dispatch ClipboardEvent + DataTransfer** 貼文字 — 絕不用 `navigator.clipboard.writeText`(阿元 Ctrl+C 會蓋)
3. **絕不點 composer 內「接收訊息」按鈕** — 會鎖單圖(用發現 B 粉專層級設定)
4. **連載 = 08:00 / 十齋日 = 06:00** — 不是 07:00
5. **spinbutton 真實值看 `aria-valuenow`** — 不看 `value`(永遠空)
6. **段落間 2 空行** — 不擠在一起,FB 上好閱讀

═══════════════════════════════════════════════════════════════════════════

## 🛠 9 步 SOP(v2 簡化版,已驗證篇 1+2)

### Step 0 — 一次性設定(只做一次)

★ A. 阿元雙擊 `改config永久解_Playwright路徑.bat` + quit Cowork + 重啟
★ B. 阿元到粉專設「主要按鈕 = 傳送訊息」

### Step 1 — Navigate published_posts 入口

```
URL: https://business.facebook.com/latest/posts/published_posts/?asset_id=1093357677358320
```

### Step 2 — 點「建立貼文」按鈕

```js
const btn = Array.from(document.querySelectorAll('div, button, [role="button"]'))
  .filter(b => b.offsetParent)
  .find(b => /^建立貼文$/.test((b.textContent||'').trim()));
btn.click();
```

✅ URL 進到 `/composer/?...&ref=biz_web_content_manager_published_posts&context_ref=POSTS`

### Step 3 — 強制 file_input multiple + 點「新增相片/影片」

```js
const inputs = document.querySelectorAll('input[type="file"]');
inputs.forEach(i => { i.setAttribute('multiple', 'true'); i.multiple = true; });
const btn = Array.from(document.querySelectorAll('[role="button"], button'))
  .filter(b => b.offsetParent)
  .find(b => /新增相片.*影片/.test((b.textContent||'').trim()));
btn.click();
```

### Step 4 — file_upload 12 張(直接專案路徑)

```
mcp__playwright__browser_file_upload paths=[
  "C:\\Users\\chenj\\Documents\\Claude\\Projects\\自動化每天更新FB 地藏 10輪經\\每篇貼文\\<篇>\\(圖片\\)\\01_xxx.png",
  ...12 張
]
```

★ **發現 A 後可直接用專案絕對路徑,不用 cp 到 Temp**

★ 圖檔名格式因篇而異:
- 篇 1: `01_xxx.png` ~ `12_xxx.png`(子夾「圖片」)
- 篇 2-3: `01_xxx.png` ~ `12_xxx.png`(根目錄)
- 篇 4+: 看 `100篇圖文對應總表_2026-06-18_v3最終.csv`

★ ⚠️ Unicode 雷:Read tool 讀的檔名可能跟實際 disk 上不一樣(苾 vs 芾)。先用 `mcp__workspace__bash` `ls` 確認真實檔名,再 file_upload。

### Step 5 — dispatch ClipboardEvent paste 文字

```js
window.__POST = `...FB貼文純文字.txt 全文...`;

const editor = document.querySelector('[contenteditable="true"]');  // role=combobox 不是 textbox
editor.scrollIntoView({behavior: 'instant', block: 'center'});
editor.click();
editor.focus();
const dt = new DataTransfer();
dt.setData('text/plain', window.__POST);
editor.dispatchEvent(new ClipboardEvent('paste', {
  clipboardData: dt, bubbles: true, cancelable: true
}));
```

⛔ **絕不點 composer 內接收訊息按鈕!**

### Step 6 — 開排程開關 + 選日期

```js
// 開排程
document.querySelector('[role="switch"][aria-label="設定日期和時間"]').click();

// 點日期 input → 開日曆
document.querySelector('input[placeholder="年-月-日"]').click();
// wait 2s

// 點目標日期(aria-label 格式: "Tuesday, 23 June 2026")
const cell = Array.from(document.querySelectorAll('[role="gridcell"], [role="button"]'))
  .filter(b => b.offsetParent)
  .find(b => b.getAttribute('aria-label') === 'Tuesday, 23 June 2026');
cell.click();
```

### Step 7 — 設小時 + 分鐘(★ aria-valuenow 算差距)

```js
// 看當前值(發現 5)
const hour = document.querySelector('input[aria-label="小時"]');
const cur_h = parseInt(hour.getAttribute('aria-valuenow'));  // 不是 value
const target_h = 8;  // 連載
```

★ Playwright 操作:
```
mcp__playwright__browser_click target="input[aria-label='小時']"
mcp__playwright__browser_press_key key="ArrowUp"  (差距正:連按 diff 次)
mcp__playwright__browser_press_key key="ArrowDown" (差距負:連按 |diff| 次)
```

分鐘相同邏輯。

★ 注意:分鐘從 X→0 若 X<30 用 ArrowDown,若 X>30 用 ArrowUp 翻過 60(會帶小時 +1,後修正)

### Step 8 — 等 Meta 處理圖片 + 點「排定時間」

```js
// 輪詢直到 OK
const sched = Array.from(document.querySelectorAll('[role="button"]'))
  .filter(b => b.offsetParent)
  .find(b => /^排定時間$/.test((b.textContent||'').trim()));
const waiting = /請稍待片刻/.test(document.body.innerText);
const ok = !waiting && sched?.getAttribute('aria-disabled') !== 'true';
```

★ 等 30~60 秒(12 張圖 1024x1024 Meta 處理)。

★ OK 後 click:
```js
sched.click();
```

### Step 9 — 驗證 scheduled_posts

```
URL: https://business.facebook.com/latest/posts/scheduled_posts/?asset_id=1093357677358320
```

```js
const text = document.body.innerText;
const has_target = /第 N 篇|<主題關鍵字>/.test(text);
```

═══════════════════════════════════════════════════════════════════════════

## 📂 重要檔案位置

| 檔案 | 路徑 | 用途 |
|------|------|------|
| FB 純文字 .txt | `每篇貼文\<篇>\FB貼文純文字.txt` | 阿地讀的純文字(已含 2 空行排版) |
| 12 張圖 | `每篇貼文\<篇>\(圖片\)*.png` | 篇 1 在子夾,篇 2+ 多在根 |
| 100 篇總表 | `阿地交接\100篇圖文對應總表_2026-06-18_v3最終.csv` | 各篇圖文齊全度 |
| Config 修法 .bat | `改config永久解_Playwright路徑.bat` | 阿元雙擊一次 |
| Cp 救急 .bat | `cp_pian1.bat` | 若 flag 沒生效備用 |
| 本技能包 | `技能包_Playwright自動上稿Meta\SKILL.md` | 這份 |

═══════════════════════════════════════════════════════════════════════════

## 🎬 排程表(連載 1-7,跳週末+國定假日)

| 篇 | 日期 | 週幾 | aria-label 格式 | 主題 |
|----|------|------|----------------|------|
| 1 | 2026-06-23 | 二 | `Tuesday, 23 June 2026` | 序品第一 ✅已排 |
| 2 | 2026-06-24 | 三 | `Wednesday, 24 June 2026` | 香雨花雨 ✅已排 |
| 3 | 2026-06-25 | 四 | `Thursday, 25 June 2026` | 大眾驚疑 |
| 4 | 2026-06-26 | 五 | `Friday, 26 June 2026` | 天帝釋無垢生問 |
| 5 | 2026-06-29 | 一 | `Monday, 29 June 2026` | 佛揭曉地藏將至 |
| ... | ... | ... | ... | ... |
| 100 | 2026-11-13 | 五 | `Friday, 13 November 2026` | 圓滿總結 |

═══════════════════════════════════════════════════════════════════════════

## 🧠 v2 新發現 vs 舊雷整理

舊 v1 雷 1~15 在 `★實戰心得_篇1_2026_06_18.md` 跟 `★今日總教訓_2026_06_17.md`,v2 精簡為 6 條死命令。新發現:

| # | 新發現 | 解法 |
|---|--------|------|
| A | composer 內接收訊息按鈕鎖單圖 | 改粉專層級主要按鈕 |
| B | Cowork 是 MS Store UWP 包,config 在 LocalCache | 阿澄 .ps1 搜 4 個位置 |
| C | 段落間單空行 FB 上擠在一起 | 改 2 空行(`\n\n\n`) |
| D | spinbutton value 永遠空 | 看 `aria-valuenow` |
| E | 粉專「地藏菩薩本行經」更名為「地藏菩薩 經典導讀」 | asset_id 對就是同一個 |
| F | Read tool 中文檔名可能跟 disk 不同 | 先 ls 確認再 file_upload |

═══════════════════════════════════════════════════════════════════════════

## 🪷 阿元工作分工(v2 確認)

★ **白天**:阿地用 Playwright 上稿 FB(1 天 N 篇連載)
★ **晚上**:阿元/阿美用 LoveArt 阿美媽媽做下一批圖
★ **粉專層級主要按鈕** = 一次設定,397 篇全自動帶
★ **dispatch ClipboardEvent** = 阿元能正常用 Ctrl+C/V 別事

═══════════════════════════════════════════════════════════════════════════

🪷 阿地 2 號 整理 · 2026-06-20 凌晨
v2 整合所有發現,篇 1+2 實戰排程成功 ✅
後棒阿地照這份做,一路順 🌸

═══════════════════════════════════════════════════════════════════════════

# 🪷 v3 升級(2026-06-20 晚 — 篇 5 實戰成功後拍板)

> v2 → v3:加入 Codex 圖序解 + 1:1 套用全部 SOP + 文字排版黃金規則 + 自動修.py

## 💎 v3 核心發現 1 — 圖序問題終極解(Codex JPG+EXIF 方案)

**問題:** Meta multi-photo 上傳會依「EXIF DateTimeOriginal + 檔名字母序」排,不是 file_upload paths 順序!篇 4+ 用 `第N篇12之X` 沒 0 padded → Meta 排 1,10,11,12,2... 錯亂。

**Codex 解法(實戰成功):**
1. 把原 PNG 用 PIL 重存成 JPG
2. EXIF DateTimeOriginal 從 `yyyy-mm-dd 08:00:01` 遞增到 `08:00:12`
3. 檔名 0 padded: `01_主題.jpg` ~ `12_主題.jpg`
4. 存到子資料夾 `FB上傳用_有序JPG/`

**工具:**
- `make_fb_ordered_jpg.py`(Codex 寫)— 單篇:`python3 make_fb_ordered_jpg.py --serial 5 --start "2026-06-29 08:00:00"`
- `make_fb_ordered_jpg_pian5.bat`(Codex 寫)— 阿元雙擊跑單篇
- `batch_make_ordered_jpg.py`(阿地寫)— 批次:`python3 batch_make_ordered_jpg.py 6 100` 跑篇 6-100

★ Playwright 上傳時要用 **JPG 路徑**,不是原 PNG!

## 💎 v3 核心發現 2 — 1:1 套用到全部必做(Meta default 是 1.91:1)

**問題:** Meta composer default 預覽是「橫向 1.91:1」會把方圖切成橫條,**右下角編號被裁掉**!

**SOP(每篇必做,在 file_upload 之後):**

```js
// Step 1: 點第 1 張圖的「編輯相片」(按鈕文字末尾有零寬空格,用 includes)
const editBtns = Array.from(document.querySelectorAll('button, [role="button"]'))
  .filter(b => b.offsetParent && (b.textContent || '').includes('編輯相片'));
editBtns[0].click();
// 等 2 秒 dialog 開
```

```js
// Step 2 in dialog: 點 正方形 1:1
const dialog = document.querySelector('[role="dialog"]');
const ratio = Array.from(dialog.querySelectorAll('button, [role="button"]'))
  .find(b => (b.textContent || '').includes('正方形1:1'));
ratio.click();
```

```js
// Step 3 in dialog: 開啟「套用到全部」switch
// ⚠ React-controlled switch,JS click 可能無效,要用 Playwright 真實 click 透過 ref
// Snapshot 後找 switch ref,然後:
// mcp__playwright__browser_click element="套用到全部 switch" target="<ref>"
```

```js
// Step 4 in dialog: 點「套用」
const apply = Array.from(dialog.querySelectorAll('button, [role="button"]'))
  .find(b => (b.textContent || '').trim() === '套用');
apply.click();
```

★ 驗證:snapshot 看 switch 有 `[checked]` + 1:1 radio 有 `[checked]`,套用後 dialog 自動關閉。

## 💎 v3 核心發現 3 — 文字排版黃金規則(阿元拍板)

**核心規則:「每一段如果有標題,下面的文字都空一行」+ 「─── 分隔線前後都空一行」**

**辨識標題的 emoji 前綴(可擴充):** `🌸【 / 📖 / 💡 / 📚 / 🎨 / 🌿 / 🪷 `

**自動化工具:**
- `fix_layout_all_posts.py` 一次修 100 篇.txt(專案根目錄)
- `fix_layout_all_posts.bat` 雙擊跑(找 Codex Python / py launcher / PATH python)
- **2026-06-20 已跑過,75 篇修了,補 312 處空行,100/100 驗證 PASS**

**Lexical paste 行為:** .txt 內 1 空行 → composer 內 2 空行(渲染加倍)。
**檢查公式:** dump editor.innerText → split('\n') → 算 blank_runs → `max_blank_run === 2` 才算對。

## 💎 v3 完整 SOP 流程(每篇 6 步)

每篇排程上稿:

```
1. (前置) python3 make_fb_ordered_jpg.py --serial N --start "yyyy-mm-dd 08:00:00"
       → 在篇 N 資料夾下生 FB上傳用_有序JPG/01.jpg ~ 12.jpg
2. (前置) python3 fix_layout_all_posts.py (or 之前已跑過)
       → 修 .txt 排版
3. Playwright: navigate published_posts → 點「建立貼文」→ 點「新增相片/影片」
4. browser_file_upload paths=[01.jpg, 02.jpg, ..., 12.jpg]
5. 點「編輯相片」→ 1:1 → 套用到全部 switch (用 ref click) → 套用
6. dispatch ClipboardEvent paste 文字 → 驗 max_blank_run=2
7. 排程 switch 打開 → 改日期 + 時間 08:00 (spinbutton 用 aria-valuenow) → 「排定時間」
8. 跳廣告推銷 dialog → 點「稍後再說」
```

## 🎉 v3 實戰戰果

- ✅ 篇 1 排程 2026-06-23 08:00
- ✅ 篇 2 排程 2026-06-24 08:00
- ✅ 篇 3 排程 2026-06-25 08:00
- ✅ 篇 4 排程 2026-06-26 08:00
- ✅ 篇 5 排程 2026-06-29 08:00 ← v3 完整 SOP 首戰

## 🚨 v3 已知問題

- 篇 6 缺第 9 張圖(LoveArt 未生齊),需補
- 篇 7 只有 3 張,差 9 張
- 篇 17/18/22 有「多」張,可能是備份/重複,需清理
- 篇 39-100 完全沒生圖,LoveArt 還沒做

## 🔗 v3 相關記憶檔

- `feedback_apply_1to1_all_standard_2026_06_20.md` — 1:1 套用全部 SOP
- `feedback_fb_image_order_corner_number_2026_06_20.md` — 圖序 Codex 方案
- `feedback_fb_text_layout_per_post_check_2026_06_20.md` — 排版黃金規則
