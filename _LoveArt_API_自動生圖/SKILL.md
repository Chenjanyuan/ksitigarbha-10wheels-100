---
name: loveart-auto-generate
description: >-
  用 LoveArt 免費 API（OpenClaw skill + Nano Banana Pro）在「本機」半夜自動批量生連環漫畫圖的系統，
  附網頁介面。讀每篇的「生成命令_LoveArt.md」→ 自動帶角色卡參考圖 → 生圖存進該篇「圖片」夾。
  當使用者要：自動生地藏經/連環漫畫圖、LoveArt API 批量生圖、把 LoveArt @角色卡 自動化、
  半夜免費生圖、生圖網頁介面、agent_skill.py 生圖、AK/SK 生圖時使用。
  ⛔ 一律在阿元自己電腦跑（Cowork 雲端沙盒連不到 LoveArt，實測 403 被擋）。
metadata:
  type: project-skill
  author: 阿研 / alumi
  created: 2026-06-10
---

# 🪷 LoveArt 免費 API 自動生圖（本機 + 網頁介面）

## 這是什麼
把「LoveArt 手動 @角色卡 生圖」自動化的本機系統。阿地白天寫好每篇的
`生成命令_LoveArt.md`，程式半夜自動讀它 → 用 **LoveArt 免費無限模式 + Nano Banana Pro**
→ 自動把 `@佛陀/@地藏/@飽和度參考…` 對應到「人物角色卡」PNG 當參考圖 → 生圖存進該篇「圖片」夾。

## 核心事實（踩過的坑，別重犯）
- **LoveArt 的「龙虾」API key = OpenClaw skill**（不是傳統 REST）。官方檔：lovartai/lovart-skill（GitHub, MIT, 零依賴 Python）。
- 認證：**access_key (ak_) + secret_key (sk_)**，環境變數 `LOVART_ACCESS_KEY`/`LOVART_SECRET_KEY`。
- API host = `https://lgw.lovart.ai`。模型字串 = `generate_image_nano_banana_pro`。
- **免費**：`set-mode --unlimited`（排隊，半夜人少快）；fast 才花 credit。
- ⛔ **Cowork 雲端沙盒連不到 LoveArt（也連不到 Gemini），必須在阿元自己電腦跑。**
- 角色卡 @ 提及 → API 改成「upload 卡片 PNG 拿網址 → --attachments 帶上」。
- Gemini API 太貴已棄用；走 LoveArt 免費。

## 怎麼用（給阿元）
1. 雙擊 `▶ 啟動生圖網頁.bat` → 自動開網頁。
2. 網頁上：貼 AK/SK（存本機 `金鑰.txt`，已 gitignore）→ 按「下載生圖程式」一次。
3. 選一篇 → 「▶ 開始生圖」→ 看進度＋看圖。
4. 「🌙 每晚自動」→ 半夜 01:30 自動跑（電腦要開著）。

## 檔案
- `生圖介面.py` — 網頁介面（本機 http server，stdlib，零依賴）。
- `生圖_LoveArt_API.py` — 純命令列版引擎（排程也可用）。
- `agent_skill.py` — LoveArt 官方生圖程式（網頁按鈕自動下載）。
- `說明_使用方法.md` — 白話步驟。

## 紅線
- 🔐 secret_key 只存本機、絕不貼進對話、絕不上 GitHub。
- 🖼 生成的圖**存本機**，不要 push GitHub（量大會爆 repo；只上傳文字+角色卡）。
- 🧪 第一次先試一篇再開排程；繁體字偶爾糊/錯，失敗的隔天補生（只補缺的）。
- 角色卡對應在程式最上面 `CARD_MAP`，加菩薩改一行。
