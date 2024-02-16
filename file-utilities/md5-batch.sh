#!/bin/bash

# Set the output file name
output_file="md5-checksums.txt"

# Create an empty output file
touch "$output_file"

# Iterate over the files in the current directory
for file in *; do
    # Skip the output file to avoid infinite loop
    if [[ "$file" == "$output_file" ]]; then
        continue
    fi
    
    # Calculate the MD5 checksum for the file
    file_hash=$(md5 "$file")
    
    # Write the checksum and file name to the output file
    echo "$file_hash" >> "$output_file"
done