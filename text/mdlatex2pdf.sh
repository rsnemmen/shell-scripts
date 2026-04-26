#!/bin/bash

# Convert LaTeX delimiters and generate PDF
# Converts \(...\) to $...$ and \[...\] to $$...$$ then creates PDF with pandoc
# Ensures there is a blank line before bullet and numbered lists.
# Leading blockquote lines (>) are stripped before conversion — chatbot "thinking" sections.

show_usage() {
    cat << EOF
Usage: $0 [options] <input.md> [output.pdf]
       $0 [options] <input1.md> <input2.md> ...

Converts LaTeX delimiters in markdown to standard notation and generates PDF:
  \\(...\\) -> \$...\$     (inline math)
  \\[...\\] -> \$\$...\$\$ (display math)

Also ensures that bullet and numbered lists have a blank line before them so
Pandoc reliably detects them as lists.

Options:
  -s, --simple   Use basic Pandoc PDF output (no template, 1in margins)
  -h, --help     Show this help message and exit

Arguments:
  input.md       One or more input markdown files; globs like *.md work fine.
                 With a single input, an optional output.pdf may follow.
  output.pdf     Output PDF filename (single-file mode only; default: input with .pdf)

Examples:
  $0 document.md
  $0 document.md output.pdf
  $0 --simple document.md
  $0 -s document.md simple-output.pdf
  $0 a.md b.md c.md          # batch: produces a.pdf, b.pdf, c.pdf
  $0 -s *.md                 # batch with simple template
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

# Detect single vs batch mode.
# Single with explicit output: exactly 2 args, second ends in .pdf and does not
# exist as a file (so it's a target name, not an accidentally globbed .pdf).
# Single otherwise: exactly 1 arg.
# Batch: everything else.
_run_pandoc() {
    local input_path="$1" output_file="$2"
    local temp_file
    temp_file=$(mktemp)
    trap "rm -f '$temp_file'" EXIT

    echo "[$output_file] Converting LaTeX delimiters and normalizing lists..." >&2
    strip_thinking < "$input_path" | convert_delimiters | ensure_blank_before_lists > "$temp_file"

    echo "[$output_file] Generating PDF with pandoc..." >&2
    if [ "$use_simple" -eq 1 ]; then
        pandoc "$temp_file" -o "$output_file" \
            --pdf-engine=xelatex \
            --toc \
            -V geometry:margin=1in
    else
        pandoc "$temp_file" -o "$output_file" \
            --from=markdown \
            --template=eisvogel \
            --syntax-highlighting=idiomatic \
            --pdf-engine=xelatex \
            --toc \
            -V listings=false \
            -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}'
    fi
    echo "Success! PDF created: $output_file" >&2
}

if [ $# -eq 2 ] && [[ "$2" == *.pdf ]] && [ ! -e "$2" ] && ([ "$1" = "-" ] || [ -r "$1" ]); then
    # Single-file mode with explicit output filename
    input_file="$1"
    output_file="$2"
    input_path="$input_file"
    [ "$input_file" = "-" ] && input_path="/dev/stdin"
    if [ "$input_file" != "-" ] && [ ! -r "$input_path" ]; then
        echo "Error: Cannot read input '$input_file'" >&2
        exit 1
    fi
    _run_pandoc "$input_path" "$output_file"

elif [ $# -eq 1 ]; then
    # Single-file mode with derived output filename
    input_file="$1"
    input_path="$input_file"
    [ "$input_file" = "-" ] && input_path="/dev/stdin"
    output_file="${input_file%.md}.pdf"
    if [ "$input_file" != "-" ] && [ ! -r "$input_path" ]; then
        echo "Error: Cannot read input '$input_file'" >&2
        exit 1
    fi
    _run_pandoc "$input_path" "$output_file"

else
    # Batch mode: every positional arg is an input file
    for f in "$@"; do
        if [ "$f" = "-" ]; then
            echo "Error: stdin ('-') cannot be used in batch mode" >&2
            exit 1
        fi
    done
    fail_count=0
    for f in "$@"; do
        if [ ! -r "$f" ]; then
            echo "Error: Cannot read input '$f' — skipping" >&2
            fail_count=$((fail_count + 1))
            continue
        fi
        out="${f%.md}.pdf"
        _run_pandoc "$f" "$out" || { fail_count=$((fail_count + 1)); continue; }
    done
    if [ "$fail_count" -gt 0 ]; then
        echo "Batch complete with $fail_count failure(s)." >&2
        exit 1
    fi
fi