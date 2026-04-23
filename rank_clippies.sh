#!/bin/bash
# Generates Clippy rankings for posting to my "Clippies" cheatsheet.
# Also updated ranking plots.
#
# rank_clippies.sh | pbcopy
set -euo pipefail

CANDIDATES=(
  "$HOME/Dropbox/codes/python_projects/ai/LLM_rank"
  "$HOME/codes/python_projects/ai/LLM_rank"
)

DIR=""
for candidate in "${CANDIDATES[@]}"; do
  if [[ -x "$candidate/rank_models.py" ]]; then
    DIR="$candidate"
    break
  fi
done

if [[ -z "$DIR" ]]; then
  echo "Error: rank_models.py not found in any of:" >&2
  printf '  %s\n' "${CANDIDATES[@]}" >&2
  exit 1
fi
PATH_WEBSITE="/Users/nemmen/Dropbox/Documents/professional profile/website/rsnemmen.github.io/assets/img/clippies"

print_banner() {
  local title="$1"
  echo "+--------------------+"
  printf "|    %-14s|\n" "$title"
  echo "+--------------------+"
}

print_banner "GENERAL"
"$DIR/rank_models.py" -p -q "$DIR/data/general.txt"

print_banner "CODING"
"$DIR/rank_models.py" -p -q "$DIR/data/coding.txt"

# Move PNGs only if they exist
shopt -s nullglob
pngs=("$DIR/data/"*png)
if ((${#pngs[@]})); then
  cp "${pngs[@]}" "$PATH_WEBSITE/"
  mv "${pngs[@]}" "$DIR/figures/"
fi
