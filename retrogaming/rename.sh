#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Loop through all files in the current directory
for file in *; do
  # Check if the filename matches the pattern "<integer>. <name>.<extension>"
  if [[ "$file" =~ ^[0-9]+\.\ (.*)$ ]]; then
    # Extract the part of the filename after the "<integer>. "
    new_name="${BASH_REMATCH[1]}"
    
    # Rename the file
    mv "$file" "$new_name"
    
    # Print the old name in red and the new name in green
    echo -e "${RED}$file${NC} ${GREEN}→ $new_name${NC}"
  fi
done

echo "Renaming complete!"