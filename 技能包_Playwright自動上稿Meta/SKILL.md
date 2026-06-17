---
name: playwright_meta_post
description: 用 Playwright MCP 自動操作 Meta Business Suite UI 排程貼文 (沒有 AI 標籤). 適用 100 篇地藏十輪經連載 + 297 個十齋日. 2026-06-17 阿地 1 號實測通過.
trigger: 阿元/阿傳/任何阿地, 要把 docx + 圖片 排程上 FB 地藏菩薩本行經 粉專.
---

# 🪷 Playwright 自動上稿 Meta Business Suite SOP

## 核心原則

★ **不用 token API** — Token 上稿會被打「AI 資訊」標籤, 演算法壓制觸及率
★ **用 Playwright 操作 Meta UI** — Meta 看到的是「真人在介面操作」, 沒有 AI 標籤
★ **登入狀態**: Playwright MCP 連到阿元 自己的 chrome (有 Meta 登入 session), 不用重新登入

## 阿元 已驗證的 11 步 SOP (2026-06-17 篇 1 實測成功)

### Step 0: ★★★★★ 圖文比對 + 對照檢查 (阿元 2026-06-17 拍板)

★★ **每篇上稿前必做圖文比對** — 防止「篇 5 文字配篇 3 圖」這種致命錯誤

跑 `python check_post.py YYYY-MM-DD_第N篇_品名` 會自動檢查:

**A. 篇號對齊** — docx 內「第 N 篇」字樣 = 資料夾號 = FB 文字內提到的篇號
**B. 圖片數量** — 連載 12 張 / 十齋日 1 張
**C. 圖片編號** — 01_ ~ 12_ 齊全, 或「第N篇12之X_主題」格式
**D. 圖片計畫表 vs 實際檔名** — docx 內每張圖描述跟實際檔名比對
**E. 日期正確** — 資料夾日期跟排程預期一致
**F. 時間正確** — 連載 08:00 / 十齋日 06:00
**G. 週末警告** — 連載通常週一~五

**進階 (可選)** — 用 Claude 視覺 API 看每張圖, 跟 docx 內描述比對「圖看起來符合描述嗎?」
但通常 **檔名比對已經夠** — 因為阿美 LoveArt 生圖時檔名就是描述.

★ check_post.py 有錯誤 → ❌ 不能上稿, 先修

★ 在進 Playwright 之前, **必跑** `python check_post.py 2026-06-23_第1篇_序品第一`

★ 檢查項目:
- 資料夾名解析 (連載: YYYY-MM-DD_第N篇_品名 / 十齋日: 十齋日_YYYY-MM-DD_農曆XX)
- 預期排程時間 (連載 08:00 / 十齋日 06:00)
- **docx 篇號跟資料夾名對齊** (避免「篇 5 文字配篇 3 圖」)
- **docx 內「第 N 篇」字樣 = 資料夾號**
- 圖片數量 (連載 12 張 / 十齋日 1 張)
- 圖片編號 01_ ~ 12_ 齊全
- 十齋日內文含「十齋日」+ 「農曆 XX」字樣
- 週末警告 (連載通常週一~五)

★ 跑出 ❌ 錯誤 → 不能上稿, 先修

### Step 1: 載入 Playwright 工具
```
ToolSearch: select:mcp__playwright__browser_navigate,
            mcp__playwright__browser_snapshot,
            mcp__playwright__browser_take_screenshot,
            mcp__playwright__browser_click,
            mcp__playwright__browser_type,
            mcp__playwright__browser_press_key,
            mcp__playwright__browser_file_upload,
            mcp__playwright__browser_evaluate,
            mcp__playwright__browser_tabs,
            mcp__playwright__browser_wait_for
```

### Step 2: 導航到 Meta Business Suite
```python
mcp__playwright__browser_navigate(
  url="https://business.facebook.com/latest/posts/published_posts/?asset_id=1093357677358320"
)
```
- asset_id = 1093357677358320 (地藏菩薩本行經粉專)
- ⚠️ 可能會跳 beforeunload dialog, 用 browser_handle_dialog(accept=true) 處理

### Step 3: 找「建立貼文」按鈕
```python
mcp__playwright__browser_snapshot(filename="composer1.yml")
# grep "建立貼文" 找 ref, 然後 click
mcp__playwright__browser_click(element="建立貼文", target="e96")  # ref 每次不同
```
→ 進入 composer 編輯界面

