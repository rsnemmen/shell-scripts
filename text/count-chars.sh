#!/bin/bash
#
# Here's a shell script that takes a string as an argument and outputs both the number 
# of characters and words:

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide a string as an argument."
    echo "Usage: $0 \"Your string here\""
    exit 1
fi

# Store the input string
input_string="$1"

# Count characters (excluding newline)
char_count=$(echo -n "$input_string" | wc -m)

# Count words
word_count=$(echo "$input_string" | wc -w)

# Output the results
echo "Number of characters: $char_count"
echo "Number of words: $word_count"