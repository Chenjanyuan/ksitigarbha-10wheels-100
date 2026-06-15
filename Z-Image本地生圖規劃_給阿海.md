# 🖥️ Z-Image 本地生圖 — 完整規劃（給阿海）

> 阿研 for 阿元 / 2026-06-15（台北）
> 目標：把地藏漫畫生圖從「LoveArt（免費 API 已塞死、快速要花額度）」搬到**阿元自己電腦本地跑**——免費、無限、不排隊、會寫繁體字。

---

## 0. 一句話總結
阿元電腦（RTX 2060 6GB）裝 **ComfyUI（官方）+ Z-Image Turbo（阿里通義開源）**，用 **GGUF Q4_K_M 量化版**省顯存，角色一致性用 **IP-Adapter 餵現有角色卡 / 或訓 LoRA**。生圖從此本地免費，繁體對白也畫得出來。

---

## 1. 為什麼換（痛點對應）
| LoveArt 現況 | Z-Image 本地 |
|---|---|
| 免費 API 佇列卡死（任務 running 60 分鐘不出圖，實測 0 產出） | 本地直接算，**不排隊** |
| 快速模式要花額度，額度有限 | **完全免費、無限** |
| 雲端、要顧金鑰 | 本地、資料不外流、無金鑰風險 |
| 繁體字偶爾糊 | Z-Image **中文字渲染同級最強** |

---

## 2. 硬體適配（阿元的機器）
- GPU：**RTX 2060 6GB**（2019，剛好踩 Z-Image 低標）→ **務必用 GGUF Q4_K_M**（5~6GB 可跑）。⚠️ 不要用 bf16（16G 等級）、fp8 也偏緊（建議 8G 以上才順）
- RAM 40GB ✅　CPU i7-9700 ✅　剩 ~1.5TB 空間 ✅（模型約 6~10GB）
- 預期：一張約數十秒（Turbo 幾步出圖），比高階卡慢但**免費無限**，遠勝已死的 LoveArt 免費

---

## 3. 安裝步驟（★只走官方乾淨來源，不要 YouTuber 懶人包）

### 3-1 裝 ComfyUI（官方）
- 官方 GitHub：`comfyanonymous/ComfyUI`（Windows 可下官方 portable 版，解壓即用）
- 顯卡驅動更新到新版 + 對應 CUDA（portable 版自帶 torch，通常免裝）

### 3-2 下載模型檔（官方 HuggingFace，放對資料夾）
| 檔案 | 放這裡 | 備註 |
|---|---|---|
| `z-image-turbo` **GGUF Q4_K_M**（社群量化，HuggingFace 上找 city96 / 官方推薦的 GGUF repo） | `ComfyUI/models/unet/`（GGUF 放這） | **6GB 關鍵：用這版** |
| 文字編碼器 `qwen_3_4b.safetensors` | `ComfyUI/models/text_encoders/` | Z-Image 用 Qwen3-4B |
| VAE `ae.safetensors`（即 Flux VAE） | `ComfyUI/models/vae/` | 有的話沿用 |

> 純 safetensors / GGUF 格式＝不夾執行碼，安全。**只從官方/知名 repo 下**。

### 3-3 跑 GGUF 需要一個外掛
- **ComfyUI-GGUF**（作者 city96，GitHub 星很多、公認安全）→ 用 ComfyUI Manager 裝，提供 "Unet Loader (GGUF)" 節點。
- 其餘節點用 ComfyUI **原生 Z-Image 範例工作流**（官方 docs.comfy.org 有 Z-Image Turbo workflow，拖進去即用）。

### 3-4 載入官方工作流
- 從 ComfyUI 官方 Z-Image 範例頁拖入 workflow → 把模型節點換成 GGUF Loader → 指到上面下載的檔。

---

## 4. 6GB 省顯存設定（重要）
- 啟動加參數：`--lowvram`（或 `--medvram`，看順不順）
- 解析度**先生 1024×1024 或 1024×1536**，**不要一次衝 2048**（會爆顯存）→ 再用 **upscale 節點放大到 2K**（你們漫畫要 1:1 2K）
- Turbo 步數少（約 4~8 步，cfg 1）→ 快又省
- VAE 用 **tiled VAE decode**（省顯存出圖不爆）

---

## 5. 角色一致性（接上你們現有「角色卡」流程）
你們現在是「@角色卡 當參考圖」鎖臉。Z-Image 有兩條路：

