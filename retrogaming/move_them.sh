#!/bin/bash

# Get the current working directory
current_dir=$(pwd)

# Find all files in subdirectories (ignoring the current directory itself)
# and move them to the current directory
find "$current_dir" -type f -exec mv {} "$current_dir" \;

# Optional: Remove any empty directories left behind
find "$current_dir" -type d -empty -delete

echo "All files have been moved to $current_dir, and empty directories have been cleaned up."