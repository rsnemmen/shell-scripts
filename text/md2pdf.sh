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

convert_file() {
    local input="$1" output="$2" verbose="${3:-1}"
    local status
    local temp_err=""

    if [[ ! -r "$input" ]]; then
        print_stderr_line "Error: Cannot read input '$input'"
        return 1
    fi

    if [[ "$verbose" -eq 1 ]]; then
        printf '\033[1;36mGenerating PDF: %s → %s\033[0m\n' "$input" "$output" >&2
    else
        temp_err=$(mktemp) || return 1
    fi

    if [[ "$verbose" -eq 1 ]]; then
        if awk '
            started { print; next }
            /^[[:space:]]*>/ { next }
            /^[[:space:]]*$/ { next }
            { started = 1; print }
        ' "$input" | pandoc -o "$output" --from=markdown --toc \
            --pdf-engine=xelatex --template=eisvogel --syntax-highlighting=idiomatic \
            -V listings=false \
            -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}'
        then
            status=0
        else
            status=$?
        fi
    else
        if awk '
            started { print; next }
            /^[[:space:]]*>/ { next }
            /^[[:space:]]*$/ { next }
            { started = 1; print }
        ' "$input" | pandoc -o "$output" --from=markdown --toc \
            --pdf-engine=xelatex --template=eisvogel --syntax-highlighting=idiomatic \
            -V listings=false \
            -V header-includes='\def\ptlstinline!#1!{\texttt{#1}}\AtBeginDocument{\def\passthrough#1{\begingroup\let\lstinline\ptlstinline #1\endgroup}}' \
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

if [[ $# -eq 1 ]]; then
    input="$1"
    output="${input%.*}.pdf"
    convert_file "$input" "$output"
else
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
