#!/usr/bin/env python3
# 短檔名 wrapper — 給 PowerShell 用
# 執行改名_連載100篇.py
from pathlib import Path
target = Path(__file__).parent / "執行改名_連載100篇.py"
print(f"🪷 跑: {target.name}")
print()
exec(open(target, encoding='utf-8').read(), {'__name__': '__main__', '__file__': str(target)})