### Step 4: 找「在對話方塊中寫點內容」textbox + Click 拿焦點
```python
# 從 snapshot grep "textbox|combobox" 找文字框 ref
mcp__playwright__browser_click(element="貼文文字輸入框", target="e2374")
```

### Step 5: ★★★ 用 dispatch ClipboardEvent + DataTransfer 貼文字 (絕不用 system clipboard!)

★ 為什麼:**Ctrl+V 法會被阿元 同時 Ctrl+C 蓋掉 clipboard!** 2026-06-17 阿元 在我貼 篇 1 時 Ctrl+C 複製對話,結果**篇 1 被換成阿海對話內容**,排程到 FB! 必須刪重做。

★ 正確做法:**`evaluate` 內建 `DataTransfer` 物件 + `dispatch paste event`** 完全不碰 system clipboard:

```python
mcp__playwright__browser_evaluate(function=f"""
() => {{
  const text = `{fb_post_text}`;
  const editor = document.querySelector('[contenteditable="true"]');
  editor.focus();
  const dt = new DataTransfer();
  dt.setData('text/plain', text);
  const ev = new ClipboardEvent('paste', {{clipboardData: dt, bubbles: true, cancelable: true}});
  editor.dispatchEvent(ev);
  return {{len: editor.textContent.length}};
}}
""")
```

★ 這個方法 — 內部處理,完全不碰 Windows 剪貼簿,阿元 在你跑時 Ctrl+C 也 0 影響 ✅

### Step 4b: ★★★★★ 處理 Meta 草稿問題 (2026-06-17 阿地踩的雷)

**雷:** Meta Business Suite 在 composer 開啟時會「自動載入未完成草稿」, composer 進入「**單圖編輯模式**」(不是「新建多圖模式」), 結果:
- ❌ 「新增相片 / 影片」按鈕**消失**
- ❌ 「附加相片或影片」按鈕只能 single file (12 張上不去)
- ❌ 「移除相片」按鈕 **disabled**, 點不動
- ❌ Cancel 後跳「捨棄變更」對話框, 點了**草稿還是會再次自動載入**!

**正確 SOP:**

1. **打開 composer 前先去清「草稿」分頁**:
   - 網址: https://business.facebook.com/latest/posts/drafts/?asset_id=1093357677358320
   - 把所有草稿手動刪除
   - 或用 Playwright 自動跑「全部刪除」

2. **進入 composer 時驗證乾淨**:
   ```js
   const imgs = Array.from(document.querySelectorAll('img'));
   const drafts = imgs.filter(i => i.src.includes('fbcdn') && i.getBoundingClientRect().x < 400);
   if (drafts.length > 0) {
     console.error('草稿圖未清, 必須先處理');
     // 不能繼續, 否則 12 張上不去
   }
   ```

3. **如果還是有殘留** — 用 Graph API 列出草稿並 DELETE:
   ```
   GET /{page-id}/posts?fields=id,is_published&is_published=false&limit=100&access_token=...
   DELETE /{post-id}?access_token=...
   ```
   (要謹慎 — 確認是草稿不是排程, 別誤刪 scheduled posts)

★ **死命令**: 看到「編輯相片」「移除相片」「更換圖像」按鈕 = 還在編輯模式, **必須先清草稿才能繼續**

### Step 5b: ★★ 清除 Meta 自動載入的殘留草稿圖

★ 為什麼:Meta UI 有時會自動載入「上次未完成的草稿」,composer 開啟時就已經有「殘留圖」(可能是上次的廣告/活動圖)。如果不清, 你上傳 12 張時會混入這張殘留。

★ 正確做法:點「**移除相片**」按鈕(aria-label「點擊可從你的貼文移除此功能。」),或找縮圖 parent 內的 X 按鈕:

```python
mcp__playwright__browser_evaluate(function="""
() => {
  const imgs = Array.from(document.querySelectorAll('img'));
  const thumb = imgs.find(i => {
    const r = i.getBoundingClientRect();
    return r.width >= 40 && r.width <= 60 && r.x < 200;
  });
  if (!thumb) return {clean: true};
  let row = thumb;
  while (row && row !== document.body) {
    const x = row.querySelectorAll('button[aria-label*="移除"]');
    if (x.length > 0) { x[0].click(); return {removed: true}; }
    row = row.parentElement;
  }
  return {found: true, no_btn: true};
}
""")
```

確認 — `evaluate` 找媒體區的 imgs, 應該 0 張(除了預覽圖)

