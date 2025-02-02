#!/bin/bash
# -----------------------------------------------------------------------------
# Script: chd-from-iso.sh
#
# Description:
#   This script converts all disk image files with a specified extension (e.g., iso, cue)
#   in the current directory to CHD (Compressed Hunks of Data) format using the
#   'chdman' tool. It performs a dependency check to ensure 'chdman' is available,
#   validates the provided file extension, and processes each matching file.
#
# Requirements:
#   - chdman must be installed and accessible in the system's PATH.
#
# Example:
#   ./chd-from-iso.sh cue
#
# -----------------------------------------------------------------------------

# Check if chdman is installed and available
if ! command -v chdman &> /dev/null; then
  echo "Error: chdman is not installed or not in your PATH."
  echo "Please install chdman and try again."
  exit 1
fi

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "Error: You must provide an input file extension (e.g., iso, cue, etc.)."
  echo "Usage: chd-from-iso.sh <extension>"
  exit 1
fi

# Get the input extension from the argument
input_extension=$1

# Find all files in the current directory with the given extension
files=(*.$input_extension)

# Check if any files were found
if [ -z "${files[0]}" ]; then
  echo "No files with the extension .$input_extension found in the current directory."
  exit 1
fi

# Loop through each file and convert to CHD format
for file in "${files[@]}"; do
  # Get the base name of the file (without the extension)
  base_name="${file%.*}"
  
  # Convert to CHD using chdman
  chdman createcd -i "$file" -o "$base_name.chd"
  
  # Check if the conversion was successful
  if [ $? -eq 0 ]; then
    echo "Converted $file to $base_name.chd successfully."
  else
    echo "Failed to convert $file."
  fi
done