#!/usr/bin/env python3
"""
Normalize a master markdown file produced by a document extraction step.

This script is intentionally conservative.
It does not try to fully understand the document. It applies a few small cleanups
that are common after DOCX extraction:
- remove obvious HTML wrappers for custom Word styles
- collapse repeated blank lines
- optionally strip an early table-of-contents block if it matches a marker
- normalize line endings and trailing whitespace

Use it only after reviewing the raw extraction once.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

CUSTOM_STYLE_DIV_RE = re.compile(r'</?div\b[^>]*custom-style="[^"]+"[^>]*>')
MULTI_BLANK_RE = re.compile(r'\n{3,}')
TOC_HEADING_RE = re.compile(
    r'^(#+\s+table of contents|#+\s+contents|#+\s+indice)\s*$',
    re.IGNORECASE | re.MULTILINE,
)


def normalize(text: str, strip_toc: bool) -> str:
    text = text.replace('\r\n', '\n').replace('\r', '\n')
    text = CUSTOM_STYLE_DIV_RE.sub('', text)
    text = '\n'.join(line.rstrip() for line in text.splitlines())

    if strip_toc:
        match = TOC_HEADING_RE.search(text)
        if match:
            start = match.start()
            later_heading = re.search(r'^#\s+.+$', text[match.end():], re.MULTILINE)
            if later_heading:
                end = match.end() + later_heading.start()
                text = text[:start].rstrip() + '\n\n' + text[end:].lstrip()

    text = MULTI_BLANK_RE.sub('\n\n', text).strip() + '\n'
    return text


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--strip-toc', action='store_true')
    args = parser.parse_args()

    text = args.input.read_text(encoding='utf-8')
    cleaned = normalize(text, strip_toc=args.strip_toc)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(cleaned, encoding='utf-8', newline='\n')
    print(f'[OK] wrote {args.output}')


if __name__ == '__main__':
    main()
