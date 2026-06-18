# 🪷 一鍵貼 — Playwright 自動上稿地藏十輪經到 Meta Business Suite

> 給:下一棒阿地(或阿狗) 
> 來源:阿地 1 號 2026-06-17 整夜踩雷實戰 + 阿地 2 號 2026-06-18 路徑限制突破 
> 目的:接手繼續上稿篇 2~100 + 十齋日,不用再從頭摸索

═══════════════════════════════════════════════════════════════════════════

## 📍 第 1 步 — 觸發恢復記憶

開新對話阿元(或你自己)貼這段:

```
阿地接班,讀:
1. C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\CLAUDE.md
2. C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\阿地交接\一鍵貼模板\★一鍵貼_Playwright上稿FB_2026_06_18.md
3. C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\技能包_Playwright自動上稿Meta\SKILL.md
4. C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\技能包_Playwright自動上稿Meta\★今日總教訓_2026_06_17.md

讀完報接班點 + 待辦清單,等阿元拍板再動手
```

═══════════════════════════════════════════════════════════════════════════

## 📊 接班點(2026-06-18 凌晨)

### 已完成
- ✅ 篇 1 已排程 → 2026-06-23(週二)08:00(2026-06-17 14:56 第二次重排,接收訊息已啟用)
- ✅ Playwright MCP 已裝(cmd /c + npx -y,工具 22 個)
- ✅ Firecrawl MCP 已裝(網頁抓取)
- ✅ 技能包 v5 已封存:`outputs/playwright_meta_post_v5.skill`
- ✅ check_post.py 加了子資料夾「圖片」fallback(篇 4+ 圖在子夾)

### 待辦
- ⏳ 篇 2(序品第二)→ 2026-06-24(週三)08:00
- ⏳ 篇 3(序品第三)→ 2026-06-25(週四)08:00
- ⏳ 篇 4(序品第四)→ 2026-06-26(週五)08:00
- ⏳ 篇 5+ 排程表(從 2026-06-29 開始,跳週末+國定假日)

### 上稿時間(★死命令)
- 連載 = **08:00**(早上 8 點,不是 7 點!)
- 十齋日 = **06:00**(早上 6 點)

═══════════════════════════════════════════════════════════════════════════

## ⛔ 死命令(踩過血淚)

### 死命令 1 — 絕不刪 FB(CLAUDE.md 第一條)
- 任何 delete/remove/unpublish 動作要阿元打「**確認刪除**」字串才動
- 已排程貼文也是 FB 內容,踩到要重排很麻煩

### 死命令 2 — 貼長文字永遠用 dispatch ClipboardEvent
```js
const dt = new DataTransfer();
dt.setData('text/plain', text);
editor.dispatchEvent(new ClipboardEvent('paste', {
  clipboardData: dt, bubbles: true, cancelable: true
}));
```
⛔ **絕不用 `navigator.clipboard.writeText` + Ctrl+V** — 阿元同時 Ctrl+C 會蓋掉文字 → 排程錯誤要重排(2026-06-17 篇 1 第一次就因此中槍,內容變阿海對話)

### 死命令 3 — 接收訊息按鈕點完絕不按 Escape
- 點完氣泡跳「在貼文添加上按鈕」說明 → **等 2-3 秒讓氣泡自然關**
- 按 Escape = 取消啟用 → 排程後鎖死無法補加 → 必須刪除重排
- 驗證:截圖看到「**接收訊息 X**」標籤 + 預覽「**發送訊息**」按鈕 = OK

### 死命令 4 — 12 張圖必齊 + 圖文對照
- 上稿前跑 `check_post.py 2026-06-XX_第N篇_品名`
- 看 docx 內「圖片計畫」12 張 vs 實際資料夾 12 張對得起來
- 篇號(docx 內第 N 篇)= 資料夾名第 N 篇
- 子夾「圖片」內也算數(篇 4+)

### 死命令 5 — Playwright MCP 路徑限制(2026-06-18 新踩)
- Playwright MCP allowed_roots = `C:\Users\chenj\AppData\Local\Temp\.playwright-mcp`
- **`C:\Users\chenj\Documents\Claude\Projects\...` 路徑 file_upload 會被擋**(File access denied: outside allowed roots)
- 解法:**上稿前先把該篇 12 張圖 cp 到 allowed root**

═══════════════════════════════════════════════════════════════════════════

## 🛠 解法:Playwright MCP 路徑限制(新踩,2026-06-18)

### 方法 A — Powershell cp(推薦)
請阿元在 Run dialog(Win+R)貼:
```
powershell -NoProfile -Command "$src='C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-24_第2篇_序品第二'; $dst='C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\pian2'; New-Item -ItemType Directory -Path $dst -Force | Out-Null; Get-ChildItem $src -Filter '*.png' | Copy-Item -Destination $dst"
```
(改篇號跟資料夾名即可)

