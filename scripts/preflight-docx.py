#!/usr/bin/env python3
"""
Run a lightweight structural preflight on one or more DOCX files.

The goal is not to fully understand Word documents.
The goal is to surface the most important structural risks before extraction:
- comments
- tracked changes markers
- tables
- images
- hyperlinks
- text boxes / drawing objects
- likely headers and footers

This script reads the DOCX package directly because a DOCX file is a ZIP archive
of XML files and media assets.

Example:
    python scripts/preflight-docx.py \
        --input ./documents-to-ingest/incoming/example.docx \
        --output ./documents-to-ingest/qa/example-preflight.md
"""

from __future__ import annotations

import argparse
import zipfile
from collections import Counter
from pathlib import Path
from xml.etree import ElementTree as ET

NS = {
    'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
    'v': 'urn:schemas-microsoft-com:vml',
}

TRACK_CHANGE_TAGS = {
    '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}ins',
    '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}del',
    '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}moveFrom',
    '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}moveTo',
}


def safe_xml(root: zipfile.ZipFile, member: str) -> ET.Element | None:
    try:
        data = root.read(member)
    except KeyError:
        return None
    return ET.fromstring(data)


def count_images(zf: zipfile.ZipFile) -> Counter[str]:
    counter: Counter[str] = Counter()
    for info in zf.infolist():
        if info.filename.startswith('word/media/') and not info.is_dir():
            counter[Path(info.filename).suffix.lower()] += 1
    return counter


def style_summary(styles_root: ET.Element | None) -> list[str]:
    if styles_root is None:
        return []
    result: list[str] = []
    for style in styles_root.findall('w:style', NS):
        style_id = style.attrib.get(f"{{{NS['w']}}}styleId", '')
        if style_id:
            result.append(style_id)
    return sorted(set(result))


def document_metrics(document_root: ET.Element | None) -> dict[str, int]:
    if document_root is None:
        return {}
    metrics = {
        'paragraphs': len(document_root.findall('.//w:p', NS)),
        'tables': len(document_root.findall('.//w:tbl', NS)),
        'hyperlinks': len(document_root.findall('.//w:hyperlink', NS)),
        'footnotes_refs': len(document_root.findall('.//w:footnoteReference', NS)),
        'endnotes_refs': len(document_root.findall('.//w:endnoteReference', NS)),
        'drawing_objects': len(document_root.findall('.//w:drawing', NS)),
        'text_boxes': len(document_root.findall('.//w:txbxContent', NS)) + len(document_root.findall('.//v:textbox', NS)),
        'track_change_markers': sum(1 for elem in document_root.iter() if elem.tag in TRACK_CHANGE_TAGS),
    }
    return metrics


def build_report(path: Path) -> str:
    with zipfile.ZipFile(path, 'r') as zf:
        document_root = safe_xml(zf, 'word/document.xml')
        comments_root = safe_xml(zf, 'word/comments.xml')
        styles_root = safe_xml(zf, 'word/styles.xml')
        header_members = [name for name in zf.namelist() if name.startswith('word/header') and name.endswith('.xml')]
        footer_members = [name for name in zf.namelist() if name.startswith('word/footer') and name.endswith('.xml')]

        metrics = document_metrics(document_root)
        image_counter = count_images(zf)
        style_ids = style_summary(styles_root)
        comment_count = 0 if comments_root is None else len(comments_root.findall('.//w:comment', NS))

    lines = [
        f'# DOCX preflight - {path.name}',
        '',
        '## Summary',
        '',
        f'- source file: `{path.as_posix()}`',
        f'- comments detected: {comment_count}',
        f'- header parts: {len(header_members)}',
        f'- footer parts: {len(footer_members)}',
        '',
        '## Document metrics',
        '',
    ]

    for key in [
        'paragraphs',
        'tables',
        'hyperlinks',
        'footnotes_refs',
        'endnotes_refs',
        'drawing_objects',
        'text_boxes',
        'track_change_markers',
    ]:
        lines.append(f'- {key.replace("_", " ")}: {metrics.get(key, 0)}')

    lines += ['', '## Media inventory', '']
    if image_counter:
        for suffix, count in sorted(image_counter.items()):
            lines.append(f'- `{suffix}`: {count}')
    else:
        lines.append('- no embedded media detected')

    lines += ['', '## Word styles detected', '']
    if style_ids:
        for style_id in style_ids[:60]:
            lines.append(f'- `{style_id}`')
        if len(style_ids) > 60:
            lines.append(f'- ... and {len(style_ids) - 60} more styles')
    else:
        lines.append('- no style information detected')

    lines += [
        '',
        '## Notes for reviewer',
        '',
        '- A high count of `track_change_markers` suggests that a probe extraction should inspect revision noise explicitly.',
        '- Non-empty `text_boxes` or many drawing objects suggest a visual QA pass before trusting the markdown.',
        '- Embedded EMF or other legacy image formats may need a later conversion pass for easier GitHub or VS Code review.',
    ]

    return '\n'.join(lines) + '\n'


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', dest='inputs', action='append', required=True, help='DOCX file to inspect. Repeat for multiple files.')
    parser.add_argument('--output-dir', type=Path, default=None, help='Directory where reports should be written.')
    parser.add_argument('--output', type=Path, default=None, help='Single output file. Valid only when one input is provided.')
    args = parser.parse_args()

    input_paths = [Path(item) for item in args.inputs]
    if args.output and len(input_paths) != 1:
        raise ValueError('--output can be used only with a single input file')

    if args.output:
        report = build_report(input_paths[0])
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(report, encoding='utf-8', newline='\n')
        print(f'[OK] wrote {args.output}')
        return

    if args.output_dir is None:
        raise ValueError('Provide either --output or --output-dir')

    args.output_dir.mkdir(parents=True, exist_ok=True)
    for source in input_paths:
        report = build_report(source)
        out = args.output_dir / f'{source.stem}.preflight.md'
        out.write_text(report, encoding='utf-8', newline='\n')
        print(f'[OK] wrote {out}')


if __name__ == '__main__':
    main()
