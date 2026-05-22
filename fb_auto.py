#!/usr/bin/env python3
"""
地藏經弘法 FB 自動發文工具 v2 (阿地寫)
========================================

✨ 新功能:一行指令搞定整篇 (從資料夾自動讀 docx + 圖片 + 日期)

使用方式:
    python fb_auto.py test                                 # 測試所有粉專連線
    python fb_auto.py post-folder 2026-05-17_十齋日_農曆初一  # ★ 從資料夾全自動排程
    python fb_auto.py post-folder 2026-05-17_十齋日_農曆初一 --time 07:00
    python fb_auto.py post-folder 2026-05-17_十齋日_農曆初一 --now  # 立即發
    python fb_auto.py batch                                # 排所有未排程的資料夾
    python fb_auto.py status                               # 列出已排程狀態
    python fb_auto.py help

資料夾結構(放在「每篇貼文/」底下):
    每篇貼文/
      2026-05-17_十齋日_農曆初一/
        貼文內容.docx       ← 阿地會讀「📱 FB 貼文文字」段落
        01_圖.png           ← 阿地會找所有 NN_*.png|jpg
        02_圖.png
        ...
        STATUS.json         ← 排程後自動產生,記 FB post_id

時間規則:
    - 十齋日(資料夾名含「十齋日」)→ 預設早 06:00
    - 經文 → 預設早 07:00
    - 用 --time HH:MM 可覆寫

需要先安裝: pip install requests python-dotenv python-docx
"""

import os
import sys
import json
import time
import re
import requests
from datetime import datetime, timezone, timedelta
from pathlib import Path

# ─────────────────────── 設定 ───────────────────────

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"
ENV_PATH = ROOT / ".env"

if ENV_PATH.exists():
    for line in ENV_PATH.read_text(encoding='utf-8').splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if '=' in line:
            k, v = line.split('=', 1)
            os.environ[k.strip()] = v.strip()

GRAPH_VERSION = "v25.0"
GRAPH = f"https://graph.facebook.com/{GRAPH_VERSION}"

PAGES = {
    "dizang":      {"name": "地藏菩薩本行經",    "id": os.environ.get("DIZANG_PAGE_ID"),      "token": os.environ.get("DIZANG_TOKEN")},
    "paw_reunion": {"name": "毛孩重逢照相館",    "id": os.environ.get("PAW_REUNION_PAGE_ID"), "token": os.environ.get("PAW_REUNION_TOKEN")},
    "alumi":       {"name": "Alumi 餐車",         "id": os.environ.get("ALUMI_PAGE_ID"),       "token": os.environ.get("ALUMI_TOKEN")},
    "whatdog":     {"name": "WhatDog 毛孩天地",  "id": os.environ.get("WHATDOG_PAGE_ID"),     "token": os.environ.get("WHATDOG_TOKEN")},
    "prapti":      {"name": "展覽車 Prapti",     "id": os.environ.get("PRAPTI_PAGE_ID"),      "token": os.environ.get("PRAPTI_TOKEN")},
}

TZ_TAIPEI = timezone(timedelta(hours=8))


def get_page(key="dizang"):
    p = PAGES.get(key)
    if not p or not p["token"]:
        raise ValueError(f"粉專 '{key}' 未設定或 token 缺失。請檢查 .env")
    return p


def parse_local_time(date_str, time_str):
    dt = datetime.strptime(f"{date_str} {time_str}", "%Y-%m-%d %H:%M")
    dt = dt.replace(tzinfo=TZ_TAIPEI)
    return int(dt.timestamp())


# ─────────────────────── docx 讀取 ───────────────────────

def extract_post_text_from_docx(docx_path):
    """從貼文內容.docx 抓出 FB 貼文文字段落"""
    try:
        from docx import Document
    except ImportError:
        print("⚠ 需要 python-docx,執行: pip install python-docx")
        sys.exit(1)

    doc = Document(docx_path)
    paragraphs = doc.paragraphs

    # 找「📱 FB 貼文文字」這個 heading,抓它後面到下個 heading 之間的所有段落
    capture = False
    lines = []
    for p in paragraphs:
        text = p.text.strip()
        if not text:
            if capture:
                lines.append("")
            continue
        # 是否為 heading
        is_heading = p.style.name.startswith("Heading")
        if "FB 貼文文字" in text:
            capture = True
            continue
        if capture and is_heading:
            break  # 下一個 heading,結束
        if capture:
            lines.append(text)

    # 清理多餘換行
    result = "\n".join(lines).strip()
    # 把過多空行收斂為最多 2 個
    result = re.sub(r"\n{3,}", "\n\n", result)
    return result


# ─────────────────────── 資料夾掃描 ───────────────────────

def parse_folder_name(name):
    """
    從資料夾名稱抓 (日期, 類型, 主題)
    格式: YYYY-MM-DD_類型_主題
    例: 2026-05-17_十齋日_農曆初一
    """
    m = re.match(r"(\d{4}-\d{2}-\d{2})_(.+?)(?:_(.+))?$", name)
    if not m:
        return None, None, None
    return m.group(1), m.group(2), m.group(3) or ""


