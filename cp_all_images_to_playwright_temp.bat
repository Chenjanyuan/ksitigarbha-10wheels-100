@echo off
chcp 65001 > nul
title 一次把 100 篇圖 cp 到 Playwright Temp (阿地自動化)
echo.
echo ================================================================
echo  🪷 阿地自動化 - 一次把 100 篇圖 cp 到 Playwright MCP Temp
echo ================================================================
echo.
echo 來源: 每篇貼文\<篇>\(圖片\)*.png/.jpg
echo 目的: C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\pian<N>\
echo.
echo 阿元雙擊本 .bat 一次即可,以後阿地上稿不用再 cp
echo.
echo ================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "& {
  $ErrorActionPreference = 'Continue';
  $base = 'C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經\每篇貼文';
  $temp = 'C:\Users\chenj\AppData\Local\Temp\.playwright-mcp';

  if (-not (Test-Path $temp)) {
    New-Item -ItemType Directory -Path $temp -Force | Out-Null;
  }

  $folders = Get-ChildItem $base -Directory | Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}_第(\d+)篇' };
  Write-Host \"📂 找到 $($folders.Count) 個連載篇資料夾\";
  Write-Host '';

  $ok = 0; $skip = 0; $total_imgs = 0;
  foreach ($f in $folders) {
    $pian_num = [int]($f.Name -replace '.*第(\d+)篇.*', '$1');
    $dst = Join-Path $temp \"pian$pian_num\";

    # 找圖(根目錄 OR 圖片子夾)
    $imgs_root = Get-ChildItem $f.FullName -Include '*.png','*.jpg','*.jpeg' -File -ErrorAction SilentlyContinue;
    $imgs_sub = $null;
    $sub = Join-Path $f.FullName '圖片';
    if (Test-Path $sub) {
      $imgs_sub = Get-ChildItem $sub -Include '*.png','*.jpg','*.jpeg' -File -Recurse -ErrorAction SilentlyContinue;
    }
    $imgs = if ($imgs_root) { $imgs_root } else { $imgs_sub };

    if (-not $imgs -or $imgs.Count -eq 0) {
      Write-Host \"  ⊘ 篇$pian_num : 沒圖,跳過\";
      $skip++;
      continue;
    }

    if (-not (Test-Path $dst)) {
      New-Item -ItemType Directory -Path $dst -Force | Out-Null;
    }

    # 過濾掉雜檔
    $imgs = $imgs | Where-Object { $_.Name -notmatch 'lovart_|比較用_|原免費版|thumb' };

    $imgs | Copy-Item -Destination $dst -Force;
    $count = (Get-ChildItem $dst -File).Count;
    Write-Host \"  ✅ 篇$pian_num : cp $count 張到 pian$pian_num\\\";
    $ok++;
    $total_imgs += $count;
  }

  Write-Host '';
  Write-Host '================================================================';
  Write-Host \"🪷 完成! $ok 篇成功 / $skip 篇跳過 / 總共 $total_imgs 張圖\";
  Write-Host '================================================================';
  Write-Host '';
  Write-Host '目的地: C:\Users\chenj\AppData\Local\Temp\.playwright-mcp\';
  Write-Host '阿地之後上稿直接從這裡拿,不用再 cp';
}"

echo.
pause
