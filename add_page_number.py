"""
add_page_number.py
強制在每張圖右下角加上 N/12 編號
解決阿美 圖生 AI 不畫編號的問題

用法:
  python add_page_number.py <資料夾>
  例: python add_page_number.py 地藏十輪經連載\20260527

會根據檔名「-照片-NN-」自動判斷 N/12
"""
import os, sys, re
from PIL import Image, ImageDraw, ImageFont

# Windows 系統繁體中文字型
FONT_PATHS = [
    "C:/Windows/Fonts/msjh.ttc",      # 微軟正黑體
    "C:/Windows/Fonts/msyhbd.ttc",    # 微軟雅黑粗體 (備用)
    "C:/Windows/Fonts/mingliu.ttc",   # 細明體
]

def get_font(size):
    for fp in FONT_PATHS:
        if os.path.exists(fp):
            try:
                return ImageFont.truetype(fp, size)
            except:
                continue
    return ImageFont.load_default()

def add_page_number(img_path, page_num, total=12):
    """在右下角加 N/12 白圓黑字編號"""
    img = Image.open(img_path).convert("RGBA")
    W, H = img.size

    # 編號參數 (適合 2K 圖, 直徑約 9% 圖寬)
    circle_diameter = int(W * 0.085)   # 約 170px (在 2K 圖上)
    circle_r = circle_diameter // 2
    margin = int(W * 0.025)            # 距邊 ~50px

    # 圓心位置 (右下角)
    cx = W - margin - circle_r
    cy = H - margin - circle_r

    # 透明 layer 畫圓 + 字
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # 白圓 (半透明白底 95% 不透明)
    draw.ellipse(
        [cx - circle_r, cy - circle_r, cx + circle_r, cy + circle_r],
        fill=(255, 255, 255, 240),
        outline=(0, 0, 0, 200),
        width=3
    )

    # 黑字 N/12
    text = f"{page_num}/{total}"
    font_size = int(circle_diameter * 0.42)
    font = get_font(font_size)

    # 文字 bbox 計算 (置中)
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    tx = cx - tw // 2 - bbox[0]
    ty = cy - th // 2 - bbox[1]

    draw.text((tx, ty), text, fill=(0, 0, 0, 255), font=font)

    # 合成
    result = Image.alpha_composite(img, overlay).convert("RGB")

    # 覆蓋存檔 (原檔備份在 _原檔/)
    backup_dir = os.path.join(os.path.dirname(img_path), "_原檔備份")
    os.makedirs(backup_dir, exist_ok=True)
    backup_path = os.path.join(backup_dir, os.path.basename(img_path))
    if not os.path.exists(backup_path):
        Image.open(img_path).save(backup_path)

    result.save(img_path, quality=95)
    print(f"✓ {os.path.basename(img_path)} → 加上 {text}")

def main(folder):
    if not os.path.isdir(folder):
        print(f"❌ 資料夾不存在: {folder}")
        return

    files = sorted([f for f in os.listdir(folder) if f.lower().endswith(".png")])
    if not files:
        print(f"❌ 資料夾沒有 PNG: {folder}")
        return

    print(f"處理資料夾: {folder}")
    print(f"找到 {len(files)} 張 PNG")
    print()

    pat = re.compile(r"-照片-(\d{2})-")
    ok = 0
    for f in files:
        m = pat.search(f)
        if not m:
            print(f"⚠ 跳過 (檔名無 -照片-NN-): {f}")
            continue
        page = int(m.group(1))
        if page < 1 or page > 12:
            print(f"⚠ 跳過 (編號 {page} 超出 1-12): {f}")
            continue
        try:
            add_page_number(os.path.join(folder, f), page, 12)
            ok += 1
        except Exception as e:
            print(f"✗ {f} 失敗: {e}")

    print()
    print(f"✅ 完成 {ok}/{len(files)} 張")
    print(f"原檔備份在: {folder}\\_原檔備份")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1])