def find_images(folder):
    """找所有 NN_*.{png|jpg|jpeg} 圖檔,按編號排序"""
    files = []
    for f in folder.iterdir():
        if f.is_file() and re.match(r"^\d+_", f.name) and f.suffix.lower() in (".png", ".jpg", ".jpeg"):
            files.append(f)
    files.sort(key=lambda x: x.name)
    return files


def default_time_for(folder_name):
    """根據資料夾名稱判斷預設時間"""
    if "十齋日" in folder_name:
        return "06:00"
    return "07:00"


# ─────────────────────── 排程狀態管理 ───────────────────────

def load_status(folder):
    sf = folder / "STATUS.json"
    if sf.exists():
        return json.loads(sf.read_text(encoding='utf-8'))
    return {}


def save_status(folder, status):
    sf = folder / "STATUS.json"
    sf.write_text(json.dumps(status, ensure_ascii=False, indent=2), encoding='utf-8')


# ─────────────────────── Graph API 呼叫 ───────────────────────

def post_to_fb(page_key, message, image_paths=None, scheduled_publish_time=None):
    """通用發文:純文字、單圖、多圖,可立即或排程"""
    p = get_page(page_key)
    image_paths = image_paths or []

    if not image_paths:
        # 純文字
        payload = {"message": message, "access_token": p["token"]}
        if scheduled_publish_time:
            payload["published"] = "false"
            payload["scheduled_publish_time"] = scheduled_publish_time
        r = requests.post(f"{GRAPH}/{p['id']}/feed", data=payload, timeout=30)
        return r.json()

    if len(image_paths) == 1:
        # 單圖
        with open(image_paths[0], "rb") as f:
            payload = {"message": message, "access_token": p["token"]}
            if scheduled_publish_time:
                payload["published"] = "false"
                payload["scheduled_publish_time"] = scheduled_publish_time
            r = requests.post(f"{GRAPH}/{p['id']}/photos", files={"source": f}, data=payload, timeout=60)
        return r.json()

    # 多圖:先個別上傳 unpublished,再用 attached_media 發 feed
    photo_ids = []
    for img in image_paths:
        with open(img, "rb") as f:
            r = requests.post(
                f"{GRAPH}/{p['id']}/photos",
                files={"source": f},
                data={"access_token": p["token"], "published": "false"},
                timeout=60
            )
        d = r.json()
        if "id" not in d:
            return {"error": "image_upload_failed", "detail": d, "image": str(img)}
        photo_ids.append(d["id"])
        print(f"    ↑ {img.name} → {d['id']}")

    attached = [{"media_fbid": pid} for pid in photo_ids]
    payload = {
        "message": message,
        "attached_media": json.dumps(attached),
        "access_token": p["token"],
    }
    if scheduled_publish_time:
        payload["published"] = "false"
        payload["scheduled_publish_time"] = scheduled_publish_time
    r = requests.post(f"{GRAPH}/{p['id']}/feed", data=payload, timeout=60)
    return r.json()


# ─────────────────────── 指令實作 ───────────────────────

def cmd_test():
    print("=" * 60)
    print("阿地測試 5 個粉專連線")
    print("=" * 60)
    for key, p in PAGES.items():
        if not p["token"]:
            print(f"  ✗ {p['name']:<25} 未設定 token")
            continue
        try:
            r = requests.get(f"{GRAPH}/{p['id']}", params={
                "fields": "name,fan_count,followers_count",
                "access_token": p["token"]
            }, timeout=10)
            data = r.json()
            if "error" in data:
                print(f"  ✗ {p['name']:<25} {data['error']['message']}")
            else:
                fans = data.get("followers_count", data.get("fan_count", "?"))
                print(f"  ✓ {data.get('name', p['name']):<25} 追蹤者: {fans}")
        except Exception as e:
            print(f"  ✗ {p['name']:<25} 例外: {e}")
    print()