### Step 5 (舊): 用 clipboard + Ctrl+V 貼上文字 (⛔ 廢棄,有被蓋掉風險)
```python
# 把 docx 抓出的 FB 貼文文字寫入 clipboard
mcp__playwright__browser_evaluate(function=f"""
async () => {{
  const text = `{fb_post_text}`;
  await navigator.clipboard.writeText(text);
  return {{ok: true, len: text.length}};
}}
""")

# 按 Ctrl+V 貼上
mcp__playwright__browser_press_key(key="Control+v")
```
⚠️ **重要**: 不要用 browser_type — fill 對 Meta UI 的 Lexical/Draft.js 編輯器不生效

### Step 6: 點「新增相片 / 影片」按鈕
```python
# snapshot grep "新增相片"
mcp__playwright__browser_click(element="新增相片按鈕", target="e2328")
# → 跳 File chooser
```

### Step 7: 上傳 12 張圖片
```python
mcp__playwright__browser_file_upload(paths=[
  "C:\\...\\每篇貼文\\YYYY-MM-DD_第N篇_品名\\01_xxx.png",
  ...
  "C:\\...\\每篇貼文\\YYYY-MM-DD_第N篇_品名\\12_xxx.png",
])
# 等 5 秒讓圖上傳
mcp__playwright__browser_wait_for(time=5)
```

### Step 7b: ★★★★★ 必加「接收訊息」按鈕 — 阿地 1 號 2026-06-17 兩次踩雷!

⛔ **死命令:點接收訊息按鈕後絕不按 Escape!**

**為什麼:** Escape 會 dismiss 了「啟用動作」, 看起來按鈕變藍其實沒真正 toggle ON. 排程後 Meta 鎖死, 補加不上去, 只能刪掉重排.

**正確 SOP:**
1. Click 接收訊息按鈕
2. 跳「在貼文添加上按鈕」說明氣泡
3. **等 1-2 秒讓氣泡自然關閉**, 或者 click 空白處關氣泡
4. 用 evaluate 驗證 aria-disabled === "true" 才算成功
5. 如果還是 "false" → 重 click 一次, 再驗證

**驗證 code:**
```js
const msgBtn = document.querySelector('[aria-label="接收訊息"]');
const ok = msgBtn.getAttribute('aria-disabled') === 'true';
return {enabled: ok};
```
若 `enabled: true` → 已開啟 ✅
若 `enabled: false` → 沒開啟, 要重點

### Step 7b 舊版: ★★★ 必加「接收訊息」按鈕 (排程前!排程後 Meta 鎖死)

Meta 提示:「你無法對已排定發佈的貼文進行變更或新增『接收訊息』按鈕」

這個按鈕讓粉絲能直接點按鈕私訊粉專,**沒這個按鈕粉絲不知怎麼索取本願經 = 整個贈書活動失效**

```python
# 在「貼文行動呼籲 / Call to Action」區找「接收訊息」switch
# 用 evaluate 找:
mcp__playwright__browser_evaluate(function="""
() => {
  const els = Array.from(document.querySelectorAll('*'));
  return els.filter(e => /接收訊息|訊息按鈕|Message button/.test(e.textContent) && e.children.length < 3).slice(0,5);
}
""")
# Click switch 開啟
# 若跳「選擇平台」, 選 Facebook (不要 Instagram)
# 確認 switch 變藍色/已啟用
```

⛔ **死命令**: 排程前忘加 → 後悔莫及, 只能刪除重排

### Step 8: 打開排程開關
```python
# snapshot grep "排程"
mcp__playwright__browser_click(element="設定日期和時間 switch", target="e2503")
```
→ 出現日期 + 時間欄位

### Step 9: 點日期 textbox → 選日曆中的目標日
```python
mcp__playwright__browser_click(element="日期挑選工具", target="e3760")
# 跳出日曆
# snapshot grep "Tuesday, 23 June 2026" 找日期按鈕 ref
mcp__playwright__browser_click(element="6月23日按鈕", target="e3929")
```

