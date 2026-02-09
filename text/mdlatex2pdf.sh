#!/bin/bash

# Convert LaTeX delimiters and generate PDF
# Converts \(...\) to $...$ and \[...\] to $$...$$ then creates PDF with pandoc
# Ensures there is a blank line before bullet and numbered lists.

show_usage() {
    cat << EOF
Usage: $0 [options] <input.md> [output.pdf]

Converts LaTeX delimiters in markdown to standard notation and generates PDF:
  \\(...\\) -> \$...\$     (inline math)
  \\[...\\] -> \$\$...\$\$ (display math)

Also ensures that bullet and numbered lists have a blank line before them so
Pandoc reliably detects them as lists.

Options:
  -s, --simple   Use basic Pandoc PDF output (no template, 1in margins)
  -h, --help     Show this help message and exit

Arguments:
  input.md       Input markdown file
  output.pdf     Output PDF filename (optional, defaults to input name with .pdf)

Examples:
  $0 document.md
  $0 document.md output.pdf
  $0 --simple document.md
  $0 -s document.md simple-output.pdf
EOF
}

# Check for required tools
check_dependencies() {
    local missing=()
    
    if ! command -v sed &> /dev/null; then
        missing+=("sed")
    fi
    
    if ! command -v awk &> /dev/null; then
        missing+=("awk")
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

# Ensure there is a blank line before bullet and numbered lists
ensure_blank_before_lists() {
    awk '
        BEGIN {
            prev_is_blank = 1
            prev_is_list  = 0
            in_code_block = 0
        }
        {
            line = $0

            # Detect start or end of fenced code blocks (``` or ~~~, up to 3 spaces indent)
            if (match(line, /^[[:space:]]*(```+|~~~+)/)) {
                print line
                in_code_block = !in_code_block
                prev_is_blank = 0
                prev_is_list  = 0
                next
            }

            if (in_code_block) {
                # Inside code blocks, do not touch lists or add blank lines
                print line
                prev_is_blank = (line ~ /^[[:space:]]*$/)
                prev_is_list  = 0
                next
            }

            is_blank   = (line ~ /^[[:space:]]*$/)
            # Bullet list: optional spaces, then -, + or *, then space(s)
            is_bullet  = (line ~ /^[[:space:]]*[-+*][[:space:]]+/)
            # Numbered list: optional spaces, then digits, then . or ), then space(s)
            is_ordered = (line ~ /^[[:space:]]*[0-9]+[.)][[:space:]]+/)
            is_list    = (is_bullet || is_ordered)

            # If this line starts a list and the previous line
            # is not blank and not already a list, insert a blank line.
            if (is_list && !prev_is_blank && !prev_is_list) {
                print ""
            }

            print line

            prev_is_blank = is_blank
            prev_is_list  = is_list
        }
    '
}

use_simple=0

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--simple)
            use_simple=1
            shift
            ;;
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
            show_usage
            exit 1
            ;;
        *)
            # First non-option argument: input file
            break
            ;;
    esac
done

# Need at least an input file after options
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# Check dependencies
check_dependencies

# Get input file (positional)
input_file="$1"
shift

# Determine output filename (optional positional)
if [ -n "${1-}" ]; then
    output_file="$1"
else
    # Remove .md extension and add .pdf
    output_file="${input_file%.md}.pdf"
fi

# Support stdin with "-"
input_path="$input_file"
if [ "$input_file" = "-" ]; then
    input_path="/dev/stdin"
fi

# Ensure input is readable (file or /dev/stdin)
if [ ! -r "$input_path" ]; then
    echo "Error: Cannot read input '$input_file'" >&2
    exit 1
fi

# Create temporary file for converted markdown
temp_file=$(mktemp)
trap "rm -f '$temp_file'" EXIT

# Convert delimiters, then normalize lists, and save to temp file
echo "Converting LaTeX delimiters and normalizing lists..." >&2
convert_delimiters < "$input_path" | ensure_blank_before_lists > "$temp_file"

# Generate PDF with pandoc
echo "Generating PDF with pandoc..." >&2

if [ "$use_simple" -eq 1 ]; then
    # Simple / boring format
    pandoc "$temp_file" -o "$output_file" \
        --pdf-engine=xelatex \
        --toc \
        -V geometry:margin=1in
else
    # Default: fancy eisvogel template
    pandoc "$temp_file" -o "$output_file" \
        --from=markdown \
        --template=eisvogel \
        --syntax-highlighting=idiomatic \
        --pdf-engine=xelatex \
        --toc
fi

if [ $? -eq 0 ]; then
    echo "Success! PDF created: $output_file" >&2
else
    echo "Error: PDF generation failed" >&2
    exit 1
fi