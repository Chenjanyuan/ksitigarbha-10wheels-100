#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
🪷 地藏經漫畫 — LoveArt 生圖『網頁介面』(本機版) v2
新增：指定第幾篇~第幾篇、選引擎、無限/餘額模式、先上傳角色卡。
排程半夜跑：python 生圖介面.py --headless
作者：阿研 for 阿元 / 2026-06-11
"""
import os, sys, json, subprocess, time, re, threading, urllib.parse, urllib.request, webbrowser
from pathlib import Path
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

BASE      = Path(r"C:\Users\chenj\Documents\Claude\Projects\自動化每天更新FB 地藏 10輪經")
CARDS_DIR = BASE / "人物角色卡"
POSTS_DIR = BASE / "每篇貼文"
SELF_DIR  = Path(__file__).resolve().parent
SKILL     = str(SELF_DIR / "agent_skill.py")
KEY_FILE  = SELF_DIR / "金鑰.txt"
CACHE_FILE= SELF_DIR / "卡片URL快取.json"
PORT      = 8770
SLEEP_SEC = 8

MODEL_DEFAULT = "generate_image_nano_banana_pro"
MODELS = {
    "Nano Banana Pro（預設）": "generate_image_nano_banana_pro",
    "Nano Banana 2": "generate_image_nano_banana_2",
    "GPT Image 2": "generate_image_gpt_image_2",
    "Seedream 4.5": "generate_image_seedream_v4_5",
    "Flux.2 Pro": "generate_image_flux_2_pro",
    "Midjourney": "generate_image_midjourney",
}

CARD_MAP = {
    "佛陀":"佛陀_完整角色卡_12格.png","地藏":"地藏王菩薩_完整角色卡_12格.png",
    "地藏王菩薩":"地藏王菩薩_完整角色卡_12格.png","觀音":"觀音菩薩_完整角色卡_12格.png",
    "飽和度參考":"色彩飽和度參考.png","色彩飽和度參考":"色彩飽和度參考.png",
    "一般人物":"一般人物參考-1.png","大眾":"一般人物參考-1.png",
    "文殊":"文殊菩薩_完整角色卡_12格.png","普賢":"普賢菩薩_完整角色卡_12格.png",
    "彌勒":"彌勒菩薩_完整角色卡_12格.png","虛空藏":"虛空藏菩薩_完整角色卡_12格.png",
    "金剛藏":"金剛藏菩薩_完整角色卡_12格.png","好疑問":"好疑問菩薩_完整角色卡_12格.png",
}

STATE = {"running": False, "log": [], "current": "", "done": 0, "fail": 0, "skip": 0}
LOCK = threading.Lock()

def log(msg):
    line = time.strftime("%H:%M:%S ") + msg
    with LOCK:
        STATE["log"].append(line); STATE["log"] = STATE["log"][-300:]
    print(line, flush=True)

def load_keys():
    if KEY_FILE.exists():
        for ln in KEY_FILE.read_text(encoding="utf-8").splitlines():
            ln = ln.strip()
            if ln.startswith("#") or "=" not in ln: continue
            k, v = ln.split("=", 1); v = v.strip().strip('"').strip("'")
            if k.strip() in ("LOVART_ACCESS_KEY","LOVART_SECRET_KEY","LOVART_PROJECT_ID"):
                if v and "換成" not in v: os.environ[k.strip()] = v

def save_keys(ak, sk):
    KEY_FILE.write_text("# LoveArt 金鑰（本機用，已設定不上傳 GitHub）\n"
        f"LOVART_ACCESS_KEY={ak.strip()}\nLOVART_SECRET_KEY={sk.strip()}\n", encoding="utf-8")

def have_keys():
    load_keys(); return bool(os.environ.get("LOVART_ACCESS_KEY") and os.environ.get("LOVART_SECRET_KEY"))

def run_skill(args):
    env = dict(os.environ); env["PYTHONIOENCODING"]="utf-8"; env["PYTHONUTF8"]="1"; env["PYTHONLEGACYWINDOWSSTDIO"]="0"
    r = subprocess.run([sys.executable, SKILL]+args, capture_output=True,
                       text=True, encoding="utf-8", errors="replace", env=env)
    return r.returncode, (r.stdout or ""), (r.stderr or "")

def last_json(s):
    s=(s or "").strip()
    if not s: return None
    try: return json.loads(s)
    except Exception: pass
    i=s.find("{"); k=s.rfind("}")
    if i>=0 and k>i:
        try: return json.loads(s[i:k+1])
        except Exception: pass
    for ln in reversed(s.splitlines()):
        ln=ln.strip()
        if ln.startswith("{"):
            try: return json.loads(ln)
            except Exception: pass
    return None

def load_cache():
    if CACHE_FILE.exists():
        try: return json.loads(CACHE_FILE.read_text(encoding="utf-8"))
        except: return {}
    return {}
def save_cache(c): CACHE_FILE.write_text(json.dumps(c,ensure_ascii=False,indent=2),encoding="utf-8")

def card_url(kw, cache):
    fn = CARD_MAP.get(kw)
    if not fn: return None
    if cache.get(fn): return cache[fn]
    fp = CARDS_DIR / fn
    if not fp.exists(): log(f"   ⚠ 找不到角色卡 {fn}"); return None
    log(f"   ⬆ 上傳角色卡 {fn}")
    c,o,e = run_skill(["upload","--file",str(fp)]); j=last_json(o)
    if j and j.get("url"): cache[fn]=j["url"]; save_cache(cache); return j["url"]
    log(f"   ⚠ 上傳失敗 {fn}"); return None

def clean_title(t):
    t = t.split("──",1)[-1] if "──" in t else t
    return re.sub(r"[^一-鿿0-9A-Za-z]","",t) or "panel"

def parse_md(md):
    txt = md.read_text(encoding="utf-8")
    parts = re.split(r"(?m)^##\s*■\s*Panel\s*(\d+)\s*/\s*\d+\s*──?\s*(.*)$", txt)
    out=[]
    for i in range(1,len(parts),3):
        num=int(parts[i]); title=parts[i+1].strip(); body=parts[i+2]
        m=re.search(r"@cards[：:]\s*(.+)",body)
        cards=re.findall(r"@([一-鿿A-Za-z0-9]+)",m.group(1)) if m else []
        header = body.split("貼入",1)[0] if "貼入" in body else ""
        fm = re.search(r"(?:檔名|存檔|圖名|檔案名)[：:]\s*([^\n]+)", header)
        fname = re.sub(r"\.png$","",fm.group(1).strip(),flags=re.I) if fm else ""
        prompt = body.split("貼入",1)[1].lstrip("　 —-\n") if "貼入" in body else body
        prompt = re.sub(r"(?m)^\s*-{3,}\s*$","",prompt).strip()
        out.append({"num":num,"title":title,"cards":cards,"prompt":prompt,"fname":fname})
    return out

def pian_no(name):
    m=re.search(r"第(\d+)篇",name); return int(m.group(1)) if m else 0

def gen_panel(pian, p, img_dir, cache, model):
    n=p["num"]
    if (list(img_dir.glob(f"*張{n:02d}_*.png")) or list(img_dir.glob(f"*張{n:02d}.png"))
            or list(img_dir.glob(f"*12之{n}_*.png"))):
        log(f"   ⏭ 張{n:02d} 已有，跳過"); return "skip"
    urls=[u for u in (card_url(k,cache) for k in p["cards"]) if u]
    args=["--timeout","1800","chat","--prompt",p["prompt"],"--prefer-models",json.dumps({"IMAGE":[model]}),
          "--json","--download","--output-dir",str(img_dir)]
    if urls: args+=["--attachments"]+urls
    log(f"   🎨 生成 張{n:02d}（{len(urls)}張參考卡：{'＋'.join(p['cards']) or '無'}）…")
    j=None
    for attempt in range(4):
        c,o,e=run_skill(args); j=last_json(o)
        if j: break
        err=(e or o or "").strip(); low=err.lower()
        if ("rate limit" in low or "429" in low or "slow down" in low or "too many" in low
                or "concurrent" in low) and attempt<5:
            wait=90*(attempt+1)
            why="同時只能一個任務" if "concurrent" in low else "被限速"
            log(f"   ⏳ 張{n:02d} {why}，等 {wait} 秒再自動重試（第 {attempt+1} 次）…")
            time.sleep(wait); continue
        try: (SELF_DIR/"last_error.txt").write_text(err, encoding="utf-8")
        except Exception: pass
        tail=err.splitlines()[-1] if err else "(無輸出)"
        log(f"   ❌ 張{n:02d} 失敗：{tail[:180]}")
        return "fail"
    if j.get("final_status")=="pending_confirmation":
        log(f"   ⏸ 張{n:02d} 需付費確認，略過"); return "fail"
    dl=j.get("downloaded") or []
    if not dl:
        log(f"   ⚠ 張{n:02d} 沒出圖：{j.get('warning') or j.get('agent_message') or '可能被審查'}"); return "fail"
    base = p.get("fname") or f"第{pian}篇_張{n:02d}_{clean_title(p['title'])}"
    base = re.sub(r'[\\/:*?"<>|]+', "", base)
    src=Path(dl[0]["local_path"]); dst=img_dir/f"{base}.png"
    try:
        if src.exists(): src.replace(dst)
        log(f"   ✅ 已存 {dst.name}")
    except Exception as ex: log(f"   ✅ 下載於 {src}（改名失敗 {ex}）")
    return "ok"

def _pre():
    if not have_keys(): log("❌ 還沒設定金鑰，請先在『設定金鑰』貼上 AK/SK 並儲存。"); return False
    if not Path(SKILL).exists(): log("❌ 找不到 agent_skill.py，請先按『下載生圖程式』。"); return False
    return True

def generate(posts, model, mode):
    try:
        STATE["running"]=True; STATE["done"]=STATE["fail"]=STATE["skip"]=0
        if not _pre(): return
        log(f"➡ 模式：{'無限(免費,排隊)' if mode=='unlimited' else '快速(用餘額,不排隊)'}；引擎：{model}")
        run_skill(["set-mode","--unlimited" if mode=="unlimited" else "--fast"])
        cache=load_cache()
        if not posts: log("⚠ 這個範圍內沒有可生的篇（要有 生成命令_LoveArt.md）。")
        for folder in posts:
            md=folder/"生成命令_LoveArt.md"
            if not md.exists(): continue
            pian=pian_no(folder.name); img=folder/"圖片"; img.mkdir(exist_ok=True)
            panels=parse_md(md); STATE["current"]=folder.name
            log(f"📖 {folder.name}（共 {len(panels)} 格）")
            for p in panels:
                r=gen_panel(pian,p,img,cache,model); STATE[{"ok":"done","skip":"skip","fail":"fail"}[r]]+=1
                if r in ("ok","fail"): time.sleep(SLEEP_SEC)
        log(f"🎉 完成！新生 {STATE['done']}、已存 {STATE['skip']}、失敗 {STATE['fail']}")
    except Exception as ex:
        log(f"❌ 發生錯誤：{ex}")
    finally:
        STATE["running"]=False; STATE["current"]=""

def upload_all_cards():
    try:
        STATE["running"]=True
        if not _pre(): return
        log("⬆ 開始先上傳所有角色卡…")
        cache=load_cache(); seen=set()
        for kw,fn in CARD_MAP.items():
            if fn in seen: continue
            seen.add(fn); card_url(kw,cache)
        log(f"✅ 角色卡上傳完成（已快取 {len(cache)} 張，之後生圖直接用）")
    except Exception as ex:
        log(f"❌ 上傳角色卡錯誤：{ex}")
    finally:
        STATE["running"]=False

def list_posts():
    if not POSTS_DIR.exists(): return []
    out=[]
    for f in sorted(POSTS_DIR.iterdir()):
        if f.is_dir() and (f/"生成命令_LoveArt.md").exists():
            imgs=len(list((f/"圖片").glob("*.png"))) if (f/"圖片").exists() else 0
            out.append({"name":f.name,"pian":pian_no(f.name),"imgs":imgs})
    return out

def list_images(post):
    d=POSTS_DIR/post/"圖片"
    if not d.exists(): return []
    return sorted([p.name for p in d.glob("*.png")])

def set_schedule(on):
    if on:
        cmd=f'\"{sys.executable}\" \"{Path(__file__).resolve()}\" --headless'
        subprocess.run(["schtasks","/create","/tn","地藏_LoveArt自動生圖","/tr",cmd,"/sc","daily","/st","01:30","/f"],capture_output=True,text=True)
    else:
        subprocess.run(["schtasks","/delete","/tn","地藏_LoveArt自動生圖","/f"],capture_output=True,text=True)

def schedule_on():
    r=subprocess.run(["schtasks","/query","/tn","地藏_LoveArt自動生圖"],capture_output=True,text=True)
    return r.returncode==0

OPTS = "".join(f'<option value="{v}">{k}</option>' for k,v in MODELS.items())

PAGE = """<!doctype html><html lang=zh-Hant><head><meta charset=utf-8>
<meta name=viewport content="width=device-width,initial-scale=1"><title>地藏經漫畫 自動生圖</title>
<style>
body{font-family:"Microsoft JhengHei",sans-serif;margin:0;background:#faf7f2;color:#333}
header{background:#6b4e8e;color:#fff;padding:14px 20px;font-size:20px}
.wrap{max-width:1000px;margin:0 auto;padding:16px}
.card{background:#fff;border-radius:12px;padding:16px;margin:14px 0;box-shadow:0 2px 8px #0001}
h2{margin:0 0 10px;font-size:16px;color:#6b4e8e}
input,select{padding:8px;border:1px solid #ccc;border-radius:8px;font-size:14px}
input.key{width:340px;max-width:90%}input.num{width:70px;text-align:center}
button{background:#6b4e8e;color:#fff;border:0;border-radius:8px;padding:10px 18px;font-size:15px;cursor:pointer;margin:4px}
button.gray{background:#999}button.green{background:#2a9d5c}button:disabled{opacity:.5;cursor:not-allowed}
#log{background:#1e1e1e;color:#b6e3b6;font-family:monospace;font-size:12px;height:200px;overflow:auto;padding:10px;border-radius:8px;white-space:pre-wrap}
.gal{display:flex;flex-wrap:wrap;gap:8px}.gal img{width:150px;height:150px;object-fit:cover;border-radius:8px;border:1px solid #ddd}
.gal figure{margin:0;text-align:center;font-size:11px;width:150px}
.tag{display:inline-block;background:#eee;border-radius:6px;padding:2px 8px;font-size:12px;margin-left:6px}
.row{margin:8px 0}small{color:#888}label{margin-right:14px}
</style></head><body>
<header>🪷 地藏經漫畫 — LoveArt 自動生圖介面</header>
<div class=wrap>
<div class=card>
<h2>① 設定金鑰（只需一次，存你電腦、不上傳）</h2>
<div><input class=key id=ak placeholder="LoveArt access_key（ak_...）"></div>
<div style=margin-top:6px><input class=key id=sk placeholder="LoveArt secret_key（sk_...）" type=password></div>
<button onclick=saveKeys()>儲存金鑰</button> <span id=keystat></span>
<div><small>LoveArt 頭像 → Lovart 龙虾 → AK/SK Management 拿。只存你電腦。</small></div>
<div style=margin-top:8px><button class=gray onclick=dl()>（沒裝過才按）下載生圖程式</button> <span id=dlstat></span></div>
</div>

<div class=card>
<h2>② 生圖設定</h2>
<div class=row><b>範圍：</b>從 <input class=num id=pfrom value=17> 篇 到 <input class=num id=pto value=50> 篇
  <small>（只生「有指令檔 生成命令_LoveArt.md」的篇；已生過的自動跳過）</small></div>
<div class=row><b>引擎：</b><select id=model>__OPTS__</select></div>
<div class=row><b>模式：</b>
  <label><input type=radio name=mode value=unlimited checked> 無限模式（免費，排隊，半夜快）</label>
  <label><input type=radio name=mode value=fast> 快速模式（用餘額，不排隊）</label>
</div>
<div class=row>
  <button class=green onclick=uploadCards()>先上傳角色卡</button>
  <button onclick=run()>▶ 開始生圖</button>
  <span id=runstat class=tag></span>
</div>
<div><small>「先上傳角色卡」非必要——生圖時也會自動上傳；先按可預先暖機、測連線。</small></div>
<div id=log style=margin-top:10px></div>
</div>

<div class=card>
<h2>③ 每晚自動跑 <span id=schtag class=tag></span></h2>
<button onclick=sched(1)>🌙 開啟每晚01:30自動</button> <button class=gray onclick=sched(0)>關閉自動</button>
<div><small>自動跑時電腦要開著。半夜跑用「目前範圍/設定」。</small></div>
</div>

<div class=card>
<h2>④ 看生出來的圖</h2>
<select id=post></select>
<div class=gal id=gallery style=margin-top:10px><small>選一篇看圖。</small></div>
</div>
</div>
<script>
async function api(u,opt){let r=await fetch(u,opt);return r.json()}
function mode(){return document.querySelector('input[name=mode]:checked').value}
async function refresh(){
  let s=await api('/api/status');
  document.getElementById('log').textContent=s.log.join('\\n');
  document.getElementById('log').scrollTop=1e9;
  document.getElementById('runstat').textContent=s.running?('執行中… '+s.current):('閒置 ✓新'+s.done+' 跳'+s.skip+' 失'+s.fail);
  document.getElementById('keystat').textContent=s.haveKeys?'✓ 已設定':'⚠ 尚未設定';
  document.getElementById('schtag').textContent=s.sched?'(已開啟)':'(未開)';
  let sel=document.getElementById('post');
  if(sel.options.length===0){ sel.innerHTML=s.posts.map(p=>`<option value="${p.name}">${p.name}（已${p.imgs}張）</option>`).join(''); }
}
async function saveKeys(){let r=await api('/api/keys',{method:'POST',body:JSON.stringify({ak:ak.value,sk:sk.value})});document.getElementById('keystat').textContent=r.ok?'✓ 已儲存':'✗ 失敗';refresh();}
async function dl(){document.getElementById('dlstat').textContent='下載中…';let r=await api('/api/download',{method:'POST'});document.getElementById('dlstat').textContent=r.ok?'✓ 已就緒':'✗ '+r.msg;}
async function run(){await api('/api/run',{method:'POST',body:JSON.stringify({from:pfrom.value,to:pto.value,model:model.value,mode:mode()})});refresh();}
async function uploadCards(){await api('/api/upload_cards',{method:'POST',body:'{}'});refresh();}
async function sched(on){await api('/api/schedule',{method:'POST',body:JSON.stringify({on:on,from:pfrom.value,to:pto.value,model:model.value,mode:mode()})});refresh();}
async function gallery(){let p=document.getElementById('post').value;if(!p)return;
  let r=await api('/api/images?post='+encodeURIComponent(p));
  document.getElementById('gallery').innerHTML=r.images.length?r.images.map(n=>`<figure><img src="/img?post=${encodeURIComponent(p)}&name=${encodeURIComponent(n)}"><figcaption>${n}</figcaption></figure>`).join(''):'<small>這篇還沒有圖。</small>';
}
var ak=document.getElementById('ak'),sk=document.getElementById('sk'),pfrom=document.getElementById('pfrom'),pto=document.getElementById('pto'),model=document.getElementById('model');
document.getElementById('post').addEventListener('change',gallery);
setInterval(refresh,2000);refresh();
</script></body></html>""".replace("__OPTS__", OPTS)

class H(BaseHTTPRequestHandler):
    def _send(self,code,ctype,body):
        self.send_response(code);self.send_header("Content-Type",ctype)
        self.send_header("Content-Length",str(len(body)));self.end_headers();self.wfile.write(body)
    def _json(self,obj): self._send(200,"application/json; charset=utf-8",json.dumps(obj,ensure_ascii=False).encode())
    def log_message(self,*a): pass
    def do_GET(self):
        pu=urllib.parse.urlparse(self.path); q=urllib.parse.parse_qs(pu.query)
        if pu.path=="/": self._send(200,"text/html; charset=utf-8",PAGE.encode())
        elif pu.path=="/api/status":
            with LOCK: lg=list(STATE["log"])
            self._json({"running":STATE["running"],"log":lg,"current":STATE["current"],
                        "done":STATE["done"],"skip":STATE["skip"],"fail":STATE["fail"],
                        "posts":list_posts(),"haveKeys":have_keys(),"sched":schedule_on()})
        elif pu.path=="/api/images":
            self._json({"images":list_images(q.get("post",[""])[0])})
        elif pu.path=="/img":
            post=q.get("post",[""])[0]; name=q.get("name",[""])[0]
            fp=(POSTS_DIR/post/"圖片"/name).resolve()
            if str(fp).startswith(str(POSTS_DIR.resolve())) and fp.exists():
                self._send(200,"image/png",fp.read_bytes())
            else: self._send(404,"text/plain",b"no")
        else: self._send(404,"text/plain",b"no")
    def do_POST(self):
        ln=int(self.headers.get("Content-Length") or 0); raw=self.rfile.read(ln) if ln else b"{}"
        try: data=json.loads(raw.decode() or "{}")
        except: data={}
        path=urllib.parse.urlparse(self.path).path
        if path=="/api/keys":
            try: save_keys(data.get("ak",""),data.get("sk","")); load_keys(); self._json({"ok":True})
            except Exception as e: self._json({"ok":False,"msg":str(e)})
        elif path=="/api/run":
            if STATE["running"]: self._json({"ok":False,"msg":"執行中"}); return
            try: pf=int(data.get("from") or 0)
            except: pf=0
            try: pt=int(data.get("to") or 9999)
            except: pt=9999
            model=data.get("model") or MODEL_DEFAULT
            md=data.get("mode") or "unlimited"
            posts=[POSTS_DIR/p["name"] for p in list_posts() if pf<=p["pian"]<=pt]
            threading.Thread(target=generate,args=(posts,model,md),daemon=True).start()
            self._json({"ok":True})
        elif path=="/api/upload_cards":
            if STATE["running"]: self._json({"ok":False,"msg":"執行中"}); return
            threading.Thread(target=upload_all_cards,daemon=True).start(); self._json({"ok":True})
        elif path=="/api/schedule":
            set_schedule(bool(data.get("on"))); self._json({"ok":True})
        elif path=="/api/download":
            try:
                urllib.request.urlretrieve("https://raw.githubusercontent.com/lovartai/lovart-skill/main/skills/lovart-skill/agent_skill.py", SKILL)
                self._json({"ok":True})
            except Exception as e: self._json({"ok":False,"msg":str(e)})
        else: self._send(404,"text/plain",b"no")

def main():
    if "--headless" in sys.argv:
        load_keys()
        posts=[POSTS_DIR/p["name"] for p in list_posts()]
        generate(posts, MODEL_DEFAULT, "unlimited"); return
    srv=ThreadingHTTPServer(("127.0.0.1",PORT),H)
    print(f"🪷 生圖介面已啟動：http://127.0.0.1:{PORT}/")
    try: webbrowser.open(f"http://127.0.0.1:{PORT}/")
    except: pass
    srv.serve_forever()

if __name__=="__main__":
    main()