def cmd_post_folder(args):
    """post-folder <資料夾名> [--time HH:MM] [--now] [--page key]"""
    if not args:
        print("用法: post-folder <資料夾名> [--time HH:MM] [--now] [--page key]")
        print("例: post-folder 2026-05-17_十齋日_農曆初一")
        return

    folder_name = args[0]
    folder = POST_DIR / folder_name
    if not folder.exists():
        print(f"找不到資料夾: {folder}")
        return

    # 解析參數
    custom_time = None
    post_now = False
    page_key = "dizang"
    i = 1
    while i < len(args):
        if args[i] == "--time" and i + 1 < len(args):
            custom_time = args[i + 1]
            i += 2
        elif args[i] == "--now":
            post_now = True
            i += 1
        elif args[i] == "--page" and i + 1 < len(args):
            page_key = args[i + 1]
            i += 2
        else:
            i += 1

    # 解析資料夾名 → 日期
    date_str, type_, theme = parse_folder_name(folder_name)
    if not date_str:
        print(f"⚠ 資料夾名格式不對(應為 YYYY-MM-DD_類型_主題): {folder_name}")
        return

    # 找 docx
    docx_files = list(folder.glob("*.docx"))
    if not docx_files:
        print(f"⚠ 資料夾內沒有 .docx 檔")
        return
    message = extract_post_text_from_docx(docx_files[0])
    if not message:
        print(f"⚠ 從 docx 抓不到 FB 貼文文字。請確認 docx 內有「📱 FB 貼文文字」這個 heading")
        return

    # 找圖片
    images = find_images(folder)

    # 決定時間
    time_str = custom_time or default_time_for(folder_name)
    if post_now:
        ts = None
    else:
        ts = parse_local_time(date_str, time_str)
        now = int(time.time())
        delta = ts - now
        if delta < 600:
            print(f"⚠ 距離現在只有 {delta} 秒。FB 規定排程必須 >10 分鐘。建議改用 --now 立即發。")
            return
        if delta > 75 * 86400:
            print(f"⚠ 排程超過 75 天,FB 不允許。")
            return

    # 顯示確認資訊
    print("=" * 60)
    print(f"  資料夾: {folder.name}")
    print(f"  粉專:   {PAGES[page_key]['name']}")
    print(f"  圖片:   {len(images)} 張")
    for img in images:
        print(f"          • {img.name}")
    print(f"  時間:   {'立即發布' if post_now else f'{date_str} {time_str} (台灣)'}")
    print(f"  文字長度: {len(message)} 字")
    print(f"  文字預覽: {message[:60]}...")
    print("=" * 60)
    print("🚀 發送中...")

    result = post_to_fb(page_key, message, images, scheduled_publish_time=ts)

    # 存狀態
    status = {
        "folder": folder_name,
        "page_key": page_key,
        "page_name": PAGES[page_key]["name"],
        "scheduled_at": None if post_now else f"{date_str} {time_str}",
        "posted_at": datetime.now(TZ_TAIPEI).isoformat(),
        "result": result,
        "image_count": len(images),
    }
    save_status(folder, status)

    if "id" in result or "post_id" in result:
        print(f"\n✅ 成功！")
        print(f"  FB ID: {result.get('id') or result.get('post_id')}")
        print(f"  狀態檔: {folder / 'STATUS.json'}")
    else:
        print(f"\n❌ 失敗:")
        print(json.dumps(result, ensure_ascii=False, indent=2))


def cmd_batch(args):
    """掃描所有資料夾,排程尚未排程的"""
    if not POST_DIR.exists():
        print(f"找不到「每篇貼文」資料夾")
        return

    folders = sorted([f for f in POST_DIR.iterdir() if f.is_dir()])
    print(f"找到 {len(folders)} 個貼文資料夾")
    print()

    pending = []
    posted = []
    for f in folders:
        status = load_status(f)
        if status and ("id" in status.get("result", {}) or "post_id" in status.get("result", {})):
            posted.append(f.name)
        else:
            pending.append(f.name)

    print(f"已排程/已發: {len(posted)} 篇")
    for n in posted:
        print(f"  ✓ {n}")
    print(f"\n待排程: {len(pending)} 篇")
    for n in pending:
        print(f"  ○ {n}")

    if not pending:
        print("\n全部已處理 ✓")
        return

    print("\n要批次排程這些? 輸入 'yes' 確認,其他鍵取消:")
    confirm = input("> ").strip().lower()
    if confirm != "yes":
        print("取消。")
        return

    for n in pending:
        print(f"\n處理 {n}...")
        cmd_post_folder([n])
        time.sleep(2)


def cmd_status():
    """列出所有資料夾排程狀態"""
    if not POST_DIR.exists():
        print(f"找不到「每篇貼文」資料夾")
        return
    folders = sorted([f for f in POST_DIR.iterdir() if f.is_dir()])
    print(f"{'資料夾':<45} {'狀態':<10} {'時間':<20}")
    print("-" * 80)
    for f in folders:
        status = load_status(f)
        if status:
            result = status.get("result", {})
            ok = "id" in result or "post_id" in result
            label = "✓ 已排程" if ok else "✗ 失敗"
            sched = status.get("scheduled_at", "立即")
        else:
            label = "○ 待排程"
            sched = "-"
        print(f"{f.name:<45} {label:<10} {sched}")


def cmd_help():
    print(__doc__)


def main():
    if len(sys.argv) < 2:
        cmd_help()
        return

    cmd = sys.argv[1]
    args = sys.argv[2:]

    dispatch = {
        "test":        lambda: cmd_test(),
        "post-folder": lambda: cmd_post_folder(args),
        "batch":       lambda: cmd_batch(args),
        "status":      lambda: cmd_status(),
        "help":        lambda: cmd_help(),
    }

    if cmd in dispatch:
        dispatch[cmd]()
    else:
        print(f"未知指令: {cmd}")
        cmd_help()


if __name__ == "__main__":
    main()
