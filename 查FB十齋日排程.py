#!/usr/bin/env python3
"""
查 FB 地藏菩薩本行經 粉專 — 5/24 以後已排程的十齋日貼文
=========================================================

用途: 阿元 想把 5/24 以後上排程的十齋日換新圖, 要先知道有哪幾篇
作者: 阿地
日期: 2026-05-22

使用:
    python 查FB十齋日排程.py

    或雙擊這個檔(需要本機有 Python + requests)

輸出:
    1. 終端機列出 5/24 以後所有十齋日排程貼文
    2. 同時存成 「FB十齋日排程清單_5月24日以後.txt」 方便阿元 查看

★ 本腳本只「讀」不「改」, 不會動到 FB 任何內容
"""

import os
import sys
import json
import traceback
from pathlib import Path
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).parent

def pause_and_exit(code=0):
    """雙擊跑完視窗不要立刻關"""
    print()
    print("=" * 60)
    try:
        input("按 Enter 結束 (或關掉視窗)...")
    except EOFError:
        pass
    sys.exit(code)

try:
    import requests
except ImportError:
    print("❌ 缺少 requests 套件, 請先在 cmd 跑:")
    print("   pip install requests")
    pause_and_exit(1)

# ─────────── 讀 .env ───────────
env = {}
env_file = ROOT / ".env"
if not env_file.exists():
    print(f"❌ 找不到 .env: {env_file}")
    pause_and_exit(1)

with open(env_file, 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith('#') and '=' in line:
            k, v = line.split('=', 1)
            env[k.strip()] = v.strip().strip('"').strip("'")

PAGE_ID = env.get('DIZANG_PAGE_ID')
TOKEN = env.get('DIZANG_TOKEN')

if not PAGE_ID or not TOKEN:
    print("❌ .env 缺少 DIZANG_PAGE_ID 或 DIZANG_TOKEN")
    pause_and_exit(1)

print(f"🪷 查詢粉專 ID: {PAGE_ID}")
print(f"   Token 前 8 碼: {TOKEN[:8]}*** (隱藏剩餘)")
print()

# ─────────── 抓全部 scheduled_posts (含分頁) ───────────
TW = timezone(timedelta(hours=8))
posts = []
url = f"https://graph.facebook.com/v21.0/{PAGE_ID}/scheduled_posts"
params = {
    "access_token": TOKEN,
    "fields": "id,scheduled_publish_time,message",
    "limit": 100,
}

while url:
    r = requests.get(url, params=params, timeout=30)
    if r.status_code != 200:
        print(f"❌ Graph API 錯誤 ({r.status_code}):")
        print(r.text[:500])
        pause_and_exit(1)
    data = r.json()
    if 'error' in data:
        print(f"❌ Graph API 回傳錯誤:")
        print(json.dumps(data['error'], ensure_ascii=False, indent=2))
        pause_and_exit(1)
    posts.extend(data.get('data', []))
    # 翻頁
    paging = data.get('paging', {})
    next_url = paging.get('next')
    url = next_url
    params = {}  # next 已含參數

print(f"✅ 已排程貼文總數: {len(posts)}")
print()

# ─────────── 篩 5/24 以後 ───────────
cutoff = datetime(2026, 5, 24, 0, 0, 0, tzinfo=TW).timestamp()

after = []
for p in posts:
    ts = p.get('scheduled_publish_time')
    if not ts or ts < cutoff:
        continue
    dt = datetime.fromtimestamp(ts, TW)
    msg = (p.get('message') or '')
    msg_oneline = msg.replace('\n', ' ').replace('\r', ' ')
    is_zhai = ('十齋日' in msg) or ('齋日' in msg)
    after.append({
        'dt': dt,
        'id': p['id'],
        'is_zhai': is_zhai,
        'msg_preview': msg_oneline[:80],
    })

after.sort(key=lambda x: x['dt'])

# ─────────── 印出 + 存檔 ───────────
out_lines = []
out_lines.append(f"FB 粉專: 地藏菩薩本行經 ({PAGE_ID})")
out_lines.append(f"查詢時間: {datetime.now(TW).strftime('%Y-%m-%d %H:%M:%S')}")
out_lines.append(f"5/24 (含) 之後已排程貼文總數: {len(after)} 篇")
out_lines.append("")
out_lines.append("=" * 100)
out_lines.append(f"{'排程時間':<20}{'類型':<10}{'貼文 ID':<35}{'內文預覽 (前 60 字)'}")
out_lines.append("=" * 100)

zhai_only = []
for p in after:
    flag = '✅ 十齋日' if p['is_zhai'] else '   一般'
    line = f"{p['dt'].strftime('%Y-%m-%d %H:%M'):<20}{flag:<10}{p['id']:<35}{p['msg_preview'][:60]}"
    out_lines.append(line)
    if p['is_zhai']:
        zhai_only.append(p)

out_lines.append("")
out_lines.append("=" * 100)
out_lines.append(f"★ 其中十齋日有 {len(zhai_only)} 篇 (這些是阿元 要換圖的對象):")
out_lines.append("=" * 100)
for p in zhai_only:
    line = f"{p['dt'].strftime('%Y-%m-%d %H:%M')}  ID={p['id']}  {p['msg_preview'][:60]}"
    out_lines.append(line)

result = '\n'.join(out_lines)
print(result)

# 存檔
out_file = ROOT / "FB十齋日排程清單_5月24日以後.txt"
out_file.write_text(result, encoding='utf-8')
print()
print(f"📄 清單已存到: {out_file}")
print()
print("★ 阿地 提醒:")
print("   1. 本腳本只 GET 不會改任何東西")
print("   2. 換圖前請阿地 二次確認再動作")
print("   3. token 不要外傳, 截圖前先遮掉")
pause_and_exit(0)
