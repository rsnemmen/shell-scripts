#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name: remove_string_from_filenames.sh
#
# Description:
# This script removes a specified input string (case-insensitively) from the 
# filenames of all files in the current directory. It skips directories and 
# only processes regular files. Any modified filenames are displayed in the 
# terminal, and if no files are modified, a message is shown.
#
# Usage:
#   ./remove_string_from_filenames.sh "<input_string>"
#
# Arguments:
#   <input_string> - The string to remove from filenames (case-insensitive).
#
# Requirements:
#   - The script must be run in a directory where you have write permissions.
#   - Ensure the input string is quoted if it contains spaces.
#
# Example:
#   Suppose the current directory contains the following files:
#     - "file with spaces.txt"
#     - "another file with spaces.txt"
#     - "some_other_file.txt"
#
#   Running the script:
#     ./remove_string_from_filenames.sh "with spaces"
#
#   Result:
#     - "file with spaces.txt" -> "file.txt"
#     - "another file with spaces.txt" -> "another file.txt"
#     - "some_other_file.txt" remains unchanged.
#
# Output:
#   - Renamed files are displayed in the format:
#       Renamed: 'old_filename' -> 'new_filename'
#   - If no files are modified, the script displays:
#       No files were modified.
#
# Error Handling:
#   - If the script is called without arguments, it displays usage instructions.
#   - If the input string is empty, the script exits with an error.
#
# Limitations:
#   - The script does not recursively process files in subdirectories.
#   - Filenames that match the input string entirely are not renamed (e.g., 
#     "example" would not be renamed to an empty filename).
#
# -----------------------------------------------------------------------------

# Ensure the script is being called with the correct number of arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 \"<input_string>\""
  exit 1
fi

# Input string (case insensitive)
input_string=$1

# Check if input string is empty
if [ -z "$input_string" ]; then
  echo "Error: Input string cannot be empty."
  exit 1
fi

# Flag to track whether any files were modified
modified_files=false

# Iterate over all files in the current directory
for file in *; do
  # Skip directories
  if [ -d "$file" ]; then
    continue
  fi

  # Use `tr` to make the input string lowercase for case-insensitive comparison
  lower_input_string=$(echo "$input_string" | tr '[:upper:]' '[:lower:]')

  # Create the new filename by removing the input string, case-insensitively
  new_file=$(echo "$file" | sed "s/$lower_input_string//Ig")

  # Rename the file only if the new filename is different
  if [ "$file" != "$new_file" ]; then
    mv "$file" "$new_file"
    echo "Renamed: '$file' -> '$new_file'"
    modified_files=true
  fi
done

# If no files were modified, display a message
if [ "$modified_files" = false ]; then
  echo "No files were modified."
else
  echo "Renaming complete."
fi