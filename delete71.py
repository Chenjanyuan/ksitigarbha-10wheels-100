#!/usr/bin/env python3
# 短檔名 wrapper - PowerShell 用
from pathlib import Path
target = Path(__file__).parent / "刪除_71篇十齋日_scheduled_photo.py"
print(f"🪷 跑: {target.name}")
print()
exec(open(target, encoding='utf-8').read(), {'__name__': '__main__', '__file__': str(target)})
