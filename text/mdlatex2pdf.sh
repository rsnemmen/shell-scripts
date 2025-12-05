#!/bin/bash

# Convert LaTeX delimiters and generate PDF
# Converts \(...\) to $...$ and \[...\] to $$...$$ then creates PDF with pandoc

show_usage() {
    cat << EOF
Usage: $0 <input.md> [output.pdf]

Converts LaTeX delimiters in markdown to standard notation and generates PDF:
  \\(...\\) -> \$...\$     (inline math)
  \\[...\\] -> \$\$...\$\$ (display math)

Arguments:
  input.md    Input markdown file
  output.pdf  Output PDF filename (optional, defaults to input name with .pdf)

Example:
  $0 document.md
  $0 document.md output.pdf
  $0 notes.md my-notes.pdf
EOF
}

# Check for required tools
check_dependencies() {
    local missing=()
    
    if ! command -v sed &> /dev/null; then
        missing+=("sed")
    fi
    
    if ! command -v pandoc &> /dev/null; then
        missing+=("pandoc")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Error: Missing required tools: ${missing[*]}" >&2
        echo "Please install them before running this script." >&2
        exit 1
    fi
}

convert_delimiters() {
    sed \
        -e 's/\\(/$/g' \
        -e 's/\\)/$/g' \
        -e 's/\\\[/$$/g' \
        -e 's/\\\]/$$/g'
}

# Show help
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

# Check dependencies
check_dependencies

# Get input file
input_file="$1"

# handles stdin, -, files
if [ ! -r "$input_file" ]; then
    echo "Error: Cannot read input '$input_file'" >&2
    exit 1
fi

# Optional: Add stdin support
if [ "$input_file" = "-" ]; then
    input_file="/dev/stdin"
fi

# Determine output filename
if [ -n "$2" ]; then
    output_file="$2"
else
    # Remove .md extension and add .pdf
    output_file="${input_file%.md}.pdf"
fi

# Create temporary file for converted markdown
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT

# Convert delimiters and save to temp file
echo "Converting LaTeX delimiters..." >&2
convert_delimiters < "$input_file" > "$temp_file"

# Generate PDF with pandoc
echo "Generating PDF with pandoc..." >&2
pandoc "$temp_file" -o "$output_file" \
    --pdf-engine=xelatex \
    --toc \
    -V geometry:margin=1in

if [ $? -eq 0 ]; then
    echo "Success! PDF created: $output_file" >&2
else
    echo "Error: PDF generation failed" >&2
    exit 1
fi