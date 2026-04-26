#!/bin/bash

# Convert LaTeX delimiters in markdown to standard notation
# Converts \(...\) to $...$ and \[...\] to $$...$$

show_usage() {
    cat << EOF
Usage: $0 [file1] [file2] ...
       cat file.md | $0

Converts LaTeX delimiters in markdown files to standard notation:
  \\(...\\) -> \$...\$     (inline math)
  \\[...\\] -> \$\$...\$\$ (display math)

If no files are specified, reads from stdin.
Output is always written to stdout.

Examples:
  $0 input.md > output.md
  $0 file1.md file2.md > combined.md
  cat input.md | $0 > output.md
EOF
}

strip_thinking() {
    awk '
        started { print; next }
        /^[[:space:]]*>/ { next }
        /^[[:space:]]*$/ { next }
        { started = 1; print }
    '
}

convert_delimiters() {
    sed \
        -e 's/\\( */$/g' \
        -e 's/ *\\)/$/g' \
        -e 's/\\\[ */$$/g' \
        -e 's/ *\\\]/$$/g'
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

if [ $# -eq 0 ]; then
    strip_thinking | convert_delimiters
else
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "Error: File '$file' not found" >&2
            exit 1
        fi
        strip_thinking < "$file" | convert_delimiters
    done
fi