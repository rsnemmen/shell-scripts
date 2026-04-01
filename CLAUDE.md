# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal collection of 60+ shell utility scripts organized by category. Scripts are lightweight wrappers around external tools (pandoc, ffmpeg, lame, ImageMagick, etc.) for file conversion, text processing, media encoding, and system tasks.

## Running Scripts

```sh
sh script.sh <arguments>
# or if executable:
./script.sh <arguments>
```

No build step, no test suite, no CI. Scripts are standalone utilities.

## Code Style and Conventions

New scripts should follow the modern patterns found in recent additions:

**Script structure:**
```bash
#!/usr/bin/env bash
set -euo pipefail

show_usage() {
    cat << EOF
Usage: $0 [options] <input>
...
EOF
}

check_dependencies() {
    for cmd in pandoc sed; do
        command -v "$cmd" &>/dev/null || { echo "Error: $cmd not found" >&2; exit 1; }
    done
}
```

**Key patterns:**
- Use `#!/usr/bin/env bash` shebang with `set -euo pipefail`
- Define `show_usage()` with heredoc; call it with `-h` flag via `getopts`
- Check for external dependencies before running
- Use `mktemp` with `trap "rm -f '$tmp'" EXIT` for temp files
- Send error messages to stderr (`>&2`), output to stdout
- Support stdin with `-` as filename argument where appropriate
- Use ANSI colors for progress output (`\033[1;36m` cyan, `\033[0m` reset)

**Older scripts** use `#!/bin/sh`, lack error handling, and may have Portuguese comments — this is expected for legacy scripts.

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `text/` | Markdown↔LaTeX conversion, word counting, UTF-8 conversion |
| `PDF-PS/` | PDF compression, imposition, format conversion |
| `music/` | Audio format conversion (WAV, MP3, OGG) |
| `movies/` | Video encoding, subtitle extraction |
| `file-utilities/` | Batch rename, MD5 hashing, Jupyter→Markdown |
| `gaming/` | ROM management, CHD conversion, M3U playlists |
| `transferring/` | rsync/cp-based backup, upload, and Figshare FTPS transfer |
| `mount-images/` | SSH, USB, and disk image mounting |
| `image_processing/` | Image resizing, screenshots |
| `system/` | macOS system monitoring |
| `docs/` | MkDocs source — one `.md` page per category |

## Documentation Website

The repo has a MkDocs Material site configured in `mkdocs.yml`.

- Preview locally: `mkdocs serve`
- Deploy to GitHub Pages: `mkdocs gh-deploy`

When adding or updating scripts, keep the corresponding page in `docs/` in sync.

## Notable Scripts

- `text/mdlatex2pdf.sh` — Markdown with LaTeX math → PDF via pandoc (most complex script)
- `text/md_latex_delimiters.sh` — Converts `\(...\)` and `\[...\]` to `$...$` delimiters
- `file-utilities/jupyter2md.sh` — Batch converts Jupyter notebooks to Markdown
- `gaming/create_m3u.py` — Only Python script; creates M3U playlists for multi-disk ROMs
- `rank_clippies.sh` — Ranks LLMs via API calls
