"""Split UI/BlackListFrames.xml into UI/Xml/*.xml and rewrite the main file with <Include/>."""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "UI" / "BlackListFrames.xml"
OUT_DIR = ROOT / "UI" / "Xml"

UI_WRAP_HEAD = (
    '<Ui xmlns="http://www.blizzard.com/wow/ui/" '
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
    'xsi:schemaLocation="http://www.blizzard.com/wow/ui/ FrameXML">\n'
)
UI_WRAP_TAIL = "</Ui>\n"


def main() -> None:
    lines = SRC.read_text(encoding="utf-8").splitlines(keepends=True)

    def sl(a: int, b: int) -> str:
        return "".join(lines[a - 1 : b])

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    chunks: list[tuple[str, int, int]] = [
        ("BlackListFrames_Virtual.xml", 17, 83),
        ("BlackListFrames_MainPanel.xml", 85, 458),
        ("BlackListFrames_Details.xml", 460, 680),
        ("BlackListFrames_LegacyOptions.xml", 682, 866),
        ("BlackListFrames_TopFrame.xml", 868, 877),
    ]

    for name, a, b in chunks:
        body = sl(a, b)
        (OUT_DIR / name).write_text(UI_WRAP_HEAD + body + UI_WRAP_TAIL, encoding="utf-8")

    head = "".join(lines[0:15])  # lines 1-15: <Ui> + scripts
    includes = (
        '\t<!-- Frame layout split for readability (see UI/Xml/). -->\n'
        '\t<Include file="UI\\Xml\\BlackListFrames_Virtual.xml" />\n'
        '\t<Include file="UI\\Xml\\BlackListFrames_MainPanel.xml" />\n'
        '\t<Include file="UI\\Xml\\BlackListFrames_Details.xml" />\n'
        '\t<Include file="UI\\Xml\\BlackListFrames_LegacyOptions.xml" />\n'
        '\t<Include file="UI\\Xml\\BlackListFrames_TopFrame.xml" />\n'
        "\n"
        "</Ui>\n"
    )
    SRC.write_text(head + includes, encoding="utf-8")
    print("OK:", SRC)


if __name__ == "__main__":
    main()
