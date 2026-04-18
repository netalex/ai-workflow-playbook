#!/usr/bin/env python3
"""
Builds small CSV and Markdown indexes for a refined chunk corpus.

The outputs help with manual QA and retrieval tuning.

Current outputs:
- chunk-summary.csv
- duplicate-titles.csv
- chunk-summary.md
"""

from __future__ import annotations

import argparse
import csv
import re
from collections import Counter
from pathlib import Path

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
KV_RE = re.compile(r"^([A-Za-z0-9_]+):\s*(.+?)\s*$", re.MULTILINE)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_frontmatter(text: str) -> dict[str, str]:
    match = FRONTMATTER_RE.match(text)
    if not match:
        return {}
    block = match.group(1)
    result: dict[str, str] = {}
    for item in KV_RE.finditer(block):
        key = item.group(1).strip()
        value = item.group(2).strip().strip('"')
        result[key] = value
    return result


def strip_frontmatter(text: str) -> str:
    match = FRONTMATTER_RE.match(text)
    if not match:
        return text
    return text[match.end():].lstrip()


def write_csv(path: Path, rows: list[dict], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def write_md(path: Path, lines: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()

    input_dir: Path = args.input_dir
    output_dir: Path = args.output_dir

    if not input_dir.exists():
        raise FileNotFoundError(f"Input directory not found: {input_dir}")

    summary_rows: list[dict] = []
    title_counter: Counter[str] = Counter()

    for path in sorted(input_dir.rglob("*.md")):
        text = read_text(path)
        frontmatter = parse_frontmatter(text)
        body = strip_frontmatter(text)
        title = frontmatter.get("chunk_id", path.stem)

        title_counter[title] += 1
        summary_rows.append(
            {
                "file": path.name,
                "chunk_id": frontmatter.get("chunk_id", ""),
                "source_file": frontmatter.get("source_file", ""),
                "estimated_tokens": frontmatter.get("estimated_tokens", ""),
                "image_count": frontmatter.get("image_count", "0"),
                "caption_count": frontmatter.get("caption_count", "0"),
                "body_chars": len(body),
            }
        )

    duplicate_rows = [
        {"title_or_chunk_id": key, "count": count}
        for key, count in sorted(title_counter.items(), key=lambda item: (-item[1], item[0]))
        if count > 1
    ]

    write_csv(
        output_dir / "chunk-summary.csv",
        summary_rows,
        ["file", "chunk_id", "source_file", "estimated_tokens", "image_count", "caption_count", "body_chars"],
    )

    write_csv(
        output_dir / "duplicate-titles.csv",
        duplicate_rows,
        ["title_or_chunk_id", "count"],
    )

    md_lines = [
        "# Chunk corpus summary",
        "",
        f"- chunk files: {len(summary_rows)}",
        f"- duplicate title keys: {len(duplicate_rows)}",
        "",
        "## Largest chunks by character count",
        "",
        "| File | Chunk ID | Body chars | Estimated tokens |",
        "| --- | --- | ---: | ---: |",
    ]

    for row in sorted(summary_rows, key=lambda item: int(item["body_chars"]), reverse=True)[:20]:
        md_lines.append(
            f"| {row['file']} | {row['chunk_id']} | {row['body_chars']} | {row['estimated_tokens']} |"
        )

    write_md(output_dir / "chunk-summary.md", md_lines)

    print(f"[OK] summary CSV: {output_dir / 'chunk-summary.csv'}")
    print(f"[OK] duplicates CSV: {output_dir / 'duplicate-titles.csv'}")
    print(f"[OK] summary MD: {output_dir / 'chunk-summary.md'}")


if __name__ == "__main__":
    main()
