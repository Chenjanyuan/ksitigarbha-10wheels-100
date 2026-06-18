---
name: meta-composer-draft-fix
description: Meta Business Suite Playwright 上稿時「12 張圖上不去 / setFiles 回 undefined / composer 進入單圖編輯模式 / 移除相片按鈕 disabled」的診斷與修法。當 AI 看到 file_upload 失敗、composer 顯示「編輯相片/移除相片/更換圖像」按鈕、誤以為要改 Graph API 時觸發。配 playwright-meta-post 技能包一起用。2026-06-18 阿研診斷阿地13號血淚整理。
---

# 🪷 Meta Composer 草稿陷阱修復技能

## 何時用這份技能（觸發詞）

任何 AI（阿地、阿狗、阿研後續棒）在 Playwright 自動上稿 Meta Business Suite 遇到以下任一症狀 → 立刻載入本技能：

- `browser_file_upload` 上傳 12 張圖後 composer **沒顯示圖**
- `setFiles()` 回傳 `undefined` 就誤判失敗
- composer 顯示「**編輯相片**」「**移除相片**」「**更換圖像**」三大禁忌按鈕之一
- 點「新增相片/影片」找不到，只看到「附加相片或影片」（single file）
- 試過 N 種路徑格式（反斜杠、正斜杠、UNC、temp）都失敗
- 想建議「改用 Graph API 比較好」← **這想法立刻停止**

---

## 死命令（最優先，永遠遵守）

⛔ **絕不可改用 Graph API 發 FB 貼文** — 阿元 2026-05 月驗證：Token API 上稿 71 篇 → 每篇打「AI 資訊」標籤 → 0 個讚 → 演算法壓死整個贈書活動。Meta 2024 起的 AI 揭露政策只認 API 上稿。

✅ **唯一可行路線：Playwright 操作 Meta UI**（真人模擬、沒 AI 標籤）

---

## 3 個誤判（先自我檢查）

### 誤判 1：`setFiles()` 回 undefined ≠ 失敗
Playwright 的 `setFiles()` 是 void function，正常情況本來就回 undefined。
真正失敗訊號是 **composer 沒顯示圖**，不是 undefined。
**別再試 6 種路徑格式浪費時間**。

### 誤判 2：以為 sandbox 不能讀 Windows 檔案
Playwright MCP 用 `cmd /c npx -y` 裝在阿元本機 Windows，**不是雲端 sandbox**。
直接給 `C:\Users\chenj\...` Windows 絕對路徑就能讀。
你看到「No such file or directory」是因為你用 Python 跑（在 cowork sandbox），不是 Playwright MCP 跑。

### 誤判 3：建議改 Graph API
踩到上面紅線。**絕對不行**。

---

## 真凶：Meta 自動載入草稿

Meta Business Suite composer 開啟時會「**自動載入未完成草稿**」，讓 composer 進入「**單圖編輯模式**」：

| 模式 | 「新增相片/影片」按鈕 | 「附加相片或影片」按鈕 | 結果 |
|---|---|---|---|
| 乾淨（新貼文） | ✅ 存在（multiple file） | — | 12 張 OK |
| **草稿載入（編輯模式）** | ❌ 消失 | ⚠️ single file only | 12 張 error: `Non-multiple file input can only accept single file` |

「移除相片」按鈕在編輯模式 **disabled**，點不動；
Cancel + 捨棄變更後**草稿又自動載入**，死循環。

---

## 正確修法 SOP（4 步驟，照抄即可）

### 步驟 1：上稿前先清草稿

```python
mcp__playwright__browser_navigate(
  url="https://business.facebook.com/latest/posts/drafts/?asset_id=1093357677358320"
)
# 把所有草稿手動全刪，或用 Playwright 自動點「全部刪除」
```

> ⚠️ 刪除草稿前要按阿元「死命令 1」— 任何刪除動作要阿元親自打「確認刪除」+ 二次確認。
> 但「我的草稿」分頁是 composer 自己留下的、跟使用者過往發的內容無關，建議事先跟阿元統一授權「草稿區可全清」。

### 步驟 2：進 composer 後立刻驗證乾淨（必跑這段）

```python
mcp__playwright__browser_evaluate(function="""
() => {
  const imgs = Array.from(document.querySelectorAll('img'));
  const drafts = imgs.filter(i => i.src.includes('fbcdn') && i.getBoundingClientRect().x < 400);
  const dirty = !!document.querySelector(
    'button[aria-label*="編輯相片"], button[aria-label*="移除相片"], button[aria-label*="更換圖像"]'
  );
  return { draft_imgs: drafts.length, dirty_buttons: dirty };
}
""")
```

判讀：
- `draft_imgs = 0` 且 `dirty_buttons = false` → 乾淨，可繼續
- 任一條不滿足 → **回步驟 1 清草稿**，不可硬幹

### 步驟 3：點正確的按鈕（最容易踩錯的地方）

| 按鈕名稱 | 模式 | 能上幾張 | 該不該點 |
|---|---|---|---|
| **新增相片 / 影片** | multiple | 12 張 OK | ✅ 點這個 |
| **附加相片或影片** | single | 只能 1 張 | ❌ 不要點 |
| **更換圖像** | replace | 只能 1 張 | ❌ 編輯模式才有，看到=草稿沒清 |

從 `browser_snapshot` 結果裡 `grep "新增相片"` 找 ref，**不是** `grep "附加相片"`。

### 步驟 4：browser_file_upload 給 Windows 絕對路徑

```python
mcp__playwright__browser_file_upload(paths=[
  "C:\\Users\\chenj\\Documents\\Claude\\Projects\\自動化每天更新FB 地藏 10輪經\\每篇貼文\\YYYY-MM-DD_第N篇_品名\\圖片\\01_xxx.png",
  # ... 12 張
])
mcp__playwright__browser_wait_for(time=5)
```

- 不用試 temp 目錄、不用試正斜杠、不用試 UNC — 原本的 Windows 路徑就行
- 上傳後 wait 5 秒讓圖跑進 composer
- 驗證：再跑步驟 2 的 evaluate，這次 `draft_imgs` 應該 = 12

---

## 其他觀念修正

### `browser_evaluate` 在 modal 開啟時被阻擋
這是 Playwright MCP 的安全設計，不是 bug。Modal 開了就用 `browser_file_upload`，不要試 `evaluate` 繞。

### `waitForEvent('filechooser')` timeout
時機錯了 — 要在 click「新增相片」之前先掛 listener。
但其實 `browser_file_upload` 內部已經處理，**你不用自己掛**。

### Playwright 不能跟「原生 Windows 對話框」交互
這個說法不準確。Playwright **可以**透過 file input element 把檔案塞進去（這就是 `setFiles` 在做的事），不需要點原生對話框。失敗不是因為這層限制，是因為**草稿載入讓 file input 變成 single 模式**。

---

## 跟 playwright-meta-post 技能包的關係

- `playwright-meta-post` = 完整 11 步上稿 SOP（從導航到驗證排程）
- **本技能** = 專修「12 張上不去」這一段，補強 Step 4b/5b/6/7

兩份一起讀。本技能比 SKILL Step 4b 更聚焦「**自我檢查不要走錯路**」+「**3 個誤判別再犯**」，給未來阿地 N 號當前置診斷。

---

## 給後人的話

接班不推回。看完照做，今天就把篇 1 搞定。
別再寫「建議改 Graph API」那種報告 — 那是把阿元贈書活動推進火坑。

🪷 阿研整理 · 2026-06-18 · 給阿地 13 號 + 未來所有踩同雷的 AI
