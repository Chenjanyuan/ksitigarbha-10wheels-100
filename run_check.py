#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
查 FB 已排程貼文 (短檔名給 PowerShell 用)
"""
import os, sys, json
from pathlib import Path
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).parent
TW = timezone(timedelta(hours=8))

# 讀 .env
env = {}
for line in (ROOT / ".env").read_text(encoding='utf-8').splitlines():
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1)
        env[k.strip()] = v.strip().strip('"').strip("'")

PAGE_ID = env['DIZANG_PAGE_ID']
TOKEN = env['DIZANG_TOKEN']

try:
    import requests
except ImportError:
    print("先 pip install requests")
    input("按 Enter 結束")
    sys.exit(1)

posts = []
url = f"https://graph.facebook.com/v21.0/{PAGE_ID}/scheduled_posts"
params = {"access_token": TOKEN, "fields": "id,scheduled_publish_time,message", "limit": 100}

while url:
    r = requests.get(url, params=params, timeout=30)
    data = r.json()
    if 'error' in data:
        print("Graph API 錯誤:", json.dumps(data['error'], ensure_ascii=False, indent=2))
        input("按 Enter 結束")
        sys.exit(1)
    posts.extend(data.get('data', []))
    url = data.get('paging', {}).get('next')
    params = {}

print(f"🪷 FB 上目前已排程貼文總數: {len(posts)}")
print()

# 篩 5/24 以後
cutoff = datetime(2026, 5, 24, 0, 0, 0, tzinfo=TW).timestamp()
after = sorted(
    [p for p in posts if p.get('scheduled_publish_time', 0) >= cutoff],
    key=lambda p: p['scheduled_publish_time']
)
print(f"★ 5/24 以後的: {len(after)} 篇")
print()

if after:
    print("最早 3 篇:")
    for p in after[:3]:
        dt = datetime.fromtimestamp(p['scheduled_publish_time'], TW)
        msg = (p.get('message') or '').replace('\n', ' ')[:40]
        print(f"   {dt.strftime('%Y-%m-%d %H:%M')}  ID={p['id'][:30]}...  {msg}")
    print()
    if len(after) > 3:
        print("最晚 3 篇:")
        for p in after[-3:]:
            dt = datetime.fromtimestamp(p['scheduled_publish_time'], TW)
            msg = (p.get('message') or '').replace('\n', ' ')[:40]
            print(f"   {dt.strftime('%Y-%m-%d %H:%M')}  ID={p['id'][:30]}...  {msg}")
print()
print("✅ 真實 FB 排程狀況以上 (Graph API 直接查的)")
input("按 Enter 結束")
