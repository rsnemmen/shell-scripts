# Repository Guidelines

## Project Structure & Module Organization

This repository is a collection of standalone utility scripts, mostly Bash, grouped by task:

- `text/`, `PDF-PS/`, `music/`, `movies/`, `file-utilities/`, `gaming/`, `image_processing/`, `transferring/`, `mount-images/`, and `system/` contain runnable scripts.
- Root scripts such as `arguments.sh`, `sort.sh`, and `overleaf.sh` are general utilities.
- `docs/` contains MkDocs source pages, one page per category.
- `site/` contains the generated documentation site; do not edit it by hand unless intentionally updating generated output.
- `mkdocs.yml` defines the documentation navigation and theme.

When adding a script, place it in the closest category directory and update the matching page in `docs/`.

## Build, Test, and Development Commands

There is no compile step, package manager, or CI test suite. Run scripts directly:

```sh
sh path/to/script.sh <arguments>
./path/to/script.sh <arguments>
```

Preview documentation locally:

```sh
mkdocs serve
```

Deploy documentation to GitHub Pages:

```sh
mkdocs gh-deploy
```

Before changing a script, check its required external tools in `README.md` and verify behavior with a small local sample file.

## Coding Style & Naming Conventions

Prefer modern Bash for new or substantially revised scripts:

- Use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Use 4-space indentation inside functions and conditionals.
- Provide `show_usage()` and support `-h`/help output for non-trivial scripts.
- Check dependencies with `command -v` before work begins.
- Send errors to stderr with `>&2`; keep normal output on stdout.
- Use `mktemp` plus `trap` for temporary files.

Script names should be lowercase and descriptive, usually hyphenated or following the existing legacy name in that folder, for example `jupyter2md.sh` or `batch-rename.sh`.

## Testing Guidelines

No formal testing framework is present. Validate shell scripts manually with representative inputs, edge cases, and missing-dependency paths where practical. For risky shell changes, run syntax checks:

```sh
bash -n path/to/script.sh
```

If adding Python utilities such as `gaming/create_m3u.py`, include a simple command-line smoke test in the PR notes.

## Commit & Pull Request Guidelines

Recent commits use concise imperative or scoped messages, for example `text: fix Unicode in inline code` and `docs: add pdf.sh to pdf-ps page`. Follow that style.

Pull requests should include a short description, changed scripts, manual test commands and results, dependency changes, and documentation updates. Include screenshots only for documentation or site-rendering changes.
