# -*- coding: utf-8 -*-
# 英文檔名的啟動器（避開 Windows 批次檔對中文檔名亂碼的問題）
import runpy, os, pathlib
here = pathlib.Path(__file__).resolve().parent
os.chdir(str(here))
runpy.run_path(str(here / "生圖介面.py"), run_name="__main__")
