#!/usr/bin/env python3
# 短檔名 wrapper, 給 PowerShell 用
# 不要用中文檔名以免 shell 引號搞掉
import sys
from pathlib import Path

target = Path(__file__).parent / "批次上稿_十齋日_2026年.py"
print(f"🪷 跑: {target.name}")
print()

# 直接 exec 不用包裝
exec(open(target, encoding='utf-8').read(), {'__name__': '__main__', '__file__': str(target)})
