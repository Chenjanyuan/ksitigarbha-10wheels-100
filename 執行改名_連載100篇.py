#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
執行改名 — 讀「改名映射表_連載100篇.csv」真的改 100 個資料夾名稱
======================================================================

★ 阿元 看過 CSV OK 才跑這個
★ 死命令: 動真檔案前要打「確認改名」4 字才動

作者: 阿地 · 2026-06-17
"""

import sys, csv
from pathlib import Path

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"

def pause():
    try: input("按 Enter 結束...")
    except EOFError: pass

# 載入 CSV
csv_file = ROOT / "改名映射表_連載100篇.csv"
if not csv_file.exists():
    print(f"❌ 找不到 CSV: {csv_file}")
    print(f"   先跑「改名映射表_寫CSV.py」生成對照表")
    pause()
    sys.exit(1)

rows = list(csv.DictReader(open(csv_file, encoding='utf-8-sig')))

# 篩出真要改的 (變動的)
to_rename = [r for r in rows if r['是否變動'].startswith('✅')]

print()
print("╔══════════════════════════════════════════════════════╗")
print("║   🪷 執行改名 — 連載 100 篇                          ║")
print("║   舊日期 → 新日期 (從 2026-06-23 起算工作日)         ║")
print("╚══════════════════════════════════════════════════════╝")
print()
print(f"CSV 共: {len(rows)} 篇")
print(f"需要改名: {len(to_rename)} 篇")
print()
print("前 3 個:")
for r in to_rename[:3]:
    print(f"  {r['舊名']}  →  {r['新名']}")
print("後 3 個:")
for r in to_rename[-3:]:
    print(f"  {r['舊名']}  →  {r['新名']}")
print()

# 二次確認
print("🛡️ 死命令 — 打『確認改名』4 個字啟動 / 其他鍵取消")
ans = input("> ").strip()
if ans != "確認改名":
    print(f"❌ 輸入「{ans}」不是「確認改名」, 已取消")
    pause()
    sys.exit(0)

# 改名 — 注意要按「篇號倒序」改, 避免命名衝突
# (因為新名 6/23 = 篇1 比舊名 5/26 = 篇1 晚很多,
#  但若同時改可能有篇 N 的新名 = 篇 M 的舊名,
#  保險起見, 先全部加 _TMP 後綴, 再去掉)

print()
print("Step 1: 全部資料夾加 _TMP 後綴 (避免命名衝突)...")
ok = 0
for r in to_rename:
    src = POST_DIR / r['舊名']
    if src.exists():
        tmp = POST_DIR / (r['舊名'] + '_TMP')
        src.rename(tmp)
        ok += 1
print(f"  完成: {ok} 個")

print()
print("Step 2: 從 _TMP 改成新名...")
ok = 0
for r in to_rename:
    tmp = POST_DIR / (r['舊名'] + '_TMP')
    new = POST_DIR / r['新名']
    if tmp.exists():
        tmp.rename(new)
        ok += 1
print(f"  完成: {ok} 個")

print()
print("✅ 改名完成!")
print()
print("★ 接下來:")
print("   1. 跑 git status 看變動")
print("   2. 用 push_jizang.bat 推 GitHub (本次只是改名, 不會推丟舊版)")
print("   3. 開始準備 6/22 前研發篇 + 6/23 篇 1 上稿包")
print()
pause()
