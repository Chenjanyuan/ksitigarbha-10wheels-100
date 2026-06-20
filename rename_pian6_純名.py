"""把篇 6 的 FB上傳用_有序JPG 內 12 張 JPG rename 成純淨格式 pian6_01.jpg ~ pian6_12.jpg
丟掉「第N篇12之X」中間混淆數字,只保留 0-padded 編號 + EXIF 遞增
"""
from PIL import Image
from datetime import datetime, timedelta
from pathlib import Path
import os
import re

FOLDER = Path(__file__).parent / "每篇貼文" / "2026-06-30_第6篇_序品第一" / "FB上傳用_有序JPG"
BASE_TIME = datetime.strptime("2026-06-30 08:00:00", "%Y-%m-%d %H:%M:%S")

print(f"處理資料夾: {FOLDER}")

# 找原始 01_xxx.jpg ~ 12_xxx.jpg(含「第6篇12之X」)
old_files = sorted([f for f in FOLDER.iterdir() if f.suffix.lower() == '.jpg' and re.match(r'^\d{2}_', f.name) and 'pian6' not in f.name])
print(f"找到 {len(old_files)} 個原檔")

if len(old_files) != 12:
    print(f"⚠ 不是 12 張!請檢查")

for i, old in enumerate(old_files, start=1):
    new_name = f"pian6_{i:02d}.jpg"
    new = FOLDER / new_name
    # 開啟 → convert RGB → 重寫 EXIF → 存新檔
    img = Image.open(old)
    rgb = img.convert("RGB")
    exif = Image.Exif()
    ts = (BASE_TIME + timedelta(seconds=i)).strftime("%Y:%m:%d %H:%M:%S")
    exif[306] = ts
    exif[36867] = ts
    exif[36868] = ts
    rgb.save(new, "JPEG", quality=88, optimize=True, progressive=False, exif=exif)
    # 同步 mtime
    t = (BASE_TIME + timedelta(seconds=i)).timestamp()
    os.utime(new, (t, t))
    # 刪原檔
    os.remove(old)
    print(f"  ✓ {old.name[:50]} → {new_name}  EXIF: {ts}")

print()
print("=== 驗證 ===")
for f in sorted(FOLDER.iterdir()):
    if f.suffix.lower() == '.jpg':
        img = Image.open(f)
        ex = img.getexif()
        print(f"  {f.name}  EXIF: {ex.get(36867, 'NONE')}")

print()
print(f"完成! 12 張 JPG 已 rename 成 pian6_01.jpg ~ pian6_12.jpg")
print(f"Playwright 用這些 12 個檔名上傳 → 順序乾淨無混淆")
