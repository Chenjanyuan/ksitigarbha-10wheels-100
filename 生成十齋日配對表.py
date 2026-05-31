#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成十齋日 docx <-> 圖片配對表 (5/24 以後)
============================================
只「掃描 + 寫 CSV」, 不動 FB
作者: 阿地 · 2026-05-22
"""

import sys
import csv
from pathlib import Path
from collections import defaultdict
import re

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"
ZHAI_POOL = ROOT / "十齋日"

POOL_MAP = {
    "初一":   "01_初一",
    "初八":   "02_初八",
    "十四":   "03_十四",
    "十五":   "04_十五",
    "十八":   "05_十八",
    "二十三": "06_二十三",
    "二十四": "07_二十四",
    "二十八": "08_二十八",
    "二十九": "09_二十九",
    "三十":   "10_三十",
}

folders = sorted([f for f in POST_DIR.iterdir() if f.is_dir() and f.name.startswith("十齋日_")])

by_lunar = defaultdict(list)
for f in folders:
    m = re.match(r"十齋日_(\d{4}-\d{2}-\d{2})_農曆(.+)", f.name)
    if m and m.group(1) >= "2026-05-24":
        by_lunar[m.group(2)].append((m.group(1), f.name))

def pool_imgs(lunar):
    p = ZHAI_POOL / POOL_MAP[lunar]
    files = []
    for ext in ('*.png', '*.jpg', '*.jpeg', '*.PNG', '*.JPG', '*.JPEG'):
        files.extend(sorted(p.glob(ext)))
    return files

rows = []
for lunar, items in by_lunar.items():
    items.sort()
    pool = pool_imgs(lunar)
    if not pool:
        print(f"⚠️ 農曆{lunar} 圖池是空的!")
        continue
    for i, (date_str, fname) in enumerate(items):
        img = pool[i % len(pool)]
        is_loop = "是 (重複)" if i >= len(pool) else ""
        rel = img.relative_to(ROOT)
        rel_str = str(rel).replace("/", "\\")
        rows.append({
            "日期": date_str,
            "農曆": lunar,
            "資料夾": fname,
            "配對圖片": img.name,
            "圖片相對路徑": rel_str,
            "排程時間": f"{date_str} 06:00",
            "是否重複用圖": is_loop,
        })

rows.sort(key=lambda r: r["日期"])

out_csv = ROOT / "十齋日配對表.csv"
with open(out_csv, 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=["日期", "農曆", "資料夾", "配對圖片", "圖片相對路徑", "排程時間", "是否重複用圖"])
    w.writeheader()
    w.writerows(rows)

print(f"✅ 配對完成: {len(rows)} 篇")
print(f"📄 CSV: {out_csv}")
print()
print("前 10 筆預覽:")
for r in rows[:10]:
    flag = "⚠️重複" if r["是否重複用圖"] else "    "
    print(f"  {r['日期']} {r['農曆']:<5}{flag}  {r['圖片相對路徑']}")
print()

dup_count = sum(1 for r in rows if r["是否重複用圖"])
if dup_count:
    print(f"⚠️ 重複用圖共 {dup_count} 篇 (主要是 2027 年的二十九)")
print()
print("✅ 完全沒動 FB")
print()
try:
    input("按 Enter 結束...")
except EOFError:
    pass
