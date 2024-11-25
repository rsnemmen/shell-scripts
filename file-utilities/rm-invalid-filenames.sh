#!/bin/bash
#
# This script removes all files with filenames containing non-alphanumeric characters.
# I created it specially for removing files with russian characters for creating an
# OpenBOR pak file.

# Set a flag to indicate dry-run mode
dry_run=false

# Check for the --dry-run argument
if [[ "$1" == "--dry-run" ]]; then
  dry_run=true
fi

# Function to process a directory (and its subdirectories recursively)
process_directory() {
  local dir="$1"

  # Loop through all files and subdirectories in the given directory
  for item in "$dir"/*; do
    # Check if the item is a directory
    if [[ -d "$item" ]]; then
      # Extract the directory name
      dirname=$(basename "$item")

      # Check if the directory name contains invalid characters
      if [[ "$dirname" =~ [^a-zA-Z0-9_.-] ]]; then
        # Print the directory name
        echo "Invalid directory name: $item"

        # Delete the directory and its contents if not in dry-run mode
        if ! $dry_run; then
          rm -rf "$item"
        fi
      else
        # Recursively process the subdirectory
        process_directory "$item"
      fi
    else
      # If it's a file, process it as before
      filename=$(basename "$item")
      if [[ "$filename" =~ [^a-zA-Z0-9_.-] ]]; then
        echo "Invalid filename: $item"
        if ! $dry_run; then
          rm "$item"
        fi
      fi
    fi
  done
}

# Start processing from the current directory
process_directory "."