#!/usr/bin/env bash
set -euo pipefail

# Recursively convert all .ipynb files under the current directory to Markdown.
# Shows an overall progress bar: converted_count / total_notebooks.
# Skips generating extracted output figures (no *_files/ image assets).
#
# Requirements: jupyter (nbconvert) installed and on PATH.

if ! command -v jupyter >/dev/null 2>&1; then
  echo "Error: 'jupyter' not found on PATH. Install Jupyter (nbconvert) first." >&2
  exit 1
fi

cleanup() { printf '\n'; }
trap cleanup EXIT

render_bar() {
  local current="$1" total="$2" width="${3:-30}"
  local percent filled empty
  if (( total == 0 )); then
    percent=100
    filled=$width
  else
    percent=$(( current * 100 / total ))
    filled=$(( current * width / total ))
  fi
  empty=$(( width - filled ))

  local bar=""
  for ((i=0; i<filled; i++)); do bar+="#"; done
  for ((i=0; i<empty; i++));  do bar+="-"; done

  printf '\r[%s] %3d%% (%d/%d)' "$bar" "$percent" "$current" "$total"
}

# Count notebooks (null-delimited to safely handle any filenames).
total="$(
  find . -type f -name '*.ipynb' ! -path '*/.ipynb_checkpoints/*' -print0 \
    | tr -cd '\0' | wc -c | tr -d '[:space:]'
)"

if [[ "$total" == "0" ]]; then
  echo "No .ipynb notebooks found under $(pwd)"
  exit 0
fi

converted=0
render_bar "$converted" "$total" 30

while IFS= read -r -d '' nb; do
  dir="$(dirname "$nb")"
  base="$(basename "$nb" .ipynb)"

  jupyter nbconvert --to markdown \
    --ExtractOutputPreprocessor.enabled=False \
    --output-dir "$dir" \
    --output "$base" \
    "$nb" >/dev/null

  ((converted++))
  render_bar "$converted" "$total" 30
done < <(
  find . -type f -name '*.ipynb' ! -path '*/.ipynb_checkpoints/*' -print0
)

printf '\nDone.\n'