from __future__ import annotations

import argparse
import os
import re
from datetime import datetime, timedelta
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parent
POST_ROOT = ROOT / "每篇貼文"
OUT_DIR_NAME = "FB上傳用_有序JPG"


def natural_key(path: Path) -> tuple[int, str]:
    name = path.name
    patterns = [
        r"^(\d{1,2})[_\-\s]",
        r"張\s*0?(\d{1,2})",
        r"12之\s*0?(\d{1,2})",
        r"12[-_ ]?0?(\d{1,2})",
        r"之\s*0?(\d{1,2})",
    ]
    for pattern in patterns:
        match = re.search(pattern, name, re.IGNORECASE)
        if match:
            return int(match.group(1)), name
    nums = re.findall(r"\d+", name)
    if nums:
        return int(nums[-1]), name
    return 999, name


def find_post_folder(post: str, serial: int | None = None) -> Path:
    if serial is not None:
        pattern = re.compile(rf"_第{serial}篇_")
        matches = [p for p in POST_ROOT.iterdir() if p.is_dir() and pattern.search(p.name)]
        if len(matches) == 1:
            return matches[0].resolve()
        if not matches:
            raise FileNotFoundError(f"Post folder not found for serial: {serial}")
        raise RuntimeError("Multiple folders matched:\n" + "\n".join(str(p) for p in matches))

    path = Path(post)
    if path.exists():
        return path.resolve()

    direct = POST_ROOT / post
    if direct.exists():
        return direct.resolve()

    matches = [p for p in POST_ROOT.iterdir() if p.is_dir() and post in p.name]
    if len(matches) == 1:
        return matches[0].resolve()
    if not matches:
        raise FileNotFoundError(f"Post folder not found: {post}")
    raise RuntimeError("Multiple folders matched:\n" + "\n".join(str(p) for p in matches))


def image_source_dir(post_dir: Path) -> Path:
    sub = post_dir / "圖片"
    if sub.exists():
        return sub
    return post_dir


def make_exif(timestamp: datetime) -> Image.Exif:
    stamp = timestamp.strftime("%Y:%m:%d %H:%M:%S")
    exif = Image.Exif()
    exif[306] = stamp  # DateTime
    exif[36867] = stamp  # DateTimeOriginal
    exif[36868] = stamp  # DateTimeDigitized
    return exif


def convert_one(src: Path, dst: Path, timestamp: datetime, quality: int) -> None:
    with Image.open(src) as image:
        rgb = image.convert("RGB")
        rgb.save(
            dst,
            "JPEG",
            quality=quality,
            optimize=True,
            progressive=False,
            exif=make_exif(timestamp),
        )
    ts = timestamp.timestamp()
    os.utime(dst, (ts, ts))


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create ordered JPEG copies for Meta/Facebook multi-photo uploads."
    )
    parser.add_argument("post", nargs="?", default="", help="Post folder name, partial name, or absolute path")
    parser.add_argument("--serial", type=int, help="Serial number, for example 5 for 第5篇")
    parser.add_argument("--start", default="2026-06-23 08:00:00", help="Base EXIF time")
    parser.add_argument("--quality", type=int, default=88, help="JPEG quality, default 88")
    args = parser.parse_args()

    post_dir = find_post_folder(args.post, args.serial)
    src_dir = image_source_dir(post_dir)
    out_dir = post_dir / OUT_DIR_NAME
    out_dir.mkdir(exist_ok=True)

    images = [
        p
        for p in src_dir.iterdir()
        if p.is_file() and p.suffix.lower() in {".png", ".jpg", ".jpeg", ".webp"}
    ]
    images = sorted(images, key=natural_key)

    if len(images) != 12:
        raise RuntimeError(f"Expected 12 images, found {len(images)} in {src_dir}")

    base = datetime.strptime(args.start, "%Y-%m-%d %H:%M:%S")
    total_bytes = 0
    print(f"Post: {post_dir}")
    print(f"Source: {src_dir}")
    print(f"Output: {out_dir}")
    print("")

    # ★ v2 改純淨檔名 pianN_NN.jpg(2026-06-20 阿元拍板,避免「12之X」字串混淆 Meta 排序)
    serial_for_name = args.serial if args.serial else 0
    for idx, src in enumerate(images, start=1):
        if serial_for_name:
            dst = out_dir / f"pian{serial_for_name}_{idx:02d}.jpg"
        else:
            # 沒給 serial 就 fallback 原邏輯
            dst = out_dir / f"{idx:02d}_{src.stem}.jpg"
        timestamp = base + timedelta(seconds=idx)
        convert_one(src, dst, timestamp, args.quality)
        size = dst.stat().st_size
        total_bytes += size
        print(f"{idx:02d}. {src.name} -> {dst.name} | {size / 1024 / 1024:.2f} MB | {timestamp}")

    print("")
    print(f"Done. Total JPG size: {total_bytes / 1024 / 1024:.2f} MB")
    print("Upload these 12 JPG files from 01 to 12, not the original PNG files.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
