"""Test 6-08 with pure text prompt (no reference images yet)."""
import sys
from pathlib import Path

try:
    from google import genai
except ImportError:
    print("ERROR: pip install google-genai")
    sys.exit(1)

PROJECT = Path(__file__).parent
api_key = (PROJECT / "gemini.txt").read_text(encoding='utf-8').strip()
client = genai.Client(api_key=api_key)

prompt_text = """Studio Ghibli animation style (Spirited Away / Castle in the Sky), delicate gouache painting, warm saturated colors, rich natural details, soft light. Ancient India setting around 500 BC.

[Scene] Wide medium shot, eye-level, Hollywood/IMAX cinematic.

A golden wish-fulfilling jewel (luminous pearl) floats in mid-sky at center, emitting golden light. Treasures rain down from the jewel: gold coins, grain, herbs, pearls, fabric.

In foreground (below), 7 ancient India villagers gather to catch treasures:
- 3 Buddhist monks (shaved heads, orange robes, brown skin)
- 2 lay men (loincloths, headbands, brown skin)
- 2 lay women (colorful saris, brown skin, with one child jumping)
All have joyful satisfied expressions, hands reaching up.

Background: ancient India village open ground at dusk, distant misty mountains, light blue sky with golden warm clouds, bodhi tree on the right, simple thatched huts.

DO NOT draw Buddha. DO NOT draw any Bodhisattva figure. Only show the jewel as a symbol.

[Text in image - must be Traditional Chinese characters]
Narration box (top-left, no border, transparent background): 「佛陀第五個比方 — 地藏菩薩, 是一顆活的如意珠, 你心裡想什麼, 他就下什麼...」
Speech bubble (round bubble pointing to a satisfied woman): 「我想要的都有了! 謝謝地藏菩薩!」
Page number (bottom-right, white circle with black text): 8/12

[Format] 1:1 square, 2K resolution, no border, manga panel drawn to edge of image. NOT realistic photo, NOT 3D render, NOT Chinese ink painting."""

print("[1/2] Calling Gemini Nano Banana Pro (text only, ~10-30s)...")
try:
    response = client.models.generate_content(
        model="gemini-3-pro-image-preview",
        contents=prompt_text,
    )
    out_dir = PROJECT / "_API生圖_2026-05-29" / "篇06"
    out_dir.mkdir(parents=True, exist_ok=True)
    saved = False
    for part in response.candidates[0].content.parts:
        if part.inline_data:
            out_path = out_dir / "6-08_test.png"
            out_path.write_bytes(part.inline_data.data)
            print(f"\n[2/2] SUCCESS!")
            print(f"  Saved: {out_path}")
            print(f"  Size: {len(part.inline_data.data):,} bytes")
            saved = True
        elif part.text:
            print(f"\n  Model text: {part.text[:300]}")
    if not saved:
        print("\n  FAIL: no image returned")
        print(f"  Full response: {response}")
except Exception as e:
    print(f"\n  FAIL ({type(e).__name__}): {e}")
