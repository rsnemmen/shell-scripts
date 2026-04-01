#!/usr/bin/env bash
#
# Generate MD5 hashes for all regular files in the current directory.
#
# Options:
#   -o FILE   Write checksums to FILE instead of stdout
#   -h        Show this help and exit
#
# If pv(1) is available, it is used to display per-file progress.

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

# Pick the available MD5 tool; normalise output to a bare hash via a wrapper.
# md5sum (Linux): "hash  file" or "hash  -" from stdin
# md5    (macOS): "MD5 (file) = hash", but -q prints just the hash
if command -v md5sum &>/dev/null; then
    _md5_hash() { md5sum "$1" | awk '{print $1}'; }
    _md5_hash_stdin() { md5sum | awk '{print $1}'; }
elif command -v md5 &>/dev/null; then
    _md5_hash() { md5 -q "$1"; }
    _md5_hash_stdin() { md5; }
else
    printf 'Error: neither md5sum nor md5 found in PATH\n' >&2
    exit 1
fi

# Create/truncate the output file only if one was requested.
if [[ -n "$output_file" ]]; then
    : > "$output_file"
fi

##############################################################################
# Helper functions
##############################################################################
write_line() {
    # $1 = line to write
    if [[ -n "$output_file" ]]; then
        printf '%s\n' "$1" >> "$output_file"
    else
        printf '%s\n' "$1"
    fi
}

# ANSI color codes (bold cyan for filenames)
clr_cyan='\033[1;36m'
clr_reset='\033[0m'

print_processing() {
    # $1 = filename
    printf 'Processing: %b%s%b\n' "$clr_cyan" "$1" "$clr_reset" >&2
}

##############################################################################
# Main loop
##############################################################################
for file in *; do
    # Skip the output file itself, directories, and non-regular files
    [[ -n "$output_file" && "$file" == "$output_file" ]] && continue
    [[ -d "$file"      || ! -f "$file" ]] && continue

    print_processing "$file"

    # Compute checksum (always a bare hash)
    if $use_pv; then
        file_hash=$(pv "$file" | _md5_hash_stdin)
    else
        file_hash=$(_md5_hash "$file")
    fi

    write_line "$file_hash  $file"
done