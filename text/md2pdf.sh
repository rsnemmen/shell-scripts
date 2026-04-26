#!/usr/bin/env bash
set -euo pipefail

# Pretty Markdown → PDF via pandoc + eisvogel template.
# Leading blockquote lines (>) are stripped before conversion — chatbot "thinking" sections.
# For documents with LaTeX math, use mdlatex2pdf.sh instead.

show_usage() {
    cat << EOF
Usage: $0 [options] <input.md> [input2.md ...]

Converts one or more Markdown files to PDF using pandoc and the eisvogel template
(https://github.com/Wandmalfarbe/pandoc-latex-template).

Output filename is derived by stripping the input's extension and adding .pdf.

Options:
  -h, --help   Show this help message and exit

Arguments:
  input.md     One or more input Markdown files (globs like *.md are fine)

Examples:
  $0 report.md              # produces report.pdf
  $0 a.md b.md c.md        # produces a.pdf, b.pdf, c.pdf
  $0 *.md                   # batch-convert all .md files in current directory
EOF
}

check_dependencies() {
    command -v pandoc &>/dev/null || { echo "Error: pandoc not found" >&2; exit 1; }
}

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            show_usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -lt 1 ]]; then
    show_usage >&2
    exit 1
fi

check_dependencies

if [[ ! -f ~/.local/share/pandoc/templates/eisvogel.latex ]]; then
    echo "Warning: eisvogel template not found — install it from https://github.com/Wandmalfarbe/pandoc-latex-template" >&2
fi

for input in "$@"; do
    output="${input%.*}.pdf"

    if [[ ! -r "$input" ]]; then
        echo "Error: Cannot read input '$input'" >&2
        continue
    fi

    printf '\033[1;36mGenerating PDF: %s → %s\033[0m\n' "$input" "$output" >&2
    awk '
        started { print; next }
        /^[[:space:]]*>/ { next }
        /^[[:space:]]*$/ { next }
        { started = 1; print }
    ' "$input" | pandoc -o "$output" --from=markdown --toc \
        --pdf-engine=xelatex --template=eisvogel --syntax-highlighting=idiomatic

    echo "Done: $output" >&2
done
