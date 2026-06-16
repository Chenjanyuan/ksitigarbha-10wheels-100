"""
🪷 Nano Banana Pro 直接 API 生圖腳本 (繞過 LoveArt 阿美)
2026-05-29 阿地 5 號 寫

用途: 從 v10 prompt 檔案讀取 → call Google Gemini API → 存 PNG

設定:
1. pip install google-genai pillow
2. 設環境變數: $env:GEMINI_API_KEY = "你的_API_KEY"  (PowerShell)
3. python nano_banana_generate.py
"""

import os
import sys
import time
from pathlib import Path
from google import genai
from google.genai import types

# ========== 設定區 ==========
API_KEY = os.environ.get("GEMINI_API_KEY") or "請填你的 API KEY"
MODEL = "gemini-2.5-flash-image-preview"  # Nano Banana (free tier 友善)
# 或用 Gemini 3 Pro Image: "gemini-3-pro-image-preview" (付費快)

PROJECT_DIR = Path(r"C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經")
PROMPTS_DIR = PROJECT_DIR / "阿地交接" / "v8_全100篇命令"  # 已有 940 個 .txt
OUTPUT_DIR = PROJECT_DIR / "_API生圖_2026-05-29"

# 風格鎖定 reference URL (篇 1-2 yI8azwJB 那張)
STYLE_PROMPT = """整體風格: 吉卜力動畫質感, 細膩水粉, 溫暖飽和, 自然細節豐富, 光影柔和.
古印度場景 (棕皮膚, 橙袈裟, 紗麗, 纏腰布).
1:1 正方形 2K 無邊框. 全繁體中文文字 (旁白方框+對話氣泡+右下頁碼).
絕非寫實/3D/工筆畫."""

# ========== 主程式 ==========

def call_gemini(prompt, retries=3):
    """call Gemini API 生 1 張圖"""
    client = genai.Client(api_key=API_KEY)
    full_prompt = STYLE_PROMPT + "\n\n" + prompt

    for attempt in range(retries):
        try:
            response = client.models.generate_content(
                model=MODEL,
                contents=full_prompt,
                config=types.GenerateContentConfig(
                    response_modalities=['Image']
                )
            )
            for part in response.candidates[0].content.parts:
                if part.inline_data:
                    return part.inline_data.data  # bytes
        except Exception as e:
            print(f"  ⚠️ 第 {attempt+1} 次失敗: {e}")
            time.sleep(5)
    return None


def generate_one(chapter, image_num):
    """生 1 張: 篇 X 第 N 張"""
    txt_path = PROMPTS_DIR / f"篇{chapter:02d}" / f"{chapter}-{image_num:02d}.txt"
    if not txt_path.exists():
        print(f"  ❌ 找不到 {txt_path.name}")
        return False

    prompt = txt_path.read_text(encoding='utf-8')
    out_path = OUTPUT_DIR / f"篇{chapter:02d}" / f"{chapter}-{image_num:02d}.png"
    out_path.parent.mkdir(parents=True, exist_ok=True)

    if out_path.exists():
        print(f"  ⏭️  已存在: {out_path.name}")
        return True

    print(f"  🎨 生成中: {out_path.name}...")
    img_bytes = call_gemini(prompt)
    if img_bytes:
        out_path.write_bytes(img_bytes)
        print(f"  ✅ 完成: {out_path.name}")
        return True
    print(f"  ❌ 失敗: {out_path.name}")
    return False


def main():
    if API_KEY == "請填你的 API KEY":
        print("⛔ 請先設定 GEMINI_API_KEY 環境變數!")
        print("   PowerShell: $env:GEMINI_API_KEY = \"AIza...\"")
        sys.exit(1)

    print(f"🪷 從篇 7 起跑到篇 30 (288 張)")
    print(f"   模型: {MODEL}")
    print(f"   存到: {OUTPUT_DIR}")
    print()

    success = 0
    fail = 0

    for chapter in range(7, 31):  # 篇 7 ~ 30
        print(f"\n📖 篇 {chapter}")
        for img_num in range(1, 13):  # 1 ~ 12
            if generate_one(chapter, img_num):
                success += 1
            else:
                fail += 1
            time.sleep(2)  # 避免 rate limit

    print(f"\n🎉 完成! 成功 {success} / 失敗 {fail}")


if __name__ == "__main__":
    main()
