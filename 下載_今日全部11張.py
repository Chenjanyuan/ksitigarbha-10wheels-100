"""下載 2026-06-20 阿美媽媽生的 11 張圖到各篇資料夾"""
import urllib.request
import urllib.error
import os
from pathlib import Path

ROOT = Path(__file__).parent / "每篇貼文"

TASKS = [
    ("https://a.lovart.ai/artifacts/agent/CTxSGJxnYUGQXIYV.png", "2026-06-30_第6篇_序品第一",  "第6篇12之9_大眾激動法喜充滿.png"),
    ("https://a.lovart.ai/artifacts/agent/XJBx919XPj6MSvg0.png", "2026-07-01_第7篇_序品第一",  "第7篇12之01_佛陀繼續開示.png"),
    ("https://a.lovart.ai/artifacts/agent/LCCGhbtUdI1N66aN.png", "2026-07-01_第7篇_序品第一",  "第7篇12之02_比喻一朗日.png"),
    ("https://a.lovart.ai/artifacts/agent/qJfMJgwkOpSfQP20.png", "2026-07-01_第7篇_序品第一",  "第7篇12之03_比喻二明炬.png"),
    ("https://a.lovart.ai/artifacts/agent/EU8nQEroQx322514.png", "2026-07-01_第7篇_序品第一",  "第7篇12之04_比喻三清涼月.png"),
    ("https://a.lovart.ai/artifacts/agent/15G9bfPKaz8SAUOB.png", "2026-07-01_第7篇_序品第一",  "第7篇12之05_比喻四車乘.png"),
    ("https://a.lovart.ai/artifacts/agent/4HiBiYLAwB55iga8.png", "2026-07-01_第7篇_序品第一",  "第7篇12之06_比喻五資糧.png"),
    ("https://a.lovart.ai/artifacts/agent/f9EtBwYx2I2mAbae.png", "2026-07-01_第7篇_序品第一",  "第7篇12之07_比喻六嚮導.png"),
    ("https://a.lovart.ai/artifacts/agent/kzZRai1hZSFVR8Oj.png", "2026-07-01_第7篇_序品第一",  "第7篇12之10_山頂全景大眾望南方.png"),
    ("https://a.lovart.ai/artifacts/agent/QL1ckPxeDWGcarLv.png", "2026-07-01_第7篇_序品第一",  "第7篇12之11_啟發反思現代場景.png"),
    ("https://a.lovart.ai/artifacts/agent/nK6GQQpGLj6eqtRB.png", "2026-07-21_第21篇_十輪品",    "第21篇12之9_地藏問五濁惡世.png"),
]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
    "Accept": "image/*,*/*;q=0.8",
    "Referer": "https://www.lovart.ai/",
}

ok = 0
fail = 0
errors = []

print("=" * 60)
print("下載 11 張 LoveArt 圖到各篇資料夾")
print("=" * 60)

for url, folder, filename in TASKS:
    dst_dir = ROOT / folder / "圖片"
    dst_dir.mkdir(parents=True, exist_ok=True)
    dst = dst_dir / filename
    print(f"\n下載: {folder}/")
    print(f"      → {filename}")
    try:
        req = urllib.request.Request(url, headers=HEADERS)
        with urllib.request.urlopen(req, timeout=60) as r:
            data = r.read()
            with open(dst, 'wb') as f:
                f.write(data)
            size = len(data) / 1024 / 1024
            print(f"  ✓ OK ({size:.2f} MB)")
            ok += 1
    except Exception as e:
        print(f"  ✗ FAIL: {e}")
        fail += 1
        errors.append((folder, filename, str(e)))

print()
print("=" * 60)
print(f"完成! 成功: {ok} / 11  失敗: {fail}")
print("=" * 60)

if errors:
    print("\n失敗清單:")
    for folder, filename, err in errors:
        print(f"  {folder} / {filename}: {err[:80]}")
