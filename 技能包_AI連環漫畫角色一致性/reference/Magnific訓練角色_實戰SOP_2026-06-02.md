# 🪷🐕 Magnific 訓練永久角色 — 實戰 SOP（地藏 + WhatDog 狗狗通用）

> 阿地 2026-06-02 實戰整理。地藏 @dizang 訓練成功當天寫成。
> **通用技能** — 任何固定角色都照這個做（地藏菩薩、WhatDog 狗狗、任何主角）。
> 解決專案最大難題：「角色跨格變臉/變裝」。訓練一次，叫名字就出來，>90% 一致。

---

## 0. 一頁速查（趕時間看這個）

1. **平台**：Magnific（magnific.com，現屬 Freepik）。引擎含 **Google Nano Banana 2 / Nano Banana Pro**（跟 LoveArt 同家族，畫風能力一樣，吉卜力沒問題）。
2. **方案**：要建角色需 **Premium（€16.80/月含稅 ≈ NT$580，月繳可隨時取消）**。基本版 Essential €8 不能建角色（建角色畫面會跳「Go Premium」）。每月 20,000 點。
3. **建角色花費**：`Create your character` 只要 **10 點**。生圖每張 ~75 點。
4. **核心流程**：準備 9-10 張角色定裝照 → Image Generator → Character → New character → Create Character 表單 → Upload（開內建選圖視窗）→ 從 Uploads 選圖 → 填 @Name + Gender → Create your character → 得到 **@角色名**。
5. **用法**：prompt 打 `@角色名 ...場景... Studio Ghibli watercolor...` → 角色自動鎖、畫風保持。
6. **備援法（不訓練也能用）**：上傳 8 張角色參考圖到 references + prompt 加「強制鎖特徵」死命令，約 85-90%。訓練版更穩（>90%）且不用每張貼參考。

---

## 1. 為什麼要訓練（原理）

AI 生圖不「認識」你的角色，每次重新想像 → 換場景就變臉/掉特徵（地藏會掉寶冠變光頭、狗狗會變花色/變品種）。
**訓練 = 讓 AI 把角色長相「背起來」**，存成一個可呼叫的 `@角色`。之後叫名字就畫得出同一個，>90% 一致，不用每張貼參考圖。

---

## 2. 一次性準備：角色定裝照（訓練素材）

訓練前要先有 **9-10 張角色定裝照**（Magnific 上限 10 張，4 張起跳，越多越準）。原則：
- **乾淨、單一角色、簡單背景**（別有對話框/旁白/頁碼/其他角色）。
- **多角度多姿勢**：正面臉特寫、3/4 側臉、正側面、全身正面、全身側面、半身、最關鍵特徵的特寫。
- **最強辨識特徵要清楚**：地藏=五佛冠+九環錫杖；狗狗=毛色花紋+項圈+耳朵形狀。特徵特寫至少 1-2 張。
- 怎麼生這些定裝照：先用「備援法」(第5章) 或既有官方參考圖，生一批 → 肉眼篩選造型一致的 9-10 張。

⚠️ 定裝照本身要造型正確（地藏一律寶冠九環，不可光頭版混進去；狗狗一律同花色）。錯的素材會教壞角色。

---

## 3. ★訓練步驟（實戰，照做）

1. 進 **Image Generator**（magnific.com/app/ai-image-generator）。
2. 左側 REFERENCES 區點 **Character** → 開角色面板。
3. 點右上 **「+ New character」** → 開 **Create Character** 表單（有 @Name / Gender / 「Create your character」10點）。
4. 點表單左邊 **「Upload」或「select a file」**。
   - ★關鍵：開的是 **Magnific 內建選圖視窗**（有 History / Uploads 分頁），**不是電腦原生選檔視窗** → 所以**自動化可以操作**（不用真人點）。
   - ⚠️ 別想用程式直接塞表單那個隱藏 file input（React 不收，files=0 進不去）。一定走內建 picker 選圖。
5. 視窗切到 **「Uploads」** 分頁（你之前上傳的定裝照都在這；若還沒上傳，用右側「Upload media」先上傳本機圖，那個 input 可用 file_upload，每批 <10MB）。
6. 點選 **9-10 張**（會反藍+右側計數 N/10）→ 按右下 **「Add」** → 圖進表單（顯示「N images, Nice!」）。
7. 填 **@Name**（英文小寫無空格，如 `dizang` / `whatdog`）。
8. **Gender**：菩薩/中性角色選 **Neutral**；狗狗看設定（公狗 Male / 母狗 Female / 不分 Neutral）。
9. 按 **「Create your character」（10點）** → 角色建好，**@角色名** 出現在 references。

