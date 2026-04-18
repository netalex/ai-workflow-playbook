#!/usr/bin/env python3
"""
Refines a first-pass chunk corpus.

This script applies small, predictable cleanups:
- normalizes spacing
- preserves frontmatter
- extracts image references and captions
- skips empty or trivial chunks
- adds lightweight metadata

The goal is not to hide the source.
The goal is to improve retrieval quality and make manual QA easier.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
IMAGE_MD_RE = re.compile(r"!\[[^\]]*\]\(([^)]+)\)")
HTML_IMG_RE = re.compile(r'<img\b[^>]*\bsrc="([^"]+)"[^>]*>', re.IGNORECASE)
FIGCAPTION_RE = re.compile(r"<figcaption>(.*?)</figcaption>", re.IGNORECASE | re.DOTALL)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8", newline="\n")


def split_frontmatter(text: str) -> tuple[str, str]:
    """Return frontmatter block and body separately."""
    match = FRONTMATTER_RE.match(text)
    if not match:
        return "", text
    return text[: match.end()], text[match.end():]


def normalize_body(text: str) -> str:
    """Apply small formatting cleanups without changing document meaning."""
    lines = [line.rstrip() for line in text.splitlines()]
    cleaned = "\n".join(lines)
    cleaned = re.sub(r"\n{3,}", "\n\n", cleaned).strip()
    return cleaned + "\n"


def extract_images(text: str) -> list[str]:
    refs = []
    refs.extend(IMAGE_MD_RE.findall(text))
    refs.extend(HTML_IMG_RE.findall(text))
    deduped = []
    seen = set()
    for item in refs:
        if item not in seen:
            seen.add(item)
            deduped.append(item)
    return deduped


def extract_captions(text: str) -> list[str]:
    raw = FIGCAPTION_RE.findall(text)
    result = []
    for item in raw:
        item = re.sub(r"<[^>]+>", "", item)
        item = re.sub(r"\s+", " ", item).strip()
        if item:
            result.append(item)
    return result


def append_metadata(frontmatter: str, image_count: int, caption_count: int) -> str:
    """Append simple refinement metadata before the frontmatter closes."""
    if not frontmatter:
        return frontmatter

    return frontmatter.replace(
        "---\n\n",
        f"image_count: {image_count}\ncaption_count: {caption_count}\nrefined: true\n---\n\n",
        1,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()

    input_dir: Path = args.input_dir
    output_dir: Path = args.output_dir

    if not input_dir.exists():
        raise FileNotFoundError(f"Input directory not found: {input_dir}")

    count_written = 0
    for path in sorted(input_dir.rglob("*.md")):
        text = read_text(path)
        frontmatter, body = split_frontmatter(text)
        body = normalize_body(body)

        # Skip chunks that are too small to be useful in retrieval.
        if len(body.strip()) < 40:
            print(f"[SKIP] tiny chunk: {path.name}")
            continue

        images = extract_images(body)
        captions = extract_captions(body)

        refined_frontmatter = append_metadata(frontmatter, len(images), len(captions))
        output_path = output_dir / path.name
        write_text(output_path, refined_frontmatter + body)
        count_written += 1

    print(f"[OK] refined chunks written: {count_written}")


if __name__ == "__main__":
    main()