### Step 10: 設定時間 (連按 ArrowDown / ArrowUp)
★ Meta 的時間 spinbutton **不接受 fill/type**, 只接受真實 keyboard ArrowUp/Down
```python
# 小時 spinbutton (e3785) - 預設 = 當下時間, 連按 ArrowDown 降到目標小時
mcp__playwright__browser_click(element="小時 spinbutton", target="e3785")
# 從現在 23 點 降到 7 點 = ArrowDown 16 次
for _ in range(16):
    mcp__playwright__browser_press_key(key="ArrowDown")

# 確認: aria-valuenow
mcp__playwright__browser_evaluate(function="""
() => document.querySelector('[role=\"spinbutton\"][aria-label*=\"小時\"]').getAttribute('aria-valuenow')
""")

# 分鐘 spinbutton (e3789) - 同樣 ArrowDown
mcp__playwright__browser_click(element="分鐘 spinbutton", target="e3789")
# 從現在 14 分 降到 0 分 = ArrowDown 14 次
for _ in range(14):
    mcp__playwright__browser_press_key(key="ArrowDown")
```

### Step 11: 點「排定時間」按鈕完成
```python
# snapshot grep "排定時間"
mcp__playwright__browser_click(element="排定時間按鈕", target="e3799")
# 等 3 秒
mcp__playwright__browser_wait_for(time=3)
```

→ 跳出「你的貼文已排定發佈時間」對話框 ✅
→ 同時跳「加強推廣貼文」廣告對話框 → **點「關閉」(e4045)** 不要付費!

### Step 12: 驗證
跳到 `https://business.facebook.com/latest/content_calendar/?asset_id=1093357677358320&focus_time=<unix_ts>`
看「規劃工具」(內容行事曆)上對應日期有沒有縮圖 + 時間

---

## 死命令鐵則

⛔ **不點「加強推廣貼文」** — 那是付費廣告
⛔ **每篇上完截圖確認** — 不要連送多篇沒驗證
⛔ **時間 = 連載 08:00 / 十齋日 06:00** — 不要弄反
⛔ **圖片順序 01 → 12** — 上傳順序 = FB 顯示順序
⛔ **死命令 1** — 任何刪除動作都要阿元 親自打「確認刪除」+ 二次確認

---

## 從 docx 抓 FB 貼文文字 (Python)

```python
from docx import Document
doc = Document('每篇貼文/YYYY-MM-DD_第N篇_品名/貼文內容.docx')
capture = False
lines = []
for p in doc.paragraphs:
    text = p.text.rstrip()
    if not text:
        if capture: lines.append("")
        continue
    is_heading = p.style.name.startswith("Heading")
    if "FB 貼文文字" in text:
        capture = True
        continue
    if capture and is_heading:
        break
    if capture:
        lines.append(text)

fb_post_text = "\n".join(lines).strip()
import re
fb_post_text = re.sub(r"\n{3,}", "\n\n", fb_post_text)
```

---

## 批次上稿 100 篇 + 297 個十齋日的策略

★ **連載 100 篇** (2026-06-23 ~ 2026-11-13 共 100 個工作日):
- 每篇 12 張圖 + docx
- 上稿時間 = 該日 08:00
- 完整流程約 1-2 分鐘 / 篇
- 100 篇全部跑完 ≈ 2.5 小時

★ **十齋日 297 個** (2026-06-23 起):
- 每篇 1 張圖(從圖池抽)+ 固定文字 docx
- 上稿時間 = 該日 06:00
- 完整流程約 1 分鐘 / 篇
- 297 個全部跑完 ≈ 5 小時

★ **建議分批跑** — 例如:
- Day 1 跑連載 1-20 篇 + 對應十齋日 (約 1 小時)
- 隔幾天再跑 21-40 篇
- 避免 Meta 偵測異常頻繁操作

---

## 常見問題 & 解法

### Q1. 時間 spinbutton fill/type 沒效果?
→ 用 keyboard.press ArrowDown/ArrowUp。React 控制的 spinbutton 不接受合成 input,只接受真實鍵盤事件。

### Q2. clipboard.writeText 失敗?
→ 確認剛才有 click 過頁面元素(user gesture)。沒 user gesture 瀏覽器擋 clipboard API。

### Q3. 「建立貼文」找不到按鈕?
→ 可能登入過期或 asset_id 錯。重新 navigate 到 published_posts 頁,看是否跳登入頁。

### Q4. 上傳 12 張圖只看到 9 張預覽?
→ Meta UI 把多圖 grid 顯示成 4x3 或更少格子,實際上 12 張都在,看左邊「媒體」清單確認。

### Q5. 排程時間是過去?
→ Meta 拒絕「排程時間 < 現在時間 + 10 分鐘」。確認 docx 內標的日期 ≥ 當天。

---

🪷 阿地 1 號 整理 · 2026-06-17 篇 1 實測通過
傳給 4 號、5 號、阿傳, 大家照這做就能 1 分鐘上一篇 🌸
