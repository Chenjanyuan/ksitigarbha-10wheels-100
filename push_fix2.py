#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Push Fix v2 - 處理目前 merge 衝突中的狀態 + push
=================================================

★ 用法: 在已經 pull 過但 merge 卡住的狀態跑
★ 對所有 unmerged 檔案用「本地版」(ours), 然後 commit + push
"""

import os, sys, subprocess
from pathlib import Path

ROOT = Path(__file__).parent
os.chdir(ROOT)

OWNER = "Chenjanyuan"
REPO = "ksitigarbha-10wheels-100"

def run(cmd, capture=True, show=True):
    if show: print(f"$ {cmd[:120]}{'...' if len(cmd)>120 else ''}")
    try:
        r = subprocess.run(cmd, shell=True, capture_output=capture, text=True, encoding='utf-8', errors='replace')
        return r.returncode, (r.stdout or '') + (r.stderr or '')
    except Exception as e:
        return 1, str(e)

def pause():
    try: input("按 Enter 結束...")
    except EOFError: pass

print()
print("=" * 60)
print(f"🪷 Push Fix v2 - 處理 merge 衝突 + push")
print("=" * 60)

tok = os.environ.get('GITHUB_TOKEN_JIZANG', '')
if not tok:
    print("❌ GITHUB_TOKEN_JIZANG 沒設")
    pause(); sys.exit(1)

# 看現況
print()
print("★ 現況檢查...")
rc, status = run("git status", show=False)
in_merge = "All conflicts fixed" in status or "Unmerged paths" in status or "fix conflicts" in status

# Step 1: 對所有 unmerged 檔案用「本地版」
rc, unmerged = run("git diff --name-only --diff-filter=U", show=False)
unmerged_files = [f for f in unmerged.strip().split('\n') if f]
print(f"  Unmerged 檔案: {len(unmerged_files)} 個")

if unmerged_files:
    print()
    print("Step 1: 對所有 unmerged 檔案保留「本地版」(ours)...")
    # 批次 checkout --ours
    for f in unmerged_files[:5]:
        print(f"  ours: {f[:80]}")
    if len(unmerged_files) > 5:
        print(f"  ... 共 {len(unmerged_files)} 個")
    rc, _ = run('git checkout --ours -- .', show=True)
    rc, _ = run('git add -A', show=True)
    print("  ✅ 完成")

# Step 2: 如果在 merge 狀態, commit merge
print()
print("Step 2: 確認 merge 狀態並 commit...")
rc, status = run("git status", show=False)
if "All conflicts fixed but you are still merging" in status or "you are in the middle of" in status.lower() or in_merge:
    msg = "merge: 整合遠端 6/10-6/13 LoveArt 命令 + 本地改名 100 篇 (保留本地版)"
    rc, out = run(f'git commit -m "{msg}"', show=True)
    print(out[:500])
else:
    # 確保 staged 變動有 commit
    rc, staged = run("git diff --cached --stat", show=False)
    if staged.strip():
        msg = "refactor: 整合遠端 commits + 改名 (阿地 2026-06-17)"
        rc, out = run(f'git commit -m "{msg}"', show=True)
        print(out[:500])
    else:
        print("  (沒新東西要 commit)")

# Step 3: push
print()
print("Step 3: Push to GitHub...")
auth_url = f"https://{tok}@github.com/{OWNER}/{REPO}.git"
rc, out = run(f"git push {auth_url} main", show=False)
print(out)

print()
print("=" * 60)
if "main -> main" in out:
    print("✅ 成功! GitHub 已更新到最新版")
    print("  阿地 待會去 GitHub 確認 100 個資料夾改名好沒")
elif "Everything up-to-date" in out:
    print("✅ 已是最新")
elif "rejected" in out:
    print("❌ 還是 rejected, 可能要 git pull 再試")
else:
    print("⚠️ 看上面訊息")
print("=" * 60)
pause()
