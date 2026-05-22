#!/usr/bin/env python3
"""
地藏經弘法 本地審查預覽介面 (阿地寫)
====================================

啟動後在瀏覽器打開 http://localhost:5000
可以:
    - 看所有準備好的貼文 (按日期排序)
    - 預覽 docx 文字內容
    - 看到所有圖片縮圖
    - 一鍵排程到 FB
    - 一鍵跳過/標記

使用:
    pip install flask python-docx
    python review.py
"""

import os
import sys
import json
import re
import time
import threading
import webbrowser
from pathlib import Path
from datetime import datetime, timezone, timedelta
from urllib.parse import unquote

try:
    from flask import Flask, render_template_string, request, jsonify, send_file, abort
except ImportError:
    print("⚠ 需要 Flask, 執行: pip install flask")
    sys.exit(1)

try:
    from docx import Document
except ImportError:
    print("⚠ 需要 python-docx, 執行: pip install python-docx")
    sys.exit(1)

import fb_auto  # 用阿地的發文工具

ROOT = Path(__file__).parent
POST_DIR = ROOT / "每篇貼文"
TZ_TAIPEI = timezone(timedelta(hours=8))

app = Flask(__name__)


# ─────────────────────── 工具函式 ───────────────────────

def parse_folder(folder):
    """解析資料夾資訊"""
    name = folder.name
    m = re.match(r"(\d{4}-\d{2}-\d{2})_(.+?)(?:_(.+))?$", name)
    if not m:
        return None
    date_str, kind, theme = m.group(1), m.group(2), m.group(3) or ""

    # 抓 docx 內 FB 文字
    docx_files = list(folder.glob("*.docx"))
    fb_text = ""
    reflection = ""
    if docx_files:
        try:
            doc = Document(docx_files[0])
            capture_section = None
            for p in doc.paragraphs:
                t = p.text.strip()
                if p.style.name.startswith("Heading"):
                    if "FB 貼文文字" in t:
                        capture_section = "fb"
                    elif "啟發反思" in t:
                        capture_section = "ref"
                    else:
                        capture_section = None
                    continue
                if capture_section == "fb" and t:
                    fb_text += t + "\n"
                elif capture_section == "ref" and t:
                    reflection += t + "\n"
        except Exception as e:
            fb_text = f"(讀取錯誤: {e})"

    # 圖片
    images = sorted([f for f in folder.iterdir()
                     if f.is_file() and re.match(r"^\d+_", f.name)
                     and f.suffix.lower() in (".png", ".jpg", ".jpeg")])

    # 狀態
    status_file = folder / "STATUS.json"
    status = None
    if status_file.exists():
        try:
            status = json.loads(status_file.read_text(encoding='utf-8'))
        except:
            pass

    return {
        "folder_name": name,
        "date": date_str,
        "kind": kind,
        "theme": theme,
        "fb_text": fb_text.strip(),
        "reflection": reflection.strip(),
        "image_count": len(images),
        "images": [img.name for img in images],
        "status": status,
        "is_scheduled": status is not None and (
            "id" in status.get("result", {}) or "post_id" in status.get("result", {})
        ),
    }


def list_all_posts():
    if not POST_DIR.exists():
        return []
    posts = []
    for f in sorted(POST_DIR.iterdir()):
        if f.is_dir():
            info = parse_folder(f)
            if info:
                posts.append(info)
    return posts


# ─────────────────────── HTML 模板 ───────────────────────

