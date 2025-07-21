#!/usr/bin/env bash
# -------------------------------------------------------------------
# add_other_discs.sh – append missing discs + .m3u to a list file
#
# Usage:
#     ./add_other_discs.sh [listfile]
#
#   listfile  – ASCII text file that already contains one filename
#               per line (default: names.txt).
#
# The script:
#   • Scans every entry in the list file.
#   • If an entry contains “…(Disc N)… ” or “…(Disk N)…”
#       – appends any other *.chd discs that belong to the same game
#       – appends the matching .m3u playlist
#   • Never adds duplicates; safe to run multiple times.
# -------------------------------------------------------------------

set -euo pipefail

##############################################################################
# 1. Parse command-line argument
##############################################################################
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s LISTFILE\n' "${0##*/}" >&2
    exit 1
fi

names_file=$1

if [[ ! -f $names_file ]]; then
    printf 'ERROR: "%s" does not exist or is not a regular file.\n' "$names_file" >&2
    exit 1
fi

##############################################################################
# 2. Work in a temporary copy so we can deduplicate easily
##############################################################################
tmp="$(mktemp)"
cp -- "$names_file" "$tmp"

##############################################################################
# 3. Main loop: look at each filename already in the list
##############################################################################
while IFS= read -r file; do
    # Process only lines that contain (Disc N) or (Disk N)
    if [[ $file =~ (Disc|Disk)[[:space:]]*[0-9]+ ]]; then

        ######################################################################
        # 3a. Extract the "prefix" (everything before "(Disc N)" or "(Disk N)")
        ######################################################################
        prefix="$(printf '%s' "$file" \
                 | sed -E 's/[[:space:]]*\((Disc|Disk)[[:space:]]+[0-9]+\).*//')"
        prefix="${prefix% }"   # strip a possible trailing blank

        ######################################################################
        # 3b. Append every other disc (*.chd)
        ######################################################################
        for tag in Disc Disk; do
            for candidate in "$prefix"\ \("$tag"\ *\).chd ; do
                [[ -e $candidate ]] || continue    # glob produced nothing
                if ! grep -Fxq "$candidate" "$tmp"; then
                    echo "$candidate" >> "$tmp"
                fi
            done
        done

        ######################################################################
        # 3c. Append the matching .m3u, if present
        ######################################################################
        m3u="${prefix}.m3u"
        if [[ -e $m3u ]] && ! grep -Fxq "$m3u" "$tmp"; then
            echo "$m3u" >> "$tmp"
        fi
    fi
done < "$names_file"

##############################################################################
# 4. Replace the original list with the augmented version
##############################################################################
mv -- "$tmp" "$names_file"
echo "Updated \"$names_file\" successfully."