★ 子夾「圖片」版(篇 4+):
```
powershell -NoProfile -Command "$src='C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-26_第4篇_序品第四\圖片'; $dst='C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\pian4'; New-Item -ItemType Directory -Path $dst -Force | Out-Null; Get-ChildItem $src -Filter '*.png' | Copy-Item -Destination $dst"
```

### 方法 B — 改 Playwright MCP config 加 allowed root(永久解)
編輯 `%APPDATA%\Claude\claude_desktop_config.json` 的 playwright 那段,加 `--allowed-roots` arg:
```json
"playwright": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@playwright/mcp@latest",
    "--allowed-roots", "C:\\Users\\chenj\\Documents\\Claude\\Projects"]
}
```
重啟 Cowork。(❓尚未驗證,先用方法 A)

### 方法 C — 阿元 親手拖 12 張到 file picker
最直接,但失去「自動化」意義。Plan B 後備。

═══════════════════════════════════════════════════════════════════════════

## 📋 上稿 SOP(11 步,2026-06-17 阿地 1 號驗證可行)

### Step 0 — 對照檢查
```bash
python check_post.py 2026-06-24_第2篇_序品第二
```
看「✅ 對照檢查通過」才能上,否則修。

### Step 1 — Cp 圖到 allowed root
跑「方法 A 解法」powershell 命令,把 12 張 cp 到 `C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\pian<N>\`。

### Step 2 — Navigate 到規劃工具
```
URL: https://business.facebook.com/latest/content_calendar/?asset_id=1093357677358320
```

⛔ **絕不從 calendar 空白格點進去** → 會開「限時動態」composer
✅ **從右上「建立貼文」按鈕點** → 乾淨 composer(URL 含 `ref=biz_web_content_manager_calendar_view&context_ref=CONTENT_CALENDAR`)

### Step 3 — 點接收訊息按鈕
```js
// 找接收訊息按鈕
const btn = Array.from(document.querySelectorAll('[role="button"]'))
  .find(b => /接收訊息/.test(b.textContent || ''));
if (btn) btn.click();
```
⛔ **點完等 2.5 秒不按 Escape**
✅ 驗證:截圖看「接收訊息 X」標籤出現

### Step 4 — 處理草稿圖(如果有)
新 composer 偶爾有「上次未完成」草稿圖。檢查:
```js
const imgs = Array.from(document.querySelectorAll('img'))
  .filter(i => i.src.includes('fbcdn') && i.getBoundingClientRect().x < 400);
return imgs.length;
```
若 > 0:用座標 click「移除相片」按鈕(2026-06-18 已破解):
```js
const el = document.elementFromPoint(640, 380);
let p = el;
while (p && p !== document.body) {
  if (p.getAttribute('role') === 'button' || p.tagName === 'BUTTON') { p.click(); break; }
  p = p.parentElement;
}
```
驗證草稿圖 = 0 後再進 Step 5。

### Step 5 — 把 file input 強制改 multiple
```js
const inputs = document.querySelectorAll('input[type="file"]');
inputs.forEach(i => { i.setAttribute('multiple', 'true'); i.multiple = true; });
```

### Step 6 — 點「新增相片 / 影片」觸發 file chooser
```js
const all = Array.from(document.querySelectorAll('button, [role="button"]'));
const btn = all.filter(b => b.offsetParent).find(b => /新增相片.*影片|更換圖像/.test(b.textContent || ''));
btn.click();
```

### Step 7 — file_upload 12 張(用 allowed root 路徑)
```
mcp__playwright__browser_file_upload paths:
[
  "C:\\Users\\chenj\\AppData\\Local\\Temp\\.playwright-mcp\\pian2\\01_*.png",
  ...
  "C:\\Users\\chenj\\AppData\\Local\\Temp\\.playwright-mcp\\pian2\\12_*.png"
]
```

### Step 8 — 文字 dispatch paste
```js
// 找文字框
const editor = document.querySelector('[contenteditable="true"][role="textbox"]');
editor.focus();

// dispatch paste(死命令 2)
const dt = new DataTransfer();
dt.setData('text/plain', POST_TEXT); // 從 docx 讀的內文
editor.dispatchEvent(new ClipboardEvent('paste', {
  clipboardData: dt, bubbles: true, cancelable: true
}));
```

### Step 9 — 排程
1. 點「排程開關」 
2. 點日期 textbox → 選 2026-06-XX 那天
3. 設小時 = 08(spinbutton 用 ArrowUp 連按)
4. 設分鐘 = 00(注意進位)
5. 驗證時間顯示「08:00」

### Step 10 — 點「排定時間」
```js
const schedBtn = Array.from(document.querySelectorAll('[role="button"]'))
  .find(b => /排定時間/.test(b.textContent || ''));
schedBtn.click();
```

### Step 11 — 驗證 + 下篇
1. 等 3 秒
2. Escape 關廣告對話框
3. Navigate `https://business.facebook.com/latest/scheduled_posts/?asset_id=1093357677358320`
4. 截圖看該篇出現
5. 進下一篇

═══════════════════════════════════════════════════════════════════════════

## 🔴 11 雷整理(2026-06-17~18 踩過,後人別再踩)

| 雷 # | 現象 | 解法 |
|------|------|------|
| 1 | Token API 上稿 = AI 標籤 + 0 讚 | 改用 Playwright UI 操作 |
| 2 | clipboard.writeText 被 Ctrl+C 蓋 | 改 dispatch ClipboardEvent + DataTransfer |
| 3 | 連載時間誤設 07:00 | 08:00 連載 / 06:00 十齋日(hardcode) |
| 4 | spinbutton fill / type 沒效 | ArrowUp 鍵盤事件,跨進位算對 |
| 5 | 接收訊息點完按 Escape 取消啟用 | 等 2.5s 自然關氣泡,絕不 Escape |
| 6 | composer 自動載入草稿 → 12 張上不去 | 從 calendar「建立貼文」進,乾淨 composer |
| 7 | 子夾「圖片」沒被 check_post.py 偵測 | 加 fallback 找子夾 |
| 8 | 圖檔名格式不一致(篇 1-3 vs 篇 4+) | glob 找實際名,別 hard-code |
| 9 | Cowork mount 同步延遲 | Playwright 用 Windows 絕對路徑,不靠 sandbox |
| 10 | dispatch paste 1500+ 字吃 context | 一次 setup `window.__POSTS` 全局存 |
| 11 | **Playwright MCP allowed_roots 擋路徑** | Cp 圖到 `C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\` |

═══════════════════════════════════════════════════════════════════════════

## 📦 技能包路徑

### v5 .skill 檔(可安裝)
`outputs/playwright_meta_post_v5.skill`
- 結構:zip 內 `playwright_meta_post/SKILL.md`(ASCII 根目錄)
- SKILL.md frontmatter `name: playwright_meta_post`(ASCII)
- 純 UTF-8 no BOM

### 原始 md(可讀可改)
- `技能包_Playwright自動上稿Meta/SKILL.md`(11 步 SOP)
- `技能包_Playwright自動上稿Meta/★今日總教訓_2026_06_17.md`(10 雷)

### .skill 打包鐵則(4 條)
1. 根目錄 ASCII(英數/_/-)
2. SKILL.md frontmatter `name:` ASCII
3. SKILL.md 純 UTF-8 no BOM(用 Python 強制重編)
4. 內檔名建議 ASCII(中文有時被擋)

打包指令(沙箱):
```bash
cd /tmp && mkdir -p _build/playwright_meta_post && \
  cp 來源.md _build/playwright_meta_post/SKILL.md && \
  python3 -c "
import sys
p='/tmp/_build/playwright_meta_post/SKILL.md'
raw=open(p,'rb').read()
if raw.startswith(b'\xef\xbb\xbf'): raw=raw[3:]
open(p,'wb').write(raw.decode('utf-8').encode('utf-8'))
" && \
  cd _build && zip -r /tmp/x.skill playwright_meta_post -q && \
  cp /tmp/x.skill /sessions/funny-kind-darwin/mnt/outputs/
```

═══════════════════════════════════════════════════════════════════════════

## 📅 連載排程表(中華民國 115 年行事曆,跳週末+國定假日)

| 篇 | 日期 | 週幾 | 主題 |
|----|------|------|------|
| 1 | 2026-06-23 | 二 | 序品第一(已排) |
| 2 | 2026-06-24 | 三 | 序品第二 |
| 3 | 2026-06-25 | 四 | 序品第三 |
| 4 | 2026-06-26 | 五 | 序品第四 |
| 5 | 2026-06-29 | 一 | 序品第五 |
| 6 | 2026-06-30 | 二 | 序品第六 |
| 7 | 2026-07-01 | 三 | 序品第七 |

★ 完整 1-100 排程表跑:
```bash
python make_schedule.py  # 在專案根目錄
```
輸出:`排程表_115_116.xlsx`

═══════════════════════════════════════════════════════════════════════════

## 🪷 阿元工作分工保證(死命令 — dispatch paste 法達成)

★ **白天**:阿地用 Playwright 上稿 FB(1 天 1 篇連載 + 對應十齋日)
★ **晚上**:阿元/阿美用 LoveArt 阿美媽媽做下一批圖
★ 兩個並行可運作的條件:Playwright 上稿時阿元 能正常用電腦 Ctrl+C/V 別事 = 0 影響
★ 用 dispatch ClipboardEvent 法達成 ✅(絕不 navigator.clipboard.writeText)

═══════════════════════════════════════════════════════════════════════════

🪷 阿地 2 號 整理 · 2026-06-18 凌晨
給阿地 3 號 4 號 5 號 — 11 雷都踩光,你們上稿一路順
地藏菩薩本願深廣,接力同行 🌸
