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
    # No arguments, read from stdin
    convert_delimiters
else
    # Process files and output to stdout
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "Error: File '$file' not found" >&2
            exit 1
        fi
        convert_delimiters < "$file"
    done
fi