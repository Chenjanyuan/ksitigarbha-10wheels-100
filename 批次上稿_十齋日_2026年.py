#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批次上稿 — 十齋日 2026 年全部 (5/24 ~ 12/31)
==================================================

★ 讀取「十齋日配對表.csv」, 篩出 2026-12-31 (含) 之前的,
  逐筆呼叫 fb_auto.post_to_fb() 排程到 FB
★ 排程時間: 早上 06:00 (台北)
★ 每篇成功會寫 STATUS.json 到對應資料夾
★ 失敗會寫 ERROR.txt, 不會卡住整批
★ 中途斷掉再跑也 OK, 有 STATUS.json 的會自動跳過

★ 絕對沒有刪除動作 (遵守 CLAUDE.md 死命令 1)

作者: 阿地 · 2026-05-22
"""

import sys
import os
import csv
import json
import time
import importlib.util
from pathlib import Path
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"
TW = timezone(timedelta(hours=8))

def pause_exit(code=0):
    print()
    print("=" * 60)
    try:
        input("按 Enter 結束 (或關掉視窗)...")
    except EOFError:
        pass
    sys.exit(code)

# ─────── 載入 .env (讓 fb_auto.py 能讀到 token) ───────
env_file = ROOT / ".env"
if env_file.exists():
    for line in env_file.read_text(encoding='utf-8').splitlines():
        line = line.strip()
        if line and not line.startswith('#') and '=' in line:
            k, v = line.split('=', 1)
            os.environ[k.strip()] = v.strip().strip('"').strip("'")

# ─────── 載入 fb_auto.py ───────
spec = importlib.util.spec_from_file_location('fb_auto', str(ROOT / "fb_auto.py"))
fb_auto = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fb_auto)

# ─────── 載入配對表 ───────
csv_file = ROOT / "十齋日配對表.csv"
if not csv_file.exists():
    print(f"❌ 找不到配對表: {csv_file}")
    print(f"   先跑「生成十齋日配對表.py」再回來跑這個")
    pause_exit(1)

rows = list(csv.DictReader(open(csv_file, encoding='utf-8-sig')))

# ─────── 篩 2026 年 ───────
batch = [r for r in rows if r["日期"] <= "2026-12-31"]

print()
print("╔══════════════════════════════════════════════════════╗")
print("║   🪷 批次上稿 — 十齋日 2026 年                        ║")
print("╚══════════════════════════════════════════════════════╝")
print()
print(f"配對表共: {len(rows)} 筆")
print(f"本批 (≤ 2026-12-31): {len(batch)} 筆")
print()
print("前 5 筆預覽:")
for r in batch[:5]:
    print(f"  {r['日期']} {r['農曆']:<5} ← {r['配對圖片']}")
print(f"  ...")
print(f"  {batch[-1]['日期']} {batch[-1]['農曆']:<5} ← {batch[-1]['配對圖片']}")
print()
print("⚠️ 注意:")
print("   1. FB 排程上限約 6 個月, 排到 12/31 可能後段被擋下")
print("   2. 被擋的會自動標記 ERROR, 不影響前段成功")
print("   3. 已有 STATUS.json 的會跳過")
print("   4. 早上 06:00 排程 (CLAUDE.md 規範)")
print()
ans = input("確定要開始上稿嗎? 輸入 「上稿」 確認 / 其他鍵取消: ").strip()
if ans != "上稿":
    print("❌ 已取消")
    pause_exit(0)

# ─────── 開始上稿 ───────
success = 0
skipped = 0
failed  = []
print()
print(f"開始上稿... {datetime.now(TW).strftime('%H:%M:%S')}")
print("─" * 60)

for i, r in enumerate(batch, 1):
    date = r["日期"]
    folder_name = r["資料夾"]
    # 圖片相對路徑 → 用本機 ROOT 組合完整路徑 (沙箱/Windows 都能跑)
    rel = r.get("圖片相對路徑") or r.get("圖片完整路徑", "")
    rel = rel.replace("\\", "/")  # 統一斜線
    img_path = ROOT / rel
    folder = POST_DIR / folder_name

    prefix = f"[{i:3d}/{len(batch)}] {date} {r['農曆']:<5}"

    # 跳過已上稿
    if (folder / "STATUS.json").exists():
        print(f"{prefix} ⏭  已有 STATUS.json, 跳過")
        skipped += 1
        continue

    # 找 docx
    docx_path = folder / "貼文內容.docx"
    if not docx_path.exists():
        print(f"{prefix} ❌ 找不到 docx: {docx_path}")
        failed.append((folder_name, "找不到 docx"))
        continue

    # 抓貼文文字
    try:
        text = fb_auto.extract_post_text_from_docx(docx_path)
        if not text:
            print(f"{prefix} ❌ docx 內沒有 FB 貼文文字段落")
            failed.append((folder_name, "docx 內無貼文文字"))
            continue
    except Exception as e:
        print(f"{prefix} ❌ 讀 docx 失敗: {e}")
        failed.append((folder_name, f"讀 docx: {e}"))
        continue

    # 排程時間 = 該日早上 06:00
    try:
        ts = fb_auto.parse_local_time(date, "06:00")
    except Exception as e:
        print(f"{prefix} ❌ 時間解析失敗: {e}")
        failed.append((folder_name, f"時間: {e}"))
        continue

    # 檢查圖
    if not img_path.exists():
        print(f"{prefix} ❌ 圖片不存在: {img_path}")
        failed.append((folder_name, f"圖不存在: {img_path}"))
        continue

    # 推到 FB
    try:
        result = fb_auto.post_to_fb("dizang", text, [img_path], scheduled_publish_time=ts)
    except Exception as e:
        msg = str(e)
        print(f"{prefix} ❌ FB 連線錯誤: {msg[:80]}")
        failed.append((folder_name, msg))
        (folder / "ERROR.txt").write_text(
            f"{datetime.now(TW).isoformat()}\n{msg}\n",
            encoding='utf-8'
        )
        continue

    # ★ 真正檢查 FB 是否成功 — result 含 error 就是失敗
    if "error" in result:
        err = result["error"]
        err_msg = err.get("message", str(err))[:120]
        print(f"{prefix} ❌ FB 拒絕: {err_msg}")
        failed.append((folder_name, err_msg))
        (folder / "ERROR.txt").write_text(
            f"{datetime.now(TW).isoformat()}\n{json.dumps(result, ensure_ascii=False, indent=2)}\n",
            encoding='utf-8'
        )
        # 如果是 token 過期, 整批沒救, 提早結束
        if err.get("code") == 190:
            print()
            print("=" * 60)
            print("🔑 ★ Token 過期! 整批停止")
            print("   請阿元 先去 Graph API Explorer 拿新的 token,")
            print("   貼到 .env 的 DIZANG_TOKEN= 後面, 再重跑這個腳本")
            print("=" * 60)
            break
        continue

    if not (result.get("id") or result.get("post_id")):
        msg = f"FB 回應沒有 post id: {json.dumps(result, ensure_ascii=False)[:120]}"
        print(f"{prefix} ⚠️ 異常: {msg}")
        failed.append((folder_name, msg))
        continue

    # 真的成功了, 寫 STATUS.json
    status = {
        "folder": folder_name,
        "page_key": "dizang",
        "page_name": "地藏菩薩本行經",
        "scheduled_at": f"{date} 06:00",
        "posted_at": datetime.now(TW).isoformat(),
        "result": result,
        "image": str(img_path),
    }
    (folder / "STATUS.json").write_text(
        json.dumps(status, ensure_ascii=False, indent=2),
        encoding='utf-8'
    )
    post_id = result.get("id") or result.get("post_id")
    print(f"{prefix} ✅ {post_id}")
    success += 1

    # FB 限流, 每筆間隔拉長到 8 秒, 補推失敗篇用
    time.sleep(8)

# ─────── 總結 ───────
print()
print("=" * 60)
print(f"✅ 成功: {success} 篇")
print(f"⏭  跳過: {skipped} 篇 (已上稿過)")
print(f"❌ 失敗: {len(failed)} 篇")
if failed:
    print()
    print("失敗清單 (前 10 筆):")
    for fn, msg in failed[:10]:
        print(f"   {fn}: {msg[:80]}")
print("=" * 60)
print()
print("★ 阿元 上 FB / Meta Business Suite 後台檢查:")
print("   - 排程內容 → 看 5/24 開始有沒有出現")
print("   - 失敗的篇章在資料夾裡有 ERROR.txt 可以看原因")
print()
pause_exit(0)
