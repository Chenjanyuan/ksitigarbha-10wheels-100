#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
刪除剛排好的篇 1 (2026-06-23 07:00 scheduled post)
================================================
理由: 漏勾「接收訊息」按鈕, 排程後無法新增, 必須刪除重做.
阿元 2026-06-17 親口指示 (兩次明確「刪除第一篇 重作」)
"""

import os, sys, json
from pathlib import Path
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).parent
TW = timezone(timedelta(hours=8))

def pause():
    try: input("按 Enter 結束...")
    except EOFError: pass

try: import requests
except ImportError:
    print("先 pip install requests")
    pause(); sys.exit(1)

env = {}
for line in (ROOT / ".env").read_text(encoding='utf-8').splitlines():
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1)
        env[k.strip()] = v.strip().strip('"').strip("'")

PAGE_ID = env['DIZANG_PAGE_ID']
TOKEN = env['DIZANG_TOKEN']

print()
print("🔍 找 2026-06-23 07:00 的 scheduled post...")
posts = []
url = f"https://graph.facebook.com/v21.0/{PAGE_ID}/scheduled_posts"
params = {"access_token": TOKEN, "fields": "id,scheduled_publish_time,message", "limit": 100}
while url:
    r = requests.get(url, params=params, timeout=30); data = r.json()
    if 'error' in data:
        print(f"❌ {data['error'].get('message')}"); pause(); sys.exit(1)
    posts.extend(data.get('data', []))
    url = data.get('paging', {}).get('next'); params = {}

# 篩 6/23 07:00 的 (含「神祕的山」或「第 1 篇」)
target_dt = datetime(2026, 6, 23, 7, 0, 0, tzinfo=TW)
target_ts = int(target_dt.timestamp())
candidates = []
for p in posts:
    ts = p.get('scheduled_publish_time', 0)
    msg = p.get('message') or ''
    if abs(ts - target_ts) < 7200 and ('神祕的山' in msg or '第 1 篇' in msg or '佉羅帝耶山' in msg):
        candidates.append(p)

print(f"找到 {len(candidates)} 個候選:")
for p in candidates:
    dt = datetime.fromtimestamp(p['scheduled_publish_time'], TW)
    msg = (p.get('message') or '').replace('\n', ' ')[:60]
    print(f"  {dt.strftime('%Y-%m-%d %H:%M')}  {p['id']}  {msg}")

if not candidates:
    print("❌ 沒找到符合的, 結束")
    pause(); sys.exit(0)

if len(candidates) > 1:
    print()
    print("⚠️ 找到多筆, 為安全起見不執行")
    pause(); sys.exit(1)

target = candidates[0]
print()
print(f"⚠️ 將刪除: {target['id']}")
print()
print("🛡️ 死命令 — 打『確認刪除』4 字啟動 / 其他鍵取消")
ans = input("> ").strip()
if ans != "確認刪除":
    print(f"❌ 輸入「{ans}」不是「確認刪除」, 已取消")
    pause(); sys.exit(0)

print()
print("刪除中...")
r = requests.delete(f"https://graph.facebook.com/v21.0/{target['id']}",
                    params={"access_token": TOKEN}, timeout=30)
data = r.json()
if data.get('success'):
    print(f"✅ 刪除成功!")
    print()
    print("接下來 — 用 Playwright 重排篇 1, 加上「接收訊息」按鈕")
else:
    print(f"❌ 刪除失敗: {data}")
pause()
