#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Push Fix - pull 遠端 + merge + push (用 Python 避開 PowerShell 中文 BOM 問題)
"""

import os, sys, subprocess
from pathlib import Path

ROOT = Path(__file__).parent
os.chdir(ROOT)

OWNER = "Chenjanyuan"
REPO = "ksitigarbha-10wheels-100"

def run(cmd, capture=False):
    print(f"$ {cmd}")
    try:
        if capture:
            r = subprocess.run(cmd, shell=True, capture_output=True, text=True, encoding='utf-8')
            return r.returncode, r.stdout + r.stderr
        else:
            r = subprocess.run(cmd, shell=True)
            return r.returncode, ""
    except Exception as e:
        return 1, str(e)

def pause():
    try: input("按 Enter 結束...")
    except EOFError: pass

print()
print("=" * 60)
print(f"🪷 Push Fix - {OWNER}/{REPO}")
print("=" * 60)

# 讀環境變數
tok = os.environ.get('GITHUB_TOKEN_JIZANG', '')
if not tok:
    print("❌ GITHUB_TOKEN_JIZANG 沒設, 請在 Windows 環境變數加")
    pause()
    sys.exit(1)
print(f"✅ Token 前 6 碼: {tok[:6]}...")

# 設定 git
run("git config user.name ayuan")
run("git config user.email jack@what.com.tw")

# 清 lock
for f in [".git/HEAD.lock", ".git/index.lock"]:
    p = ROOT / f
    if p.exists():
        try: p.unlink()
        except: pass

# Step 1: commit 本地改名變動
print()
print("Step 1: commit 本地改名變動...")
run("git add -A")
rc, out = run("git status -s", capture=True)
if out.strip():
    msg = "refactor: 連載 100 篇資料夾改名 2026-05-XX 起 → 2026-06-23 起算工作日"
    run(f'git commit -m "{msg}"')
else:
    print("  (沒新變動需要 commit)")

# Step 2: pull + merge
print()
print("Step 2: git pull (合併遠端 12 commit, 衝突保留本地)...")
auth_url = f"https://{tok}@github.com/{OWNER}/{REPO}.git"
rc, out = run(f"git pull {auth_url} main --no-rebase -X ours --no-edit 2>&1", capture=True)
print(out)

# Step 3: 檢查 merge 狀態
rc, status = run("git status", capture=True)
if "Unmerged paths" in status or "both modified" in status or "both added" in status:
    print()
    print("❌ Merge 有衝突需要人工解決!")
    print("看上面訊息找出哪些檔案衝突, 或開 GitHub Desktop 視覺化處理")
    pause()
    sys.exit(1)

# Step 4: push
print()
print("Step 3: Push to GitHub...")
rc, out = run(f"git push {auth_url} main 2>&1", capture=True)
print(out)

print()
print("=" * 60)
if "main -> main" in out:
    print("✅ 成功! GitHub 已更新")
elif "Everything up-to-date" in out:
    print("✅ 已是最新, 沒新東西要推")
else:
    print("⚠️ 看上面訊息確認狀態")
print("=" * 60)
pause()