TEMPLATE = r"""
<!doctype html>
<html lang="zh-TW">
<head>
<meta charset="utf-8">
<title>🪷 地藏經弘法・貼文審查介面</title>
<style>
* { box-sizing: border-box; }
body { font-family: -apple-system, "Noto Sans TC", "微軟正黑體", sans-serif; margin: 0; padding: 20px; background: #faf6f0; color: #2d2d2d; }
header { max-width: 1200px; margin: 0 auto 20px; }
h1 { color: #b08040; margin: 0; }
.subtitle { color: #888; margin-top: 6px; }
.container { max-width: 1200px; margin: 0 auto; }
.summary { background: white; padding: 14px 20px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #b08040; }
.summary span { margin-right: 16px; }
.card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 18px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); display: grid; grid-template-columns: 1fr 1.5fr; gap: 20px; }
.card.scheduled { border-left: 4px solid #6a9956; opacity: 0.7; }
.card.zhai { border-left: 4px solid #d97706; }
.card.sutra { border-left: 4px solid #4f7ed8; }
.card-head { grid-column: 1 / -1; display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid #eee; }
.card-date { font-size: 20px; font-weight: 700; color: #333; }
.card-meta { color: #888; font-size: 14px; }
.badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; margin-left: 8px; }
.badge.zhai { background: #fef3c7; color: #92400e; }
.badge.sutra { background: #dbeafe; color: #1e40af; }
.badge.ok { background: #d1fae5; color: #065f46; }
.badge.pending { background: #fee2e2; color: #991b1b; }
.images { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 8px; }
.images img { width: 100%; height: 140px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; cursor: pointer; transition: transform 0.15s; }
.images img:hover { transform: scale(1.05); }
.text-block { background: #fafafa; padding: 14px; border-radius: 6px; max-height: 350px; overflow-y: auto; white-space: pre-wrap; line-height: 1.7; font-size: 14px; }
.text-block .label { font-weight: 700; color: #b08040; display: block; margin-bottom: 6px; }
.actions { grid-column: 1 / -1; display: flex; gap: 10px; padding-top: 12px; border-top: 1px solid #eee; }
button { padding: 10px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; }
.btn-schedule { background: #4f7ed8; color: white; }
.btn-schedule:hover { background: #3b67c0; }
.btn-now { background: #b08040; color: white; }
.btn-skip { background: #e0e0e0; color: #555; }
.btn-disabled { background: #ddd; color: #999; cursor: not-allowed; }
.toast { position: fixed; top: 20px; right: 20px; background: white; padding: 12px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; border-left: 4px solid #4f7ed8; }
.toast.success { border-left-color: #6a9956; }
.toast.error { border-left-color: #c0392b; }
.modal { position: fixed; inset: 0; background: rgba(0,0,0,0.85); display: flex; align-items: center; justify-content: center; z-index: 10000; }
.modal img { max-width: 90%; max-height: 90%; border-radius: 6px; }
.modal.hidden { display: none; }
</style>
</head>
<body>

<header>
<h1>🪷 地藏經弘法・貼文審查介面</h1>
<div class="subtitle">阿地準備,阿元預覽。確認 OK 後一鍵推到 FB 排程 → 早 08:00 自動發布</div>
</header>

<div class="container">

<div class="summary">
<span>📊 <strong>{{ posts|length }}</strong> 篇待審</span>
<span>✓ <strong>{{ scheduled_count }}</strong> 已排程</span>
<span>○ <strong>{{ pending_count }}</strong> 待處理</span>
<span style="margin-left: auto; float: right;"><a href="/" onclick="location.reload()" style="color: #b08040; text-decoration: none;">🔄 重新整理</a></span>
</div>

{% for p in posts %}
<div class="card {{ 'scheduled' if p.is_scheduled else '' }} {{ 'zhai' if '十齋日' in p.kind else 'sutra' }}">

  <div class="card-head">
    <div>
      <div class="card-date">📅 {{ p.date }}</div>
      <div class="card-meta">
        {{ p.kind }} {% if p.theme %}· {{ p.theme }}{% endif %}
        {% if '十齋日' in p.kind %}<span class="badge zhai">十齋日</span>
        {% else %}<span class="badge sutra">經文</span>{% endif %}
        {% if p.is_scheduled %}<span class="badge ok">✓ 已排程</span>
        {% else %}<span class="badge pending">○ 待處理</span>{% endif %}
        <span style="color:#888;margin-left:8px;">🖼 {{ p.image_count }} 張圖</span>
      </div>
    </div>
  </div>

  <div>
    <div class="text-block">
      <span class="label">📱 FB 貼文文字</span>
      {{ p.fb_text }}
    </div>
    {% if p.reflection %}
    <div class="text-block" style="margin-top: 10px; background: #fef9e8;">
      <span class="label">💡 啟發反思 (聖嚴法師風格)</span>
      {{ p.reflection }}
    </div>
    {% endif %}
  </div>

  <div>
    {% if p.images %}
    <div class="images">
      {% for img in p.images %}
      <img src="/img/{{ p.folder_name }}/{{ img }}" alt="{{ img }}" onclick="showFull(this.src)" title="{{ img }}">
      {% endfor %}
    </div>
    {% else %}
    <div style="padding:30px;text-align:center;background:#fafafa;border-radius:6px;color:#888;">
      ⚠ 尚未加圖。請放入命名為 <code>01_xxx.png</code>、<code>02_xxx.png</code>... 的圖檔
    </div>
    {% endif %}
  </div>

  <div class="actions">
    {% if p.is_scheduled %}
    <button class="btn-disabled" disabled>✓ 已排程到 FB</button>
    <span style="margin-left:auto;color:#888;font-size:13px;">{{ p.status.posted_at[:19] if p.status else '' }}</span>
    {% else %}
    <button class="btn-schedule" onclick="schedule('{{ p.folder_name }}', '08:00')">📅 排程到 08:00</button>
    <button class="btn-now" onclick="schedule('{{ p.folder_name }}', null)">🚀 立即發布</button>
    <button class="btn-skip" onclick="if(confirm('標記為跳過?')) skip('{{ p.folder_name }}')">⏭ 跳過</button>
    {% endif %}
  </div>

</div>
{% endfor %}

</div>

<div class="modal hidden" id="modal" onclick="this.classList.add('hidden')">
  <img id="modalImg" src="" alt="">
</div>

<script>
function showFull(src) {
  document.getElementById('modalImg').src = src;
  document.getElementById('modal').classList.remove('hidden');
}

function toast(msg, kind = '') {
  const t = document.createElement('div');
  t.className = 'toast ' + kind;
  t.textContent = msg;
  document.body.appendChild(t);
  setTimeout(() => t.remove(), 4000);
}

async function schedule(folder, time) {
  toast('排程中...');
  const r = await fetch('/api/schedule', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({folder, time})
  });
  const data = await r.json();
  if (data.ok) {
    toast('✓ 排程成功! FB ID: ' + (data.id || 'N/A'), 'success');
    setTimeout(() => location.reload(), 1500);
  } else {
    toast('✗ 失敗: ' + data.error, 'error');
  }
}

async function skip(folder) {
  await fetch('/api/skip', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({folder})
  });
  location.reload();
}
</script>

</body>
</html>
"""


