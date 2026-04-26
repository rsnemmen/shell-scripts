#!/bin/bash

# Convert LaTeX delimiters and generate PDF
# Converts \(...\) to $...$ and \[...\] to $$...$$ then creates PDF with pandoc
# Ensures there is a blank line before bullet and numbered lists.
# Leading chatbot thinking preambles are stripped before conversion.

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

progress_active=0

cleanup_progress() {
    if [ "$progress_active" -eq 1 ]; then
        printf '\n' >&2
    fi
}

print_stderr_line() {
    if [ "$progress_active" -eq 1 ]; then
        printf '\n' >&2
    fi
    printf '%s\n' "$1" >&2
}

print_error_block() {
    local heading="$1" log_file="$2"
    local line

    print_stderr_line "$heading"
    if [ -s "$log_file" ]; then
        while IFS= read -r line; do
            printf '  %s\n' "$line" >&2
        done < "$log_file"
    fi
}

format_progress_label() {
    local label="$1" max_length="${2:-48}"

    if (( ${#label} <= max_length )); then
        printf '%s' "$label"
    else
        printf '...%s' "${label: -$((max_length - 3))}"
    fi
}

render_bar() {
    local current="$1" total="$2" width="${3:-30}" label="${4:-}"
    local percent filled empty
    local bar=""
    local display_label=""
    local i

    if (( total == 0 )); then
        percent=100
        filled=$width
    else
        percent=$(( current * 100 / total ))
        filled=$(( current * width / total ))
    fi
    empty=$(( width - filled ))

    for ((i=0; i<filled; i++)); do bar+="#"; done
    for ((i=0; i<empty; i++)); do bar+="-"; done

    if [[ -n "$label" ]]; then
        display_label=$(format_progress_label "$label")
        printf '\r[%s] %3d%% (%d/%d) %s\033[K' "$bar" "$percent" "$current" "$total" "$display_label" >&2
    else
        printf '\r[%s] %3d%% (%d/%d)\033[K' "$bar" "$percent" "$current" "$total" >&2
    fi
    progress_active=1
}

finish_progress() {
    if [ "$progress_active" -eq 1 ]; then
        printf '\n' >&2
        progress_active=0
    fi
}

strip_thinking() {
    awk '
        function flush_buffer(    i) {
            for (i = 1; i <= buffered_count; i++) {
                print buffered[i]
            }
            buffered_count = 0
        }

        BEGIN {
            mode = "start"
            buffered_count = 0
        }

        {
            line = $0
            lower = tolower(line)
            is_blank = (line ~ /^[[:space:]]*$/)
            is_quote = (line ~ /^[[:space:]]*>/)
            is_thinking_marker = (line ~ /^[[:space:]]*[*_][^*_]*[*_][[:space:]]*$/ && lower ~ /thinking/)

            if (mode == "start") {
                if (NR == 1 && is_thinking_marker) {
                    buffered[++buffered_count] = line
                    mode = "maybe-thinking"
                    next
                }

                print line
                mode = "print"
                next
            }

            if (mode == "maybe-thinking") {
                if (is_blank) {
                    buffered[++buffered_count] = line
                    next
                }

                if (is_quote) {
                    mode = "skip-thinking"
                    next
                }

                flush_buffer()
                print line
                mode = "print"
                next
            }

            if (mode == "skip-thinking") {
                if (is_blank || is_quote) {
                    next
                }

                print line
                mode = "print"
                next
            }

            print line
        }

        END {
            if (mode == "maybe-thinking") {
                flush_buffer()
            }
        }
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
    local input_path="$1" output_file="$2" verbose="${3:-1}"
    local temp_file
    local temp_err=""
    local status

    temp_file=$(mktemp) || return 1
    if [ "$verbose" -eq 0 ]; then
        temp_err=$(mktemp) || { rm -f "$temp_file"; return 1; }
    fi

    if [ "$verbose" -eq 1 ]; then
        echo "[$output_file] Converting LaTeX delimiters and normalizing lists..." >&2
    fi
    if [ "$verbose" -eq 1 ]; then
        if ! strip_thinking < "$input_path" | convert_delimiters | ensure_blank_before_lists > "$temp_file"; then
            rm -f "$temp_file" "$temp_err"
            return 1
        fi
    else
        if ! strip_thinking < "$input_path" | convert_delimiters | ensure_blank_before_lists > "$temp_file" 2>"$temp_err"; then
            print_error_block "Error: Failed to preprocess '$input_path'" "$temp_err"
            rm -f "$temp_file" "$temp_err"
            return 1
        fi
    fi

    if [ "$verbose" -eq 1 ]; then
        echo "[$output_file] Generating PDF with pandoc..." >&2
    fi
    if [ "$verbose" -eq 0 ]; then
        : > "$temp_err"
    fi
    if [ "$use_simple" -eq 1 ]; then
        if [ "$verbose" -eq 1 ]; then
            if pandoc "$temp_file" -o "$output_file" \
                --pdf-engine=xelatex \
                --toc \
                -V geometry:margin=1in
            then
                status=0
            else
                status=$?
            fi
        else
            if pandoc "$temp_file" -o "$output_file" \
                --pdf-engine=xelatex \
                --toc \
                -V geometry:margin=1in \
                2>"$temp_err"
            then
                status=0
            else
                status=$?
            fi
        fi
    else
        if [ "$verbose" -eq 1 ]; then
            if pandoc "$temp_file" -o "$output_file" \
                --from=markdown \
                --template=eisvogel \
                --syntax-highlighting=idiomatic \
                --pdf-engine=xelatex \
                --toc \
                -V listings=false \
                -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}'
            then
                status=0
            else
                status=$?
            fi
        else
            if pandoc "$temp_file" -o "$output_file" \
                --from=markdown \
                --template=eisvogel \
                --syntax-highlighting=idiomatic \
                --pdf-engine=xelatex \
                --toc \
                -V listings=false \
                -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}' \
                2>"$temp_err"
            then
                status=0
            else
                status=$?
            fi
        fi
    fi

    if [ "$status" -ne 0 ] && [ "$verbose" -eq 0 ]; then
        print_error_block "Error: Failed to generate PDF for '$input_path'" "$temp_err"
    fi

    rm -f "$temp_file" "$temp_err"

    if [ "$status" -eq 0 ] && [ "$verbose" -eq 1 ]; then
        echo "Success! PDF created: $output_file" >&2
    fi

    return "$status"
}

trap cleanup_progress EXIT

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
    _run_pandoc "$input_path" "$output_file" 1

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
    _run_pandoc "$input_path" "$output_file" 1

else
    # Batch mode: every positional arg is an input file
    for f in "$@"; do
        if [ "$f" = "-" ]; then
            echo "Error: stdin ('-') cannot be used in batch mode" >&2
            exit 1
        fi
    done
    total=$#
    completed=0
    fail_count=0

    render_bar "$completed" "$total" 30
    for f in "$@"; do
        render_bar "$completed" "$total" 30 "$f"
        if [ ! -r "$f" ]; then
            print_stderr_line "Error: Cannot read input '$f' — skipping"
            fail_count=$((fail_count + 1))
            completed=$((completed + 1))
            render_bar "$completed" "$total" 30 "$f"
            continue
        fi
        out="${f%.md}.pdf"
        if ! _run_pandoc "$f" "$out" 0; then
            fail_count=$((fail_count + 1))
        fi
        completed=$((completed + 1))
        render_bar "$completed" "$total" 30 "$f"
    done
    finish_progress
    if [ "$fail_count" -gt 0 ]; then
        echo "Batch complete with $fail_count failure(s)." >&2
        exit 1
    fi
fi
