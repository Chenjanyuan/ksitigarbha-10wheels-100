"""
Daemon v2: monitors _queue/ for tasks, calls Gemini API (with optional reference images), saves PNGs.
Task JSON format:
  {"out": "篇08/X.png", "prompt": "...", "ref_images": ["篇08/8-05.png", ...]}  # ref_images optional
"""
import sys, time, json
from pathlib import Path

try:
    from google import genai
    from PIL import Image
except ImportError:
    print("ERROR: pip install google-genai pillow")
    sys.exit(1)

PROJECT = Path(__file__).parent
api_key = (PROJECT / "gemini.txt").read_text(encoding='utf-8').strip()
client = genai.Client(api_key=api_key)
MODEL = "gemini-3-pro-image-preview"

QUEUE = PROJECT / "_queue"
DONE = PROJECT / "_done"
OUT = PROJECT / "_API生圖_2026-05-29"
QUEUE.mkdir(exist_ok=True)
DONE.mkdir(exist_ok=True)
OUT.mkdir(exist_ok=True)

print(f"[daemon v2] watching {QUEUE}")
print(f"[daemon v2] model: {MODEL}")
print(f"[daemon v2] supports ref_images now!")
print(f"[daemon v2] ready - waiting for tasks...")
sys.stdout.flush()

while True:
    try:
        tasks = sorted(QUEUE.glob("*.json"))
        for task_file in tasks:
            try:
                task = json.loads(task_file.read_text(encoding='utf-8'))
                name = task_file.stem
                prompt = task.get("prompt", "")
                out_rel = task.get("out", f"{name}.png")
                ref_paths = task.get("ref_images", [])
                out_path = OUT / out_rel
                out_path.parent.mkdir(parents=True, exist_ok=True)

                # 載入 ref images
                ref_imgs = []
                for rp in ref_paths:
                    full = OUT / rp if not (PROJECT / rp).is_absolute() else Path(rp)
                    full = OUT / rp
                    if not full.exists():
                        full = PROJECT / rp
                    if full.exists():
                        ref_imgs.append(Image.open(full))
                        print(f"  + ref: {full.name}")
                    else:
                        print(f"  ! ref missing: {rp}")

                print(f"\n[daemon] processing: {name} (refs: {len(ref_imgs)})")
                sys.stdout.flush()

                contents = ref_imgs + [prompt] if ref_imgs else prompt
                response = client.models.generate_content(
                    model=MODEL,
                    contents=contents,
                )
                saved = False
                for part in response.candidates[0].content.parts:
                    if part.inline_data:
                        out_path.write_bytes(part.inline_data.data)
                        print(f"[daemon] saved: {out_path.name} ({len(part.inline_data.data):,} bytes)")
                        sys.stdout.flush()
                        saved = True
                        break

                result = {"name": name, "ok": saved, "out": str(out_rel)}
                if not saved:
                    result["error"] = "no image returned"
                (DONE / f"{name}.json").write_text(json.dumps(result, ensure_ascii=False), encoding='utf-8')
                task_file.unlink()
            except Exception as e:
                print(f"[daemon] FAIL {task_file.name}: {e}")
                sys.stdout.flush()
                err = {"name": task_file.stem, "ok": False, "error": str(e)}
                (DONE / f"{task_file.stem}.json").write_text(json.dumps(err, ensure_ascii=False), encoding='utf-8')
                task_file.unlink()

        time.sleep(2)
    except KeyboardInterrupt:
        print("\n[daemon] stopped")
        break
