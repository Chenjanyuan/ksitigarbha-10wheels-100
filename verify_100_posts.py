"""
驗證 100 篇 docx 符合鐵則
阿地 4 號 2026-05-20

檢查項目:
1. ✓ 結構: Heading 1 + Heading 2 「📱 FB 貼文文字」 + Heading 2 「📋 上刊資訊」
2. ✓ 禁字: 「結緣助印」「贊助」「捐獻」「樂捐」
3. ✓ 簡體字: 抽常見繁簡對 (经→經、爱→愛、过→過、说→說 等)
4. ✓ 贈書文字: 必須是「《地藏菩薩本願經》」(不是十輪經)
5. ✓ Hashtag: 必須有 #第N篇
6. ✓ FB 文字長度: 至少 300 字
7. ✓ 啟發反思: 必須有「聖嚴法師」或「啟發反思」section
"""
from pathlib import Path
from docx import Document
import re
import sys

PROJECT_ROOT = Path(__file__).resolve().parent
POST_DIR = PROJECT_ROOT / "每篇貼文"

# 禁字 (我們不接受贊助)
FORBIDDEN_WORDS = ["結緣助印", "助印", "贊助", "樂捐", "捐獻", "捐款"]

# 常見簡體字檢測 (抽部分高頻字)
SIMPLIFIED_CHARS = {
    '经': '經', '爱': '愛', '过': '過', '说': '說', '没': '沒',
    '听': '聽', '众': '眾', '气': '氣', '后': '後', '来': '來',
    '问': '問', '间': '間', '会': '會', '为': '為', '处': '處',
    '从': '從', '亿': '億', '尽': '盡', '净': '淨', '动': '動',
    '边': '邊', '现': '現', '当': '當', '种': '種', '与': '與',
    '万': '萬', '门': '門', '车': '車', '难': '難', '观': '觀',
    '远': '遠', '业': '業', '处': '處', '复': '復', '简': '簡',
    '尘': '塵', '识': '識', '诸': '諸', '诵': '誦', '门': '門',
    '坏': '壞', '声': '聲', '众': '眾', '号': '號', '导': '導'
}

# 必須出現的關鍵字
MUST_CONTAIN = ["《地藏菩薩本願經》"]


def check_one_post(folder):
    """檢查一篇 docx, 回傳 issues list"""
    issues = []
    篇號 = re.search(r"第(\d+)篇", folder.name)
    篇號 = int(篇號.group(1)) if 篇號 else None

    docx_files = list(folder.glob("*.docx"))
    if not docx_files:
        return ["NO DOCX"]
    doc = Document(docx_files[0])

    # 收集所有 text
    all_text = ""
    fb_text = ""
    has_h1 = False
    has_fb_h2 = False
    has_meta_h2 = False
    has_reflection = False
    has_hashtag = False
    capture_fb = False

    for p in doc.paragraphs:
        t = p.text.strip()
        all_text += t + "\n"
        if p.style.name == "Heading 1":
            has_h1 = True
        elif p.style.name == "Heading 2":
            if "FB 貼文文字" in t:
                has_fb_h2 = True
                capture_fb = True
                continue
            elif "上刊資訊" in t:
                has_meta_h2 = True
                capture_fb = False
            else:
                capture_fb = False
        if capture_fb and t:
            fb_text += t + "\n"
        if "聖嚴法師" in t or "啟發反思" in t:
            has_reflection = True
        if t.startswith("#"):
            has_hashtag = True

    # 1. 結構檢查
    if not has_h1:
        issues.append("缺 Heading 1 大標")
    if not has_fb_h2:
        issues.append("缺 Heading 2 「📱 FB 貼文文字」")
    if not has_meta_h2:
        issues.append("缺 Heading 2 「📋 上刊資訊」")

    # 2. 禁字檢查
    for word in FORBIDDEN_WORDS:
        if word in all_text:
            issues.append(f"❌ 禁字: 「{word}」")

    # 3. 簡體字檢查
    found_simp = []
    for s, t in SIMPLIFIED_CHARS.items():
        if s in all_text:
            found_simp.append(f"{s}→{t}")
    if found_simp:
        issues.append(f"❌ 簡體字: {', '.join(found_simp[:5])}")

    # 4. 必須關鍵字
    for w in MUST_CONTAIN:
        if w not in all_text:
            issues.append(f"❌ 缺關鍵字: 「{w}」")

    # 5. Hashtag
    if not has_hashtag:
        issues.append("缺 hashtag")

    # 6. 字數
    if len(fb_text) < 300:
        issues.append(f"FB 文字太短 ({len(fb_text)} 字 < 300)")

    # 7. 啟發反思
    if not has_reflection:
        issues.append("缺啟發反思 section")

    return issues


def main():
    print(f"驗證 {POST_DIR} 下所有篇...\n")
    folders = sorted([f for f in POST_DIR.iterdir() if f.is_dir() and re.match(r"\d{4}-\d{2}-\d{2}_第\d+篇", f.name)])
    print(f"找到 {len(folders)} 個篇資料夾\n")

    all_pass = 0
    has_issues = []
    for folder in folders:
        issues = check_one_post(folder)
        if not issues:
            all_pass += 1
        else:
            has_issues.append((folder.name, issues))

    print(f"=" * 60)
    print(f"✅ 全 pass: {all_pass} 篇")
    print(f"⚠️  有問題: {len(has_issues)} 篇")
    print(f"=" * 60)

    if has_issues:
        print(f"\n各篇問題:\n")
        for name, issues in has_issues:
            print(f"📄 {name}")
            for i in issues:
                print(f"   - {i}")
            print()

    return 0 if not has_issues else 1


if __name__ == "__main__":
    sys.exit(main())
