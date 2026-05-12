#!/usr/bin/env bash
set -euo pipefail

# Pretty Markdown → PDF via pandoc + eisvogel template.
# Leading chatbot thinking preambles are stripped before conversion.

show_usage() {
    cat << EOF
Usage: $0 [options] <input.md> [output.pdf]
       $0 [options] <input1.md> <input2.md> ...

Converts one or more Markdown files to PDF using pandoc and the eisvogel template
(https://github.com/Wandmalfarbe/pandoc-latex-template).

Output filename is derived by stripping the input's extension and adding .pdf,
or specified explicitly as the second argument in single-file mode.

Options:
  --math       Convert LaTeX delimiters: \(...\) → \$...\$ and \[...\] → \$\$...\$\$
  -s, --simple Use basic Pandoc output (no template, 1in margins)
  --toc        Include a table of contents
  --no-toc     Do not include a table of contents (default)
  -h, --help   Show this help message and exit

Arguments:
  input.md     One or more input Markdown files (globs like *.md are fine)
  output.pdf   Output filename (single-file mode only; default: input with .pdf)
  -            Read from stdin (single-file mode only; requires explicit output.pdf)

Examples:
  $0 report.md                     # produces report.pdf without a TOC
  $0 --toc report.md               # produces report.pdf with a TOC
  $0 --math notes.md               # convert LaTeX delimiters before rendering
  $0 -s --math notes.md            # simple template with math conversion
  $0 --math notes.md out.pdf       # explicit output filename
  $0 a.md b.md c.md                # produces a.pdf, b.pdf, c.pdf
  $0 *.md                          # batch-convert all .md files in current directory
  cat notes.md | $0 --math - out.pdf  # stdin input
EOF
}

check_dependencies() {
    for cmd in pandoc sed awk; do
        command -v "$cmd" &>/dev/null || { echo "Error: $cmd not found" >&2; exit 1; }
    done
}

progress_active=0

cleanup_progress() {
    if [[ "$progress_active" -eq 1 ]]; then
        printf '\n' >&2
    fi
}

print_stderr_line() {
    if [[ "$progress_active" -eq 1 ]]; then
        printf '\n' >&2
    fi
    printf '%s\n' "$1" >&2
}

print_error_block() {
    local heading="$1" log_file="$2"
    local line

    print_stderr_line "$heading"
    if [[ -s "$log_file" ]]; then
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
    if [[ "$progress_active" -eq 1 ]]; then
        printf '\n' >&2
        progress_active=0
    fi
}

strip_leading_thinking() {
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

ensure_blank_before_lists() {
    awk '
        BEGIN {
            prev_is_blank = 1
            prev_is_list = 0
            in_code_block = 0
        }

        {
            line = $0

            if (match(line, /^[[:space:]]{0,3}(```+|~~~+)/)) {
                print line
                in_code_block = !in_code_block
                prev_is_blank = 0
                prev_is_list = 0
                next
            }

            if (in_code_block) {
                print line
                prev_is_blank = (line ~ /^[[:space:]]*$/)
                prev_is_list = 0
                next
            }

            is_blank = (line ~ /^[[:space:]]*$/)
            is_bullet = (line ~ /^[[:space:]]*[-+*][[:space:]]+/)
            is_ordered = (line ~ /^[[:space:]]*[0-9]+[.)][[:space:]]+/)
            is_list = (is_bullet || is_ordered)

            if (is_list && !prev_is_blank && !prev_is_list) {
                print ""
            }

            print line

            prev_is_blank = is_blank
            prev_is_list = is_list
        }
    '
}

preprocess() {
    if [[ "$math_enabled" -eq 1 ]]; then
        strip_leading_thinking | convert_delimiters | ensure_blank_before_lists
    else
        strip_leading_thinking | ensure_blank_before_lists
    fi
}

convert_file() {
    local input="$1" output="$2" verbose="${3:-1}"
    local input_path="$input"
    local status
    local temp_err=""
    local -a pandoc_args

    [[ "$input" == "-" ]] && input_path="/dev/stdin"

    if [[ "$input" != "-" && ! -r "$input" ]]; then
        print_stderr_line "Error: Cannot read input '$input'"
        return 1
    fi

    if [[ "$use_simple" -eq 1 ]]; then
        pandoc_args=(
            -o "$output"
            --pdf-engine=xelatex
            -V geometry:margin=1in
        )
    else
        pandoc_args=(
            -o "$output"
            --from=markdown
            --pdf-engine=xelatex
            --template=eisvogel
            --syntax-highlighting=idiomatic
            -V listings=false
            -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}'
        )
    fi

    if [[ "$toc_enabled" -eq 1 ]]; then
        pandoc_args+=(--toc)
    fi

    if [[ "$verbose" -eq 1 ]]; then
        printf '\033[1;36mGenerating PDF: %s → %s\033[0m\n' "$input" "$output" >&2
    else
        temp_err=$(mktemp) || return 1
    fi

    if [[ "$verbose" -eq 1 ]]; then
        if preprocess < "$input_path" | pandoc "${pandoc_args[@]}"
        then
            status=0
        else
            status=$?
        fi
    else
        if preprocess < "$input_path" | pandoc "${pandoc_args[@]}" \
            2>"$temp_err"
        then
            status=0
        else
            status=$?
        fi
    fi

    if [[ "$status" -eq 0 && "$verbose" -eq 1 ]]; then
        echo "Done: $output" >&2
    elif [[ "$status" -ne 0 && "$verbose" -eq 0 ]]; then
        print_error_block "Error: Failed to generate PDF for '$input'" "$temp_err"
    fi

    [[ -n "$temp_err" ]] && rm -f "$temp_err"
    return "$status"
}

trap cleanup_progress EXIT

toc_enabled=0
math_enabled=0
use_simple=0

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --math)
            math_enabled=1
            shift
            ;;
        -s|--simple)
            use_simple=1
            shift
            ;;
        --toc)
            toc_enabled=1
            shift
            ;;
        --no-toc)
            toc_enabled=0
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

if [[ "$use_simple" -eq 0 && ! -f ~/.local/share/pandoc/templates/eisvogel.latex ]]; then
    echo "Warning: eisvogel template not found — install it from https://github.com/Wandmalfarbe/pandoc-latex-template" >&2
fi

# Single-file mode with explicit output filename
if [[ $# -eq 2 && "$2" == *.pdf && ! -e "$2" && ( "$1" == "-" || -r "$1" ) ]]; then
    convert_file "$1" "$2"

# Single-file mode with derived output filename
elif [[ $# -eq 1 ]]; then
    input="$1"
    input_path="$input"
    [[ "$input" == "-" ]] && input_path="/dev/stdin"
    output="${input%.*}.pdf"
    if [[ "$input" != "-" && ! -r "$input_path" ]]; then
        echo "Error: Cannot read input '$input'" >&2
        exit 1
    fi
    convert_file "$input" "$output"

# Batch mode
else
    for f in "$@"; do
        if [[ "$f" == "-" ]]; then
            echo "Error: stdin ('-') cannot be used in batch mode" >&2
            exit 1
        fi
    done

    total=$#
    completed=0
    fail_count=0

    render_bar "$completed" "$total" 30
    for input in "$@"; do
        output="${input%.*}.pdf"
        render_bar "$completed" "$total" 30 "$input"

        if ! convert_file "$input" "$output" 0; then
            fail_count=$((fail_count + 1))
        fi

        completed=$((completed + 1))
        render_bar "$completed" "$total" 30 "$input"
    done
    finish_progress

    if [[ "$fail_count" -gt 0 ]]; then
        echo "Batch complete with $fail_count failure(s)." >&2
        exit 1
    fi
fi
