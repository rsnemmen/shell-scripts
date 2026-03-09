# Text & Document Processing

**Dependencies:** `pandoc`, `texcount`, `pdflatex`/`xelatex`, `sed`, `iconv`

| Script | Description |
|--------|-------------|
| `clean.sh` | Remove LaTeX build artifacts (`*.aux`, `*.log`, `*.bbl`, etc.) |
| `count-chars.sh` | Count characters and words in a provided string |
| `countwords.sh` | Count words in LaTeX files using texcount |
| `cpbib.sh` | Copy .bib file stripping hyperlinks for ApJ templates |
| `md_latex_delimiters.sh` | Convert `\(...\)` → `$...$` and `\[...\]` → `$$...$$` |
| `md2tex.sh` | Convert Markdown to LaTeX and render with pdflatex |
| `mdlatex2pdf.sh` | Convert Markdown with LaTeX math to PDF (most featureful) |
| `mdproject.sh` | Copy iCloud markdown draft to local and compile via md2tex.sh |
| `mdtex.sh` | Markdown → PDF via pandoc with custom geometry (xelatex) |
| `utf8.sh` | Batch convert files from ISO-8859-1 to UTF-8 |

---

## Usage

### mdlatex2pdf.sh

```sh
sh text/mdlatex2pdf.sh [options] <input.md> [output.pdf]
```

Most featureful Markdown-to-PDF converter. Converts LaTeX delimiters (`\(...\)` → `$...$`) and normalizes lists before calling pandoc.

Flags:

- `-s`, `--simple` — basic pandoc output without pre-processing
- `-h`, `--help` — show usage

### md_latex_delimiters.sh

```sh
sh text/md_latex_delimiters.sh file1.md file2.md ...
# or via stdin:
cat file.md | sh text/md_latex_delimiters.sh
```

Converts LaTeX math delimiters in Markdown files to standard `$...$` notation. Writes to stdout.

### mdtex.sh

```sh
sh text/mdtex.sh <input.md> <output.pdf>
```

Markdown → PDF via pandoc with custom page geometry (xelatex engine).

### md2tex.sh

```sh
sh text/md2tex.sh <input.md> <main.tex>
```

Converts Markdown to LaTeX, then compiles with `pdflatex` + `bibtex` and opens the result in Skim.

### mdproject.sh

```sh
sh text/mdproject.sh
```

Copies markdown from `~/Documents/iawriter/JP.txt` (iCloud) to `text.md`, then calls `md2tex.sh`.

### clean.sh

```sh
sh text/clean.sh
```

Removes LaTeX build artifacts (`*.aux`, `*.log`, `*.bbl`, `*.blg`, `*.toc`, `*.bak`, etc.) from the current directory.

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
