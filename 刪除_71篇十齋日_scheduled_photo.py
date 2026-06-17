#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
刪除 71 個 scheduled photo - 十齋日 (5/24~12/31)
================================================

★ 阿元 親自二次確認後執行
★ 只刪 token/API 上的「scheduled photo」, 不動已發的內容
★ 死命令 1 — 腳本內要打「確認刪除」4 字才動

作者: 阿地 · 2026-05-23
"""

import os, sys, json
from pathlib import Path
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).parent
TW = timezone(timedelta(hours=8))

def pause_exit(code=0):
    print()
    try:
        input("按 Enter 結束 (或關掉視窗)...")
    except EOFError:
        pass
    sys.exit(code)

try:
    import requests
except ImportError:
    print("❌ 先 pip install requests")
    pause_exit(1)

# 讀 .env
env = {}
env_file = ROOT / ".env"
if not env_file.exists():
    print("❌ 找不到 .env")
    pause_exit(1)
for line in env_file.read_text(encoding='utf-8').splitlines():
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1)
        env[k.strip()] = v.strip().strip('"').strip("'")

PAGE_ID = env.get('DIZANG_PAGE_ID')
TOKEN = env.get('DIZANG_TOKEN')

if not PAGE_ID or not TOKEN:
    print("❌ .env 缺 DIZANG_PAGE_ID 或 DIZANG_TOKEN")
    pause_exit(1)

print()
print("╔══════════════════════════════════════════════════════╗")
print("║   🪷 刪除 71 個十齋日 scheduled photo                 ║")
print("║   ⛔ 此操作不可逆 (但只刪未來排程, 沒人看過)         ║")
print("╚══════════════════════════════════════════════════════╝")
print()

# Step 1: 查目前 scheduled_posts
print("🔍 查 FB 目前已排程貼文...")
posts = []
url = f"https://graph.facebook.com/v21.0/{PAGE_ID}/scheduled_posts"
params = {"access_token": TOKEN, "fields": "id,scheduled_publish_time,message", "limit": 100}

while url:
    r = requests.get(url, params=params, timeout=30)
    data = r.json()
    if 'error' in data:
        print(f"❌ Graph API 錯誤: {data['error'].get('message')}")
        pause_exit(1)
    posts.extend(data.get('data', []))
    url = data.get('paging', {}).get('next')
    params = {}

# Step 2: 篩 2026-05-24 起 + 含「十齋日」的
cutoff = datetime(2026, 5, 24, 0, 0, 0, tzinfo=TW).timestamp()
to_delete = []
for p in posts:
    ts = p.get('scheduled_publish_time', 0)
    msg = p.get('message') or ''
    if ts >= cutoff and '十齋日' in msg:
        dt = datetime.fromtimestamp(ts, TW)
        to_delete.append({'dt': dt, 'id': p['id'], 'msg': msg.replace('\n', ' ')[:40]})

to_delete.sort(key=lambda x: x['dt'])

print(f"✅ 找到 {len(to_delete)} 個 scheduled photo 符合條件")
print()
if not to_delete:
    print("沒有要刪的, 結束")
    pause_exit(0)

# 顯示前 3 + 後 3 預覽
print("─" * 60)
print("前 3 篇:")
for p in to_delete[:3]:
    print(f"  {p['dt'].strftime('%Y-%m-%d %H:%M')}  {p['id']}  {p['msg']}")
print("...")
print("後 3 篇:")
for p in to_delete[-3:]:
    print(f"  {p['dt'].strftime('%Y-%m-%d %H:%M')}  {p['id']}  {p['msg']}")
print("─" * 60)
print()
print(f"⚠️ 以上 {len(to_delete)} 篇 將被永久刪除")
print(f"   (還沒發過, 粉絲沒看過, 刪了沒人會發現)")
print()

# Step 3: 二次確認 (打「確認刪除」4 字)
print("🛡️ 死命令 1 — 親自確認")
print("   打『確認刪除』4 個字啟動 / 任何其他輸入則取消")
print()
ans = input("> ").strip()
if ans != "確認刪除":
    print(f"❌ 輸入「{ans}」不是「確認刪除」, 已取消")
    pause_exit(0)

print()
print(f"開始刪除 {len(to_delete)} 篇... {datetime.now(TW).strftime('%H:%M:%S')}")
print()

# Step 4: 開始刪
import time
success = 0
failed = []
for i, p in enumerate(to_delete, 1):
    pid = p['id']
    prefix = f"[{i:3d}/{len(to_delete)}] {p['dt'].strftime('%Y-%m-%d %H:%M')} {p['msg'][:20]}"
    try:
        r = requests.delete(
            f"https://graph.facebook.com/v21.0/{pid}",
            params={"access_token": TOKEN},
            timeout=30
        )
        data = r.json()
        if data.get('success'):
            print(f"{prefix} ✅ 刪除")
            success += 1
        elif 'error' in data:
            err_msg = data['error'].get('message', str(data))[:80]
            print(f"{prefix} ❌ {err_msg}")
            failed.append((pid, err_msg))
        else:
            print(f"{prefix} ⚠️ 異常回應: {str(data)[:80]}")
            failed.append((pid, str(data)[:80]))
    except Exception as e:
        print(f"{prefix} ❌ 連線錯誤: {e}")
        failed.append((pid, str(e)))

    time.sleep(0.5)  # 避免 rate limit

# Step 5: 總結
print()
print("=" * 60)
print(f"✅ 成功刪除: {success} 篇")
print(f"❌ 失敗: {len(failed)} 篇")
print("=" * 60)
if failed:
    print()
    print("失敗清單 (前 5 筆):")
    for pid, msg in failed[:5]:
        print(f"  {pid}: {msg}")

# Step 6: 清掉本機 STATUS.json (改名保留紀錄)
print()
print("📂 清理本機 STATUS.json...")
renamed = 0
timestamp = datetime.now(TW).strftime('%Y%m%d_%H%M%S')
for d in (ROOT / "每篇貼文").iterdir():
    if d.is_dir() and d.name.startswith("十齋日_"):
        s = d / "STATUS.json"
        if s.exists():
            s.rename(d / f"STATUS_deleted_{timestamp}.json")
            renamed += 1
print(f"已改名 {renamed} 個 STATUS.json → STATUS_deleted_{timestamp}.json (沒刪, 保留紀錄)")

print()
print("🪷 完成")
print(f"   FB 那邊應該已經沒有 71 篇 scheduled photo 了")
print(f"   可以跑 python run_check.py 確認")
print()
print("★ 接下來:")
print("   1. 決定之後改用什麼方式上稿 (UI 手動 / Playwright MCP / 上稿包)")
print("   2. 不急 — 不必今天決定")
print()
pause_exit(0)
