#!/usr/bin/env python3

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "_tools" / "index.src.md"
DST = ROOT / "index.md"


def _shift(text, start, end, target):
    return "".join(
        chr(ord(c) - start + target) if start <= ord(c) <= end else c for c in text
    )


def tex_to_mathml(tex, display):
    delim = "$$" if display else "$"
    html = subprocess.run(
        ["pandoc", "--mathml", "-f", "markdown", "-t", "html"],
        input=f"{delim}{tex}{delim}",
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    match = re.search(r"<math.*</math>", html, re.S)
    if match is None:
        sys.exit(f"pandoc could not convert: {tex}")
    m = match.group(0)
    m = re.sub(r"<annotation[^>]*>.*?</annotation>", "", m, flags=re.S)
    m = m.replace("<semantics>", "").replace("</semantics>", "")
    m = m.replace('<mstyle mathvariant="double-struck"><mn>1</mn></mstyle>', "<mn>𝟙</mn>")
    m = re.sub(
        r'<mstyle mathvariant="normal"><mi>(.)</mi></mstyle>',
        r'<mi mathvariant="normal">\1</mi>',
        m,
    )
    m = _shift(m, 0x1D41A, 0x1D433, 0x1D482)
    m = _shift(m, 0x1D400, 0x1D419, 0x1D468)
    m = m.replace("<mo>*</mo>", "<mo>∗</mo>").replace("*", "&#42;")
    m = m.replace("|", "&#124;")
    m = re.sub(r"<mo>([A-Za-z][A-Za-z-]+)</mo>", r"<mi>\1</mi>", m)
    m = re.sub(r">\s+<", "><", m)
    return m.replace("\n", " ")


def render(text):
    out = []
    for i, chunk in enumerate(re.split(r"(^```.*?^```)", text, flags=re.S | re.M)):
        if i % 2:
            out.append(chunk)
            continue
        chunk = re.sub(
            r"\$\$(.+?)\$\$",
            lambda g: '<div class="equation">'
            + tex_to_mathml(g.group(1).strip(), True)
            + "</div>",
            chunk,
            flags=re.S,
        )
        chunk = re.sub(
            r"(?<![\\$])\$([^$\n]+?)\$",
            lambda g: '<span class="math">' + tex_to_mathml(g.group(1), False) + "</span>",
            chunk,
        )
        out.append(chunk)
    return "".join(out)


def main():
    text = SRC.read_text()
    front, body = re.match(r"(---\n.*?\n---\n)(.*)", text, re.S).groups()
    DST.write_text(front + render(body))
    print(f"wrote {DST.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
