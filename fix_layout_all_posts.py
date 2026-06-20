"""自動修 100 篇 FB 貼文.txt 排版
規則(阿元 2026-06-20 拍板):
1. 標題行(🌸【/📖/💡/📚/🎨/🌿/🪷 開頭)後面必須空一行
2. ─── 分隔線前後必須空一行
3. 沒副作用 — 只加空行,不刪文字
"""
from pathlib import Path

TITLE_PREFIXES = ['🌸【', '📖 ', '💡 ', '📚 ', '🎨 ', '🌿 ', '🪷 ']
POST_ROOT = Path(__file__).parent / "每篇貼文"


def is_title(line):
    s = line.strip()
    return any(s.startswith(p) for p in TITLE_PREFIXES)


def is_divider(line):
    return line.strip().startswith('───')


def fix_text(text):
    lines = text.split('\n')
    out = []
    for i, line in enumerate(lines):
        out.append(line)
        nxt = lines[i+1] if i+1 < len(lines) else ''
        if is_title(line) and nxt.strip() != '':
            out.append('')
        if is_divider(line) and nxt.strip() != '':
            out.append('')
    lines2 = out
    out2 = []
    for i, line in enumerate(lines2):
        prev = lines2[i-1] if i > 0 else ''
        if is_divider(line) and prev.strip() != '':
            out2.append('')
        out2.append(line)
    return '\n'.join(out2)


def main():
    total = 0
    fixed_count = 0
    for sub in sorted(POST_ROOT.iterdir()):
        if not sub.is_dir():
            continue
        txt = sub / "FB貼文純文字.txt"
        if not txt.exists():
            continue
        total += 1
        try:
            orig = txt.read_text(encoding='utf-8')
        except UnicodeDecodeError:
            orig = txt.read_text(encoding='utf-8', errors='ignore')
        fixed = fix_text(orig)
        if fixed != orig:
            fixed_count += 1
            txt.write_text(fixed, encoding='utf-8')
            print(f"  已修 {sub.name}")
    print(f"\n掃描 {total} 篇,修改 {fixed_count} 篇")


if __name__ == '__main__':
    main()