# ─────────────────────── 路由 ───────────────────────

@app.route("/")
def index():
    posts = list_all_posts()
    scheduled_count = sum(1 for p in posts if p["is_scheduled"])
    return render_template_string(
        TEMPLATE,
        posts=posts,
        scheduled_count=scheduled_count,
        pending_count=len(posts) - scheduled_count,
    )


@app.route("/img/<path:folder>/<path:filename>")
def img(folder, filename):
    folder = unquote(folder)
    filename = unquote(filename)
    img_path = POST_DIR / folder / filename
    if not img_path.exists():
        abort(404)
    return send_file(img_path)


@app.route("/api/schedule", methods=["POST"])
def api_schedule():
    data = request.json
    folder_name = data.get("folder")
    time_str = data.get("time")

    folder = POST_DIR / folder_name
    if not folder.exists():
        return jsonify({"ok": False, "error": "資料夾不存在"})

    # 用 fb_auto.py 的功能
    info = parse_folder(folder)
    if not info["fb_text"]:
        return jsonify({"ok": False, "error": "找不到 FB 貼文文字"})

    images = sorted([f for f in folder.iterdir()
                     if f.is_file() and re.match(r"^\d+_", f.name)
                     and f.suffix.lower() in (".png", ".jpg", ".jpeg")])

    ts = None
    if time_str:
        ts = fb_auto.parse_local_time(info["date"], time_str)
        now = int(time.time())
        if ts - now < 600:
            return jsonify({"ok": False, "error": f"距離排程時間只剩 {ts-now} 秒,FB 需要 >10 分鐘"})

    try:
        result = fb_auto.post_to_fb("dizang", info["fb_text"], images, scheduled_publish_time=ts)
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)})

    # 存狀態
    status = {
        "folder": folder_name,
        "page_key": "dizang",
        "page_name": "地藏菩薩本行經",
        "scheduled_at": None if not time_str else f'{info["date"]} {time_str}',
        "posted_at": datetime.now(TZ_TAIPEI).isoformat(),
        "result": result,
        "image_count": len(images),
    }
    (folder / "STATUS.json").write_text(json.dumps(status, ensure_ascii=False, indent=2), encoding='utf-8')

    if "id" in result or "post_id" in result:
        return jsonify({"ok": True, "id": result.get("id") or result.get("post_id")})
    else:
        return jsonify({"ok": False, "error": str(result)})


@app.route("/api/skip", methods=["POST"])
def api_skip():
    data = request.json
    folder = POST_DIR / data.get("folder")
    if folder.exists():
        (folder / "SKIPPED.txt").write_text(
            f"使用者跳過於 {datetime.now(TZ_TAIPEI).isoformat()}\n",
            encoding='utf-8'
        )
    return jsonify({"ok": True})


# ─────────────────────── 啟動 ───────────────────────

def open_browser_delayed():
    time.sleep(1.5)
    webbrowser.open("http://localhost:5000")


if __name__ == "__main__":
    threading.Thread(target=open_browser_delayed, daemon=True).start()
    print("=" * 60)
    print("🪷 地藏經弘法・貼文審查介面已啟動")
    print(f"   瀏覽器自動開啟: http://localhost:5000")
    print(f"   按 Ctrl+C 結束")
    print("=" * 60)
    app.run(host="127.0.0.1", port=5000, debug=False)