---

## 4. ★用訓練好的角色生圖

- prompt 開頭打 `@角色名`（會變角色標籤），接場景描述 + 畫風：
  ```
  @dizang the Ksitigarbha bodhisattva, wearing his golden five-Buddha crown,
  [新場景/動作]. Studio Ghibli watercolor animation style, Castle in the Sky aesthetic. Square 1:1.
  ```
- 模型選 **Google Nano Banana 2**（75點/張，featured）。
- 角色臉/特徵自動鎖，**不用再貼 8 張參考、不用一堆死命令**。
- 多角色同框：各自的角色用各自 @（如 `@dizang` + 描述佛陀）；沒訓練的配角(佛陀)在 prompt 描述清楚（佛陀=圓臉肉髻**無冠**光頭，避免被主角特徵帶歪 → 明寫「NO crown」）。

---

## 5. 備援法（不付費/不訓練也能用，約85-90%）

沒訓練時：上傳 **8 張角色參考圖**到 references（References 區點 Character → Upload media → 選圖 → Add，變 @img1~@img8）+ prompt 加**強制鎖特徵死命令**：
```
@img1...@img8 are all the SAME character, [角色名].
CRITICAL: he/it ALWAYS has [最強特徵，如 golden five-Buddha crown on head / same brown-and-white fur and red collar] — NEVER [常見漂移，如 bald / different fur color].
Keep [臉/冠/法器/毛色/項圈] exactly identical to the references.
[新場景]. Studio Ghibli watercolor... Square 1:1.
```
★ 實證教訓：地藏第一次換「走路」場景就掉寶冠變光頭 → 加上 8 參考 + 「ALWAYS crown, NEVER bald」死命令後就鎖住。狗狗同理（毛色/項圈最會飄，要明寫鎖）。

---

## 6. 對 WhatDog 狗狗的應用（給阿狗）

1. 先生 9-10 張**狗狗定裝照**（同一隻狗：正面/側面/全身/坐/站/臉特寫，乾淨背景）。狗狗有明顯花紋+項圈，比地藏更好鎖。
2. 上傳 → Create Character → @Name=`whatdog` → Gender 看設定 → Create your character。
3. 之後狗狗漫畫/動畫每格打 `@whatdog 在[場景]做[動作], Studio Ghibli...` → 同一隻狗。
4. 圖內中文字幕一律之後在 Canva 補（AI 中文易亂碼）。

---

## 7. 注意事項（踩過的雷）★重要

- **★★ 上傳「全新」角色圖到 Uploads 只能靠真人點「Upload media」(原生選檔視窗)**。AI 的 `file_upload` 只設本地、不會真的傳到 Magnific 伺服器，重整後 Uploads 沒有 → 訓練選不到。流程：真人點 Upload media 上傳 → 之後「從既有 Uploads 選圖+命名+訓練」AI 能全自動。
- **★★ 檔名不可撞名**：不同角色的訓練圖若同名(都叫 `訓練_01.png`)，Magnific 按檔名去重會搞混 → 上傳前改成不撞名(`buddha_01.png` / `whatdog_01.png`)。
- Gender：菩薩/中性選 Neutral；佛陀/男選 Male；狗狗看設定。
- Magnific 網頁很重，截圖常逾時 → 自動化多用 JS/DOM、隱藏 input 用 setAttribute 標記+find 取 ref。
- 檔名含中文要核對正確（曾把「特寫」打成「特嫛」、「側面3-4」加成「側面×3-4」導致上傳失敗）→ 建議改純英數檔名最保險。
- 付款（訂閱）一定要真人做，AI 不可代填卡號。原生 OS 視窗(選檔/付款)AI 都操作不了，網頁內 AI 全包。
- 月繳記得測完不續就去 Subscription>Plan 取消。

---

🌸 南無地藏王菩薩 / WhatDog 旺！— 阿地 2026-06-02
參見記憶 [[reference_magnific_character_breakthrough_2026_06_02]]
