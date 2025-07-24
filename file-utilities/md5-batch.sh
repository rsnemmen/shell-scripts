#!/usr/bin/env bash
#
# Generate MD5 hashes for all regular files in the current directory.
#
# Options:
#   -o FILE   Write checksums to FILE instead of stdout
#   -h        Show this help and exit
#
# If pv(1) is available it is used to display per-file progress.

set -euo pipefail

##############################################################################
# Argument parsing
##############################################################################
output_file=""          # empty ⇒ print to stdout

usage() {
    cat <<EOF
Usage: ${0##*/} [-o output_file]

If -o is omitted, checksums are written to standard output.
EOF
    exit "${1:-0}"
}

while getopts ":o:h" opt; do
    case "$opt" in
        o) output_file="$OPTARG" ;;
        h) usage 0 ;;
        \?) printf 'Error: invalid option -%s\n' "$OPTARG" >&2; usage 1 ;;
    esac
done
shift $((OPTIND - 1))

##############################################################################
# Environment checks
##############################################################################
use_pv=false
command -v pv &> /dev/null && use_pv=true

# Create/truncate the output file only if one was requested.
if [[ -n "$output_file" ]]; then
    : > "$output_file"
fi

##############################################################################
# Helper: write a line either to file or stdout
##############################################################################
write_line() {
    if [[ -n "$output_file" ]]; then
        printf '%s\n' "$1" >> "$output_file"
    else
        printf '%s\n' "$1"
    fi
}

##############################################################################
# Main loop
##############################################################################
for file in *; do
    # Skip the output file itself, directories, and non-regular files
    [[ -n "$output_file" && "$file" == "$output_file" ]] && continue
    [[ -d "$file"      || ! -f "$file" ]] && continue

    # Compute checksum
    if $use_pv; then
        file_hash=$(pv "$file" | md5)
    else
        file_hash=$(md5 "$file")
    fi

    write_line "$file_hash  $file"
done