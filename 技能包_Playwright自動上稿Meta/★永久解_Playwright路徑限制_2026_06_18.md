# 🪷 永久解:Playwright MCP 路徑限制(2026-06-18 官方確認)

> 阿地 2 號查 Playwright 官方文檔找到
> https://playwright.dev/mcp/configuration/options

═══════════════════════════════════════════════════════════════════════════

## 問題

Playwright MCP 預設 `file_upload` 只允許 `C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\` 內的檔案,專案路徑被擋:

```
File access denied: ... is outside allowed roots.
Allowed roots: C:\Users\chenj\AppData\Local\Temp\.playwright-mcp
```

## 官方解法 — CLI flag

```
--allow-unrestricted-file-access
```

或 config.json:
```json
{
  "allowUnrestrictedFileAccess": true
}
```

═══════════════════════════════════════════════════════════════════════════

## 阿元怎麼改(★ 一勞永逸版)

### Step 1:找 Claude Desktop config

按 Win+R 貼:
```
%APPDATA%\Claude
```

裡面有 `claude_desktop_config.json`,用記事本打開。

### Step 2:找 `playwright` 那段

原本長這樣:
```json
"playwright": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@playwright/mcp@latest"]
}
```

### Step 3:加 flag

改成:
```json
"playwright": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@playwright/mcp@latest", "--allow-unrestricted-file-access"]
}
```

★ 注意逗號跟引號要對。

### Step 4:存檔 → 完全關閉 Cowork → 重新開啟

═══════════════════════════════════════════════════════════════════════════

## 改完後效果

**before:**
- 100 篇上稿都要先 PowerShell cp 圖到 Temp
- 雙擊 .bat → 雙擊 → 雙擊...

**after:**
- 阿地 file_upload 直接給 `C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文\<篇>\圖片\*.png` 路徑
- 0 cp 步驟,直接上 100 篇

═══════════════════════════════════════════════════════════════════════════

## 其他可用 flags(官方完整清單)

| Flag | 用途 |
|------|------|
| `--allow-unrestricted-file-access` | ★ 解除檔案存取限制 |
| `--headless` | 無視窗執行 |
| `--browser <browser>` | 選 chrome/firefox/webkit/msedge |
| `--viewport-size <size>` | 自訂視窗大小 |
| `--timeout-action <ms>` | action timeout(預設 5000) |
| `--timeout-navigation <ms>` | navigation timeout(預設 60000) |
| `--allowed-origins <origins>` | 允許訪問的網站 |
| `--isolated` | In-memory profile |
| `--save-session` | 存 session |

完整列表:https://playwright.dev/mcp/configuration/options

═══════════════════════════════════════════════════════════════════════════

🪷 阿地 2 號 · 2026-06-18 凌晨
官方查到 flag,改完一勞永逸 🌸
