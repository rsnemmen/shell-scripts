#!/bin/bash
#
# This script generates md5 hashes for all files in the current directory.
# If pv is available, it uses it to show progress for each md5 operation.

# Set the output file name
output_file="md5-checksums.txt"

# Create an empty output file
touch "$output_file"

# Check if the `pv` command is available
if command -v pv &> /dev/null; then
    use_pv=true
else
    use_pv=false
fi

# Iterate over the files in the current directory
for file in *; do
    # Skip the output file to avoid infinite loop
    if [[ "$file" == "$output_file" ]]; then
        continue
    fi

    # Skip directories
    if [[ -d "$file" ]]; then
        continue
    fi

    # Generate the MD5 checksum
    if [[ "$use_pv" == true ]]; then
        # Use pv to show progress
        file_hash=$(pv "$file" | md5)
    else
        # Use md5 without progress
        file_hash=$(md5 "$file")
    fi

    # Write the checksum and file name to the output file
    echo "$file_hash  $file" >> "$output_file"
done