**A. IP-Adapter（零訓練，最快上手）** ← 建議先用
- 餵「地藏/佛陀/觀音…角色卡 PNG」當參考圖 → 生成時鎖住長相/風格。
- 概念跟你們現在 @角色卡 一模一樣，直接沿用 `人物角色卡/` 那些卡。

**B. LoRA 訓練（最穩，你之前想要的「Custom Character」本地版）**
- 每尊菩薩用 8~20 張卡訓一個小 LoRA（工具 ai-toolkit，支援 Z-Image）。
- 訓好後生圖只要叫 LoRA，地藏 100 篇跨篇**不漂移**，比 IP-Adapter 更穩。
- 多尊同框：用 **FreeFuse** 解決多 LoRA 臉融合問題。
- ⚠️ 訓 LoRA 也吃顯卡；6GB 可訓小 rank，慢一點，或用雲端訓好再下載本地用。

**建議節奏**：先 A（IP-Adapter）跑通 → 覺得不夠穩再上 B（先訓「地藏」一尊，因為他出場最多）。

---

## 6. 風格 + 繁體對白
- 風格：prompt 下「吉卜力水彩、高飽和、漫畫分鏡」+（可選）找吉卜力風 LoRA 疊。沿用你們現有「飽和度排第一＋極高飽和」的命令邏輯。
- 繁體對白/旁白框/頁碼：Z-Image 中文字強，可直接在 prompt 要；但**保險做法**＝圖生好後用程式（PIL）疊上**對白框＋頁碼**（100% 不錯字），這個我能寫進現有 `生圖介面.py`。

---

## 7. 跟現有流程銜接（不浪費已做的）
- 你們已有 `每篇貼文/第N篇/生成命令_LoveArt.md`（含 @卡、prompt、頁碼、飽和度）。
- ComfyUI 有 **API 模式**（`--listen`，HTTP 送 workflow json）→ 我可以把現在的 `生圖介面.py` 從「呼叫 LoveArt」改成「呼叫本地 ComfyUI API」，**沿用同一套命令檔、同一個網頁介面、同一套檔名規則（第N篇_張NN_標題.png）**。等於只換引擎，工作流不變。

---

## 8. 安全紅線（照我們 SOP）
- ✅ ComfyUI 官方 GitHub、Z-Image 官方 HuggingFace、GGUF 用 city96、外掛只裝 ComfyUI-GGUF（知名）
- ⛔ 不抓百度/夸克「一鍵懶人包」、不裝來路不明 custom node、不下 `.ckpt`（用 safetensors/GGUF）
- 🧪 先在測試資料夾跑單張驗證，OK 再接批量；不碰 production、不動地藏經 repo 本體

---

## 9. 分階段驗收（LEVEL）
1. **L2**：ComfyUI 裝好、Z-Image GGUF 出第一張隨便的圖（證明跑得動）
2. **L3**：用 1024 生圖→放大 2K，速度/顯存可接受
3. **L4**：IP-Adapter 餵地藏角色卡，生出「地藏正確、寶冠九環」一張
4. **L4+**：套一篇完整 12 格（含繁體對白、頁碼、飽和度）對比 LoveArt 版
5. **L5**：阿元拍板 → 把 `生圖介面.py` 引擎切到本地 ComfyUI，批量生 19-100 篇

---

## 10. 給阿海的下一步 checklist
- [ ] 裝官方 ComfyUI（portable）+ 更新顯卡驅動
- [ ] 裝 ComfyUI-GGUF 外掛
- [ ] 下載：Z-Image Turbo **GGUF Q4_K_M** + qwen_3_4b 文字編碼器 + Flux VAE（放對資料夾）
- [ ] 載入官方 Z-Image workflow，`--lowvram`，1024 出一張測（L2）
- [ ] 加 upscale 到 2K + tiled VAE（L3）
- [ ] IP-Adapter 餵 `人物角色卡/地藏王菩薩…png` 測一致性（L4）
- [ ] 回報阿研：速度/顯存/一致性如何 → 我來改 `生圖介面.py` 接 ComfyUI API

---

### 來源
- ComfyUI 官方 Z-Image 範例：https://docs.comfy.org/tutorials/image/z-image/z-image-turbo
- Z-Image 官方：https://www.z-image-ai.io/
- 6GB GGUF 設定指南：https://zimage.run/blog/z-image-turbo-quantized-low-vram-guide
- Z-Image + LoRA 一致性（ComfyUI）：https://www.nextdiffusion.ai/tutorials/z-image-turbo-with-lora-in-comfyui-for-consistent-image-generations
