# Playwright Meta Business Suite 文件上傳問題詳細報告
**日期:** 2026-06-18  
**目標:** 用 Playwright 自動上傳12張圖片到 Meta Business Suite Composer  
**結論:** ❌ 失敗 — Playwright MCP 的 file_upload 工具無法正常工作

---

## 🔍 問題詳述

### 問題 1️⃣: Playwright file_upload 返回 undefined
**現象:**
```javascript
await fileChooser.setFiles(["C:\\Users\\chenj\\...\\圖片\\01_佉羅帝耶山遠景.png"])
// 返回: setFiles(undefined)
```

**嘗試過的路徑格式:**
- ✗ Windows 反斜杠: `C:\\Users\\...\\圖片\\01.png`
- ✗ 正斜杠: `C:/Users/.../圖片/01.png`
- ✗ UNC 路徑: `//Users/...`
- ✗ Temp 目錄: `C:\\Users\\...\\AppData\\Local\\Temp\\.playwright-mcp\\pian1\\test_01.png`

**結果:** 所有路徑都返回 `setFiles(undefined)`，文件未被上傳。

---

### 問題 2️⃣: 無法在 File Chooser Modal 中執行 JavaScript
**錯誤信息:**
```
Error: Tool "browser_evaluate" does not handle the modal state.
Modal state: [File chooser]: can be handled by browser_file_upload
```

**原因:** 當 file chooser modal 打開時，Playwright 阻止所有 `browser_evaluate()` 調用，無法用 JavaScript 直接操作 file input。

**影響:** 無法：
- 檢查 file input 的屬性
- 用 JavaScript 直接設置文件
- 模擬 drag/drop 事件

---

### 問題 3️⃣: waitForEvent('filechooser') 無法捕獲已打開的 Modal
**代碼:**
```javascript
const fileChooserPromise = page.waitForEvent('filechooser');
const fileChooser = await fileChooserPromise;
```

**錯誤:**
```
TimeoutError: page.waitForEvent: Timeout 30000ms exceeded while waiting for event "filechooser"
```

**原因:** file chooser 已經打開，但 `waitForEvent()` 等待的是新事件。已存在的 modal 無法被捕獲。

---

### 問題 4️⃣: 沙箱環境路徑限制
**Python 複製失敗:**
```python
src = r"C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\2026-06-23_第1篇_序品第一\圖片"
# 錯誤: [Errno 2] No such file or directory
```

**原因:** 沙箱環境無法直接存取用戶文件系統，即使路徑有效。

**但:** 沙箱可以在 temp 目錄創建文件（✓ 成功創建 test_01.png），但仍無法上傳。

---

## 📋 完整的嘗試順序

### 第 1 次嘗試：直接用 browser_file_upload
```
✓ File chooser modal 打開
✗ setFiles() 返回 undefined
✗ 頁面未顯示任何圖片
```

### 第 2 次嘗試：改變路徑格式（正斜杠）
```
✓ File chooser modal 打開
✗ setFiles() 仍返回 undefined
```

### 第 3 次嘗試：在 Temp 目錄創建測試文件
```
✓ Python 成功創建 C:\Users\...\Temp\.playwright-mcp\pian1\test_01.png
✗ 但 file_upload 仍返回 undefined
```

### 第 4 次嘗試：用 browser_evaluate 檢查 file input
```
✗ 被 modal 阻止，無法執行 JavaScript
```

### 第 5 次嘗試：用 browser_run_code_unsafe 繞過限制
```
✗ waitForEvent('filechooser') 無法捕獲已打開的 modal
✗ Timeout 30000ms
```

### 第 6 次嘗試：按 Escape 關閉 Modal
```
✓ Modal 關閉
✗ 沒有文件被上傳
✗ Composer 狀態仍顯示「新增相片/影片」
```

---

## 🔧 根本原因分析

### Playwright MCP 的 file_upload 工具的問題：

1. **無法存取用戶文件系統**
   - Playwright MCP 運行在沙箱中
   - 即使提供完整路徑，也無法讀取 Windows 文件系統
   - `setFiles(undefined)` 表示路徑被解析為無效

2. **沒有備選方案**
   - browser_evaluate 在 modal 時被阻止
   - browser_run_code_unsafe 無法捕獲已打開的 modal
   - 無法用 JavaScript 直接操作 file input

3. **Meta Business Suite 的限制**
   - File chooser 是原生 Windows 對話框（不是 HTML）
   - Playwright 無法與原生對話框交互（除了通過 file input）
   - 無法模擬拖放到 composer 區域

---

## 💡 可能的解決方案

### 方案 A: 使用 Meta Graph API（推薦）
```
✓ 完全自動化，不涉及 UI
✓ 支持批量上傳圖片
✓ 可排程執行（每日早上 7 點）
✓ 可寫成技能包

缺點: 需要 API token（已有），不用 UI 自動化
```

### 方案 B: 用 Claude-in-Chrome 代替 Playwright
```
✓ 真實瀏覽器交互
✓ 可能能處理文件上傳
✓ 更好的 DOM 存取

缺點: 可能仍面臨相同的 file input 限制
```

### 方案 C: 混合方案
```
1. 用 Python 複製圖片到用戶可見目錄
2. 讓用戶手動拖放到 Meta Business Suite
3. 用 Playwright 排程貼文發佈時間

缺點: 不是完全自動化
```

### 方案 D: 用 Playwright 的 filechooser 事件（需驗證）
```
可能需要在點擊按鈕時同時監聽事件：
await Promise.all([
  page.waitForEvent('filechooser', chooser => chooser.setFiles(...)),
  page.click('新增相片/影片')
])

但這可能也無法工作，因為 setFiles() 接收的路徑無效
```

---

## 📊 測試結果摘要

| 方法 | 支援 | 結果 | 原因 |
|------|------|------|------|
| browser_file_upload + 用戶文件系統 | ✗ | undefined | 沙箱無法存取用戶文件 |
| browser_file_upload + temp 文件 | ✗ | undefined | Playwright 無法處理路徑 |
| browser_evaluate (modal 中) | ✗ | 被阻止 | 安全限制 |
| browser_run_code_unsafe | ✗ | Timeout | 無法捕獲已打開 modal |
| 拖放模擬 | ✗ | 無法執行 | browser_evaluate 被阻止 |

---

## 🎯 結論

**Playwright MCP 的 file_upload 工具在以下場景下無法工作：**
1. ❌ 上傳用戶文件系統中的實際文件
2. ❌ 上傳沙箱中創建的文件（路徑無法被識別）
3. ❌ 通過 JavaScript 操作 file input（modal 時被阻止）

**最可行的全自動方案：**
👉 **使用 Meta Graph API（API_V20.0）**
- 上傳圖片至 Facebook
- 發佈貼文
- 排程時間（6:00 或 8:00）
- 完全繞過 UI 自動化的所有限制

**Playwright 仍可用於：**
- 排程貼文發佈時間（如果已在 composer）
- 檢查貼文發佈狀態
- 其他不涉及文件上傳的自動化

---

**建議:** 放棄 Playwright 的文件上傳，改用 Graph API 實現完全自動化。
