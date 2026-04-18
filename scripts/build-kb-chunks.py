#!/usr/bin/env python3
"""
Builds a first-pass chunk corpus from normalized Markdown documents.

This script is deliberately conservative:
- it chunks only on heading boundaries
- it writes one markdown file per chunk
- it writes a manifest CSV for later review

The purpose is not to be magically smart.
The purpose is to create a predictable, reviewable starting point for retrieval.

Example:
    python scripts/build-kb-chunks.py \
        --input-dir ./documents-to-ingest/normalized \
        --output-dir ./documents-to-ingest/work/chunks \
        --manifest-path ./documents-to-ingest/work/chunk-manifest.csv
"""

from __future__ import annotations

import argparse
import csv
import re
import unicodedata
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List

HEADING_RE = re.compile(r"^(#{1,6})\s*(.*?)\s*$")
SKIP_TITLES = {"index", "table of contents", "document history", "indice"}


@dataclass
class Chunk:
    """Represents one extracted chunk before it is written to disk."""
    source_file: Path
    title: str
    level: int
    start_line: int
    heading_path: List[str]
    body: str


def slugify(text: str) -> str:
    """Convert an arbitrary title into a stable filename fragment."""
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-{2,}", "-", text).strip("-")
    return text or "untitled"


def estimate_tokens(text: str) -> int:
    """A very rough token estimate used only for human orientation."""
    return max(1, round(len(text) / 4))


def write_text(path: Path, content: str) -> None:
    """Write UTF-8 text with LF line endings."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8", newline="\n")


def parse_markdown(path: Path, split_levels: set[int]) -> list[Chunk]:
    """
    Parse a markdown file and split it into chunks at the requested heading levels.

    The algorithm is intentionally simple and reviewable:
    - maintain a heading stack
    - start a new chunk when a heading of the selected level appears
    - preserve the heading line in the body
    """
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    chunks: list[Chunk] = []
    heading_stack: list[tuple[int, str]] = []

    current_title: str | None = None
    current_level: int | None = None
    current_start_line: int | None = None
    current_path: list[str] = []
    current_body: list[str] = []

    def flush() -> None:
        nonlocal current_title, current_level, current_start_line, current_path, current_body
        if not current_title:
            return

        body = "\n".join(current_body).strip()
        if body:
            chunks.append(
                Chunk(
                    source_file=path,
                    title=current_title,
                    level=int(current_level),
                    start_line=int(current_start_line),
                    heading_path=list(current_path),
                    body=body,
                )
            )

        current_title = None
        current_level = None
        current_start_line = None
        current_path = []
        current_body = []

    for index, line in enumerate(lines, start=1):
        match = HEADING_RE.match(line)
        if match:
            level = len(match.group(1))
            title = (match.group(2) or "").strip()

            while heading_stack and heading_stack[-1][0] >= level:
                heading_stack.pop()

            if title:
                heading_stack.append((level, title))

            if level in split_levels and title:
                flush()

                if title.lower() in SKIP_TITLES:
                    continue

                current_title = title
                current_level = level
                current_start_line = index
                current_path = [t for _, t in heading_stack]
                current_body = [line]
                continue

        if current_title:
            current_body.append(line)

    flush()
    return chunks


def build_frontmatter(chunk_id: str, chunk: Chunk) -> str:
    """Build a small YAML frontmatter block for each chunk file."""
    heading_path = " > ".join(chunk.heading_path)
    tokens = estimate_tokens(chunk.body)

    return (
        "---\n"
        f'chunk_id: "{chunk_id}"\n'
        f'source_file: "{chunk.source_file.as_posix()}"\n'
        f"source_start_line: {chunk.start_line}\n"
        f"source_heading_level: {chunk.level}\n"
        f'source_heading_path: "{heading_path}"\n'
        f'estimated_tokens: {tokens}\n'
        'status: "draft"\n'
        "---\n\n"
    )


def write_chunks(output_dir: Path, chunks: Iterable[Chunk]) -> list[dict[str, str | int]]:
    """
    Write chunk markdown files and return manifest rows.

    The manifest is later used by refinement and QA steps.
    """
    manifest_rows: list[dict[str, str | int]] = []
    for index, chunk in enumerate(chunks, start=1):
        chunk_id = f"CH-{index:04d}"
        filename = f"{chunk_id}-{slugify(chunk.title)}.md"
        path = output_dir / filename

        write_text(path, build_frontmatter(chunk_id, chunk) + chunk.body.strip() + "\n")

        manifest_rows.append(
            {
                "chunk_id": chunk_id,
                "title": chunk.title,
                "source_file": chunk.source_file.as_posix(),
                "source_start_line": chunk.start_line,
                "heading_level": chunk.level,
                "heading_path": " > ".join(chunk.heading_path),
                "estimated_tokens": estimate_tokens(chunk.body),
                "relative_path": path.as_posix(),
            }
        )

    return manifest_rows


def write_manifest(path: Path, rows: list[dict[str, str | int]]) -> None:
    """Write the manifest CSV used by later pipeline steps."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
      writer = csv.DictWriter(
          handle,
          fieldnames=[
              "chunk_id",
              "title",
              "source_file",
              "source_start_line",
              "heading_level",
              "heading_path",
              "estimated_tokens",
              "relative_path",
          ],
      )
      writer.writeheader()
      writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--manifest-path", required=True, type=Path)
    parser.add_argument(
        "--split-levels",
        nargs="*",
        type=int,
        default=[2, 3],
        help="Heading levels that should start a new chunk.",
    )
    args = parser.parse_args()

    input_dir: Path = args.input_dir
    output_dir: Path = args.output_dir
    manifest_path: Path = args.manifest_path
    split_levels = set(args.split_levels)

    if not input_dir.exists():
        raise FileNotFoundError(f"Input directory not found: {input_dir}")

    output_dir.mkdir(parents=True, exist_ok=True)

    all_chunks: list[Chunk] = []
    for path in sorted(input_dir.rglob("*.md")):
        file_chunks = parse_markdown(path, split_levels=split_levels)
        all_chunks.extend(file_chunks)
        print(f"[OK] parsed {path} -> {len(file_chunks)} chunks")

    rows = write_chunks(output_dir, all_chunks)
    write_manifest(manifest_path, rows)

    print(f"[OK] wrote {len(rows)} chunk files")
    print(f"[OK] manifest: {manifest_path}")


if __name__ == "__main__":
    main()
