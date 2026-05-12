# Text & Document Processing

**Dependencies:** `pandoc`, `texcount`, `xelatex`, `sed`, `iconv`

| Script | Description |
|--------|-------------|
| `count-chars.sh` | Count characters and words in a provided string |
| `countwords.sh` | Count words in LaTeX files using texcount |
| `cpbib.sh` | Copy .bib file stripping hyperlinks for ApJ templates |
| `md2pdf.sh` | Markdown → PDF via pandoc + eisvogel; supports `--math`, `--simple`, TOC, batch |
| `md_latex_delimiters.sh` | Convert `\(...\)` → `$...$` and `\[...\]` → `$$...$$` |
| `utf8.sh` | Batch convert files from ISO-8859-1 to UTF-8 |
| `overleaf.sh` | Clone an Overleaf project and set up dual push to Overleaf and GitHub |

---

## Usage

### md2pdf.sh

```sh
sh text/md2pdf.sh [options] <input.md> [output.pdf]
sh text/md2pdf.sh [options] <input1.md> <input2.md> ...
cat notes.md | sh text/md2pdf.sh [options] - output.pdf
```

Markdown → PDF using pandoc with the [eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) template and idiomatic syntax highlighting. Output filename is derived from the input (`.md` → `.pdf`) or specified explicitly as the second argument. Accepts multiple files or globs (`*.md`) for batch conversion and shows an overall progress bar with the current filename for multi-file runs. Strips leading chatbot thinking preambles before conversion.

Flags:

- `--math` — convert LaTeX delimiters (`\(...\)` → `$...$`, `\[...\]` → `$$...$$`) before rendering; useful for LLM output and documents exported from Overleaf-style tools
- `-s`, `--simple` — bypass eisvogel; produce a basic PDF with 1in margins (no template, no syntax highlighting)
- `--toc` — include a table of contents
- `--no-toc` — suppress the table of contents (default)

### md_latex_delimiters.sh

```sh
sh text/md_latex_delimiters.sh file1.md file2.md ...
# or via stdin:
cat file.md | sh text/md_latex_delimiters.sh
```

Converts LaTeX math delimiters in Markdown files to standard `$...$` notation. Writes to stdout.

### countwords.sh

```sh
sh text/countwords.sh
```

Counts main text and abstract word counts in a LaTeX document using `texcount`.

### count-chars.sh

```sh
sh text/count-chars.sh "Your string here"
```

Counts characters and words in a provided string.

### cpbib.sh

```sh
sh text/cpbib.sh
```

Copies `~/work/mypapers/refs.bib` to the current folder with hyperlinks stripped for ApJ submission templates.

### utf8.sh

```sh
sh text/utf8.sh file1 file2 ...
```

Converts files from ISO-8859-1 encoding to UTF-8 in-place using `iconv`.

### overleaf.sh

```sh
sh overleaf.sh
```

Interactively clones an Overleaf project and adds a GitHub remote, then configures a `both` remote so `git push both` pushes to Overleaf and GitHub simultaneously. Requires an existing Overleaf project (get the git URL from the Share button).
