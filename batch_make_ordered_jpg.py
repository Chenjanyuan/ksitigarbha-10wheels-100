"""批次跑 make_fb_ordered_jpg.py 給篇 6-100
從資料夾名解析「上稿日期」當 EXIF start
跳過已有 FB上傳用_有序JPG 子資料夾的篇(避免重做)
"""
from __future__ import annotations
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).parent
POST_ROOT = ROOT / "每篇貼文"
MAKER = ROOT / "make_fb_ordered_jpg.py"
OUT_DIR_NAME = "FB上傳用_有序JPG"

# 從資料夾名解析 yyyy-mm-dd 和 篇號
PATTERN = re.compile(r"^(\d{4})-(\d{2})-(\d{2})_第(\d+)篇_")


def main():
    start_serial = int(sys.argv[1]) if len(sys.argv) > 1 else 6
    end_serial = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    force = '--force' in sys.argv

    total = 0
    skipped = 0
    done = 0
    failed = []

    for sub in sorted(POST_ROOT.iterdir()):
        if not sub.is_dir():
            continue
        m = PATTERN.match(sub.name)
        if not m:
            continue
        year, month, day, serial_s = m.groups()
        serial = int(serial_s)
        if serial < start_serial or serial > end_serial:
            continue

        total += 1
        out_dir = sub / OUT_DIR_NAME

        if out_dir.exists() and not force:
            # 已有就跳過(除非 --force)
            existing_jpgs = list(out_dir.glob("*.jpg"))
            if len(existing_jpgs) >= 12:
                print(f"[SKIP] 篇 {serial} ({sub.name}) 已有 {len(existing_jpgs)} 張 JPG")
                skipped += 1
                continue

        # 確認圖片數
        img_dir = sub / "圖片"
        if not img_dir.exists():
            img_dir = sub
        imgs = [p for p in img_dir.iterdir() if p.is_file() and p.suffix.lower() in {'.png', '.jpg', '.jpeg', '.webp'}]
        if len(imgs) != 12:
            print(f"[NO IMG] 篇 {serial} ({sub.name}) 只有 {len(imgs)} 張圖,跳過")
            failed.append((serial, f"只有 {len(imgs)} 張圖"))
            continue

        start_time = f"{year}-{month}-{day} 08:00:00"
        print(f"[RUN ] 篇 {serial} start={start_time}")
        try:
            result = subprocess.run(
                ['python3', str(MAKER), '--serial', str(serial), '--start', start_time],
                cwd=str(ROOT),
                capture_output=True,
                text=True,
                encoding='utf-8',
            )
            if result.returncode == 0:
                done += 1
                print(f"       ✅")
            else:
                failed.append((serial, result.stderr[-200:]))
                print(f"       ❌ {result.stderr[:100]}")
        except Exception as e:
            failed.append((serial, str(e)))
            print(f"       ❌ {e}")

    print()
    print("=" * 60)
    print(f"範圍: 篇 {start_serial} - {end_serial}")
    print(f"總計: {total} 篇  已跳過: {skipped}  完成: {done}  失敗: {len(failed)}")
    if failed:
        print("\n失敗清單:")
        for serial, reason in failed[:10]:
            print(f"  篇 {serial}: {reason[:80]}")


if __name__ == '__main__':
    main()
