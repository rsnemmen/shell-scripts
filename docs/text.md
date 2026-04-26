# Text & Document Processing

**Dependencies:** `pandoc`, `texcount`, `xelatex`, `sed`, `iconv`

| Script | Description |
|--------|-------------|
| `count-chars.sh` | Count characters and words in a provided string |
| `countwords.sh` | Count words in LaTeX files using texcount |
| `cpbib.sh` | Copy .bib file stripping hyperlinks for ApJ templates |
| `md2pdf.sh` | Pretty Markdown → PDF via pandoc + eisvogel template |
| `md_latex_delimiters.sh` | Convert `\(...\)` → `$...$` and `\[...\]` → `$$...$$` |
| `mdlatex2pdf.sh` | Convert Markdown with LaTeX math to PDF (most featureful) |
| `utf8.sh` | Batch convert files from ISO-8859-1 to UTF-8 |

---

## Usage

### md2pdf.sh

```sh
sh text/md2pdf.sh <input.md>
```

Pretty Markdown → PDF using pandoc with the [eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) template, TOC, and idiomatic syntax highlighting. Output filename is the input with `.pdf` extension. Lighter alternative to `mdlatex2pdf.sh` for documents without LaTeX math.

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
