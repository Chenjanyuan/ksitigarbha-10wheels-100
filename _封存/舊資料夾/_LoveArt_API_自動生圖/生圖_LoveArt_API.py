#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
🪷 地藏經漫畫 — LoveArt 免費 API 半夜自動生圖
================================================
讀「生成命令_LoveArt.md」→ 用 LoveArt 官方 skill（免費無限模式 + Nano Banana Pro）
→ 自動帶角色卡參考圖 → 存進該篇「圖片」資料夾，照你們命名。

★ 在「你自己的電腦」上跑（Cowork 雲端連不到 LoveArt，已實測）。
★ 用 LoveArt 免費「無限模式」（unlimited，半夜排隊不花 credit）。
★ Gemini 那條太貴已棄用，本腳本走 LoveArt。

作者：阿研 for 阿元 / alumi 研發部門 / 2026-06-10
使用方法見「說明_使用方法.md」
"""

import os, sys, json, subprocess, time, re, argparse
from pathlib import Path

# ============ 基本路徑（可改）============
BASE       = Path(r"C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經")
CARDS_DIR  = BASE / "人物角色卡"          # 角色卡 PNG 放這
POSTS_DIR  = BASE / "每篇貼文"            # 每一篇一個資料夾
SELF_DIR   = Path(__file__).resolve().parent
CACHE_FILE = SELF_DIR / "卡片URL快取.json"  # 角色卡上傳後的網址快取（避免每次重傳）
LOG_FILE   = SELF_DIR / "生圖紀錄.log"

# agent_skill.py 位置（執行「1_下載技能檔.bat」會下載到本資料夾）
SKILL = os.environ.get("LOVART_SKILL_PATH") or str(SELF_DIR / "agent_skill.py")

MODEL     = "generate_image_nano_banana_pro"   # Nano Banana Pro
MODE      = "unlimited"                          # unlimited=免費排隊 / fast=花credit不排隊
SLEEP_SEC = 8                                    # 每格之間休息秒數
WAIT_PROJECT_ID = os.environ.get("LOVART_PROJECT_ID", "")  # 可選：固定某個 LoveArt 專案

# ============ @卡片關鍵字 → 角色卡圖檔 ============
CARD_MAP = {
    "佛陀":      "佛陀_完整角色卡_12格.png",
    "地藏":      "地藏王菩薩_完整角色卡_12格.png",
    "地藏王菩薩": "地藏王菩薩_完整角色卡_12格.png",
    "觀音":      "觀音菩薩_完整角色卡_12格.png",
    "飽和度參考": "色彩飽和度參考.png",
    "色彩飽和度參考": "色彩飽和度參考.png",
    "一般人物":   "一般人物參考-1.png",
    "大眾":      "一般人物參考-1.png",
    "文殊":      "文殊菩薩_完整角色卡_12格.png",
    "普賢":      "普賢菩薩_完整角色卡_12格.png",
    "彌勒":      "彌勒菩薩_完整角色卡_12格.png",
    "虛空藏":     "虛空藏菩薩_完整角色卡_12格.png",
    "金剛藏":     "金剛藏菩薩_完整角色卡_12格.png",
    "好疑問":     "好疑問菩薩_完整角色卡_12格.png",
}

# ============ 小工具 ============
def log(msg):
    line = time.strftime("[%Y-%m-%d %H:%M:%S] ") + msg
    print(line, flush=True)
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass

def run_skill(args):
    cmd = [sys.executable, SKILL] + args
    env = dict(os.environ); env["PYTHONIOENCODING"] = "utf-8"
    r = subprocess.run(cmd, capture_output=True, text=True,
                       encoding="utf-8", errors="replace", env=env)
    return r.returncode, (r.stdout or ""), (r.stderr or "")

def last_json(s):
    for ln in reversed(s.strip().splitlines()):
        ln = ln.strip()
        if ln.startswith("{"):
            try: return json.loads(ln)
            except Exception: pass
    return None

def load_cache():
    if CACHE_FILE.exists():
        try: return json.loads(CACHE_FILE.read_text(encoding="utf-8"))
        except Exception: return {}
    return {}

def save_cache(c):
    CACHE_FILE.write_text(json.dumps(c, ensure_ascii=False, indent=2), encoding="utf-8")

# ============ 前置：金鑰 / 技能 / 模式 ============
def preflight():
    if not os.environ.get("LOVART_ACCESS_KEY") or not os.environ.get("LOVART_SECRET_KEY"):
        log("❌ 還沒設定金鑰。請先跑『2_設定金鑰_執行一次.bat』設好 LOVART_ACCESS_KEY / LOVART_SECRET_KEY。")
        sys.exit(1)
    if not Path(SKILL).exists():
        log(f"❌ 找不到官方技能檔 agent_skill.py（{SKILL}）。請先跑『1_下載技能檔.bat』。")
        sys.exit(1)
    log(f"➡ 設定生成模式：{MODE}（unlimited=免費排隊）")
    run_skill(["set-mode", "--unlimited" if MODE == "unlimited" else "--fast"])

# ============ 角色卡 → 上傳取得網址（含快取）============
def card_url(card_kw, cache):
    fname = CARD_MAP.get(card_kw)
    if not fname:
        return None  # 未知卡片，略過（會用文字描述）
    if fname in cache and cache[fname]:
        return cache[fname]
    fpath = CARDS_DIR / fname
    if not fpath.exists():
        log(f"   ⚠ 找不到角色卡圖檔：{fname}（略過此參考）")
        return None
    log(f"   ⬆ 上傳角色卡：{fname}")
    code, out, err = run_skill(["upload", "--file", str(fpath)])
    j = last_json(out)
    if j and j.get("url"):
        cache[fname] = j["url"]; save_cache(cache)
        return j["url"]
    log(f"   ⚠ 角色卡上傳失敗：{err or out[:200]}")
    return None

# ============ 解析 生成命令_LoveArt.md ============
def clean_title(t):
    # 取 ── 後面的標題，去掉 emoji/空白/・/數字前後空格 → 給檔名用
    t = t.split("──", 1)[-1] if "──" in t else t
    t = re.sub(r"[^一-鿿0-9A-Za-z]", "", t)
    return t.strip() or "panel"

def parse_md(md_path):
    txt = md_path.read_text(encoding="utf-8")
    # 以 "## ■ Panel N/12" 切塊
    parts = re.split(r"(?m)^##\s*■\s*Panel\s*(\d+)\s*/\s*\d+\s*──?\s*(.*)$", txt)
    panels = []
    # parts: [前言, num, title, body, num, title, body, ...]
    for i in range(1, len(parts), 3):
        num   = int(parts[i])
        title = parts[i+1].strip()
        body  = parts[i+2]
        # @cards 行
        cards = []
        m = re.search(r"@cards[：:]\s*(.+)", body)
        if m:
            cards = re.findall(r"@([一-鿿A-Za-z0-9]+)", m.group(1))
        # prompt：取「—— 貼入 ——」之後到區塊結尾
        if "貼入" in body:
            prompt = body.split("貼入", 1)[1]
            prompt = prompt.lstrip("　 —-\n")
        else:
            prompt = body
        # 去掉結尾的 --- 分隔線與多餘空白
        prompt = re.sub(r"(?m)^\s*-{3,}\s*$", "", prompt).strip()
        panels.append({"num": num, "title": title, "cards": cards, "prompt": prompt})
    return panels

def pian_no(folder_name):
    m = re.search(r"第(\d+)篇", folder_name)
    return int(m.group(1)) if m else None

# ============ 生一格 ============
def gen_panel(pian, panel, img_dir, cache):
    n = panel["num"]
    # 已存在（不論誰命名，只要 第X篇_張0N_*.png 有檔就跳過）
    if list(img_dir.glob(f"第{pian}篇_張{n:02d}_*.png")) or list(img_dir.glob(f"第{pian}篇_張{n:02d}.png")):
        log(f"   ⏭ 張{n:02d} 已存在，跳過")
        return "skip"
    # 參考圖網址
    urls = []
    for kw in panel["cards"]:
        u = card_url(kw, cache)
        if u: urls.append(u)
    # 組指令
    args = ["chat", "--prompt", panel["prompt"],
            "--prefer-models", json.dumps({"IMAGE": [MODEL]}),
            "--json", "--download", "--output-dir", str(img_dir)]
    if urls:
        args += ["--attachments"] + urls
    if WAIT_PROJECT_ID:
        args += ["--project-id", WAIT_PROJECT_ID]
    log(f"   🎨 生成 張{n:02d}（參考圖 {len(urls)} 張）…")
    code, out, err = run_skill(args)
    j = last_json(out)
    if not j:
        log(f"   ❌ 失敗：{(err or out)[:300]}")
        return "fail"
    if j.get("final_status") == "pending_confirmation":
        log(f"   ⏸ 張{n:02d} 需人工確認(會花 credit)，自動模式略過（請改用無限模式或手動生）")
        return "fail"
    dl = j.get("downloaded") or []
    if not dl:
        w = j.get("warning") or j.get("agent_message") or "沒有產出圖檔（可能被內容審查擋）"
        log(f"   ⚠ 張{n:02d} 沒出圖：{w}")
        return "fail"
    src = Path(dl[0]["local_path"])
    dst = img_dir / f"第{pian}篇_張{n:02d}_{clean_title(panel['title'])}.png"
    try:
        if src.exists(): src.replace(dst)
        log(f"   ✅ 已存 {dst.name}")
    except Exception as e:
        log(f"   ✅ 下載於 {src}（改名失敗：{e}）")
    return "ok"

# ============ 處理一篇 ============
def process_post(folder, cache):
    md = folder / "生成命令_LoveArt.md"
    if not md.exists():
        return None
    pian = pian_no(folder.name)
    img_dir = folder / "圖片"; img_dir.mkdir(exist_ok=True)
    panels = parse_md(md)
    log(f"📖 {folder.name}（第{pian}篇，共 {len(panels)} 格）")
    res = {"ok":0, "skip":0, "fail":0}
    for p in panels:
        r = gen_panel(pian, p, img_dir, cache)
        res[r] += 1
        if r == "ok":
            time.sleep(SLEEP_SEC)
    log(f"   小結：新生 {res['ok']}、已存 {res['skip']}、失敗 {res['fail']}")
    return res

# ============ 主程式 ============
def main():
    ap = argparse.ArgumentParser(description="地藏經漫畫 LoveArt 免費 API 自動生圖")
    ap.add_argument("--post", help="只跑某一篇資料夾名稱（例：2026-06-16_第16篇_序品第一）")
    ap.add_argument("--all", action="store_true", help="掃整個『每篇貼文』把缺的圖全補（預設）")
    a = ap.parse_args()

    log("=" * 50)
    log("🪷 地藏經漫畫 LoveArt 自動生圖 開始")
    preflight()
    cache = load_cache()

    if a.post:
        folders = [POSTS_DIR / a.post]
    else:
        folders = sorted([f for f in POSTS_DIR.iterdir() if f.is_dir()])

    total = {"ok":0, "skip":0, "fail":0}
    for f in folders:
        r = process_post(f, cache)
        if r:
            for k in total: total[k] += r[k]

    log(f"🎉 全部跑完！新生 {total['ok']}、已存 {total['skip']}、失敗 {total['fail']}")
    log("   失敗/沒出圖的（多半是中文字糊或被審查）→ 隔天挑出來重跑即可。")
    log("=" * 50)

if __name__ == "__main__":
    main()
