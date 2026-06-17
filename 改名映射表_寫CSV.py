#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
寫「連載 100 篇 改名映射表」CSV
================================
舊名 → 新名 (2026-06-23 起算 100 個工作日, 扣週末 + 國定假日)

★ 此腳本只寫 CSV, 不動真檔案
★ 阿元 看過 CSV OK → 跑「執行改名.py」才真改

作者: 阿地 · 2026-06-17
"""

import sys, csv, re
from pathlib import Path
from datetime import datetime, timedelta

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"

def pause():
    try: input("按 Enter 結束...")
    except EOFError: pass

# 115 + 116 年放假日 (從 6/23 起算需要的)
HOLIDAYS = {
    # 115 年下半年
    "2026-09-25",  # 中秋
    "2026-09-28",  # 教師節
    "2026-10-09",  # 國慶補假
    "2026-10-26",  # 光復節補假
    "2026-12-25",  # 行憲紀念日
}

# 算 100 個工作日 (6/23 起, 週一~五, 扣 HOLIDAYS)
start = datetime(2026, 6, 23)
work_days = []
d = start
while len(work_days) < 100:
    if d.weekday() < 5 and d.strftime("%Y-%m-%d") not in HOLIDAYS:
        work_days.append(d.strftime("%Y-%m-%d"))
    d += timedelta(days=1)

# 掃現有資料夾, 按「第 N 篇」排序
folders = []
for f in POST_DIR.iterdir():
    if f.is_dir():
        m = re.match(r"(\d{4}-\d{2}-\d{2})_第(\d+)篇_(.+)", f.name)
        if m:
            old_date, num, kind = m.groups()
            folders.append({
                'old_name': f.name,
                'old_date': old_date,
                'num': int(num),
                'kind': kind,
            })

folders.sort(key=lambda x: x['num'])

if len(folders) != 100:
    print(f"⚠️ 警告: 找到 {len(folders)} 個連載資料夾, 不是 100 個")

# 配對 — 第 N 篇 → 第 N 個工作日
rows = []
weekday_zh = ['週一', '週二', '週三', '週四', '週五', '週六', '週日']
for i, fld in enumerate(folders):
    new_date = work_days[i] if i < len(work_days) else f"OVERFLOW_{i}"
    dt = datetime.strptime(new_date, "%Y-%m-%d") if "OVERFLOW" not in new_date else None
    wkd = weekday_zh[dt.weekday()] if dt else "?"
    new_name = f"{new_date}_第{fld['num']}篇_{fld['kind']}"
    rows.append({
        '篇號': fld['num'],
        '舊名': fld['old_name'],
        '舊日期': fld['old_date'],
        '新名': new_name,
        '新日期': new_date,
        '星期': wkd,
        '是否變動': '✅變動' if fld['old_name'] != new_name else '⚪不變',
    })

# 寫 CSV
out_csv = ROOT / "改名映射表_連載100篇.csv"
with open(out_csv, 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['篇號', '舊名', '舊日期', '新名', '新日期', '星期', '是否變動'])
    w.writeheader()
    w.writerows(rows)

print(f"✅ 對照表已寫: {out_csv}")
print()
print("前 10 篇預覽:")
print(f"{'篇':>4}  {'舊日期':>10}  {'→ 新日期':>10}  {'星期':<4}  品名")
print("─" * 70)
for r in rows[:10]:
    print(f"{r['篇號']:>4}  {r['舊日期']:>10}  → {r['新日期']:>10}  {r['星期']:<4}  {r['新名'].split('_')[-1]}")
print("...")
print(f"\n第 100 篇: {rows[99]['新日期']} ({rows[99]['星期']})")
print()
print(f"📂 完整 CSV: {out_csv}")
print()
print("★ 阿元 / 阿傳 看 CSV 對嗎?")
print("   - OK → 跑「執行改名.py」真的改名")
print("   - 不對 → 跟阿地 說哪裡改, 阿地 改 CSV 邏輯重生")
pause()
