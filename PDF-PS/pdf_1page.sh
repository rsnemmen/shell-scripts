#!/bin/sh
# Extract first page of each PDF and put in another folder

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Error: No directory name provided."
  echo "Please provide the name of the directory as a command-line argument."
  exit 1
fi

# Get the directory name from the command-line argument
dirname=$1

# Create the directory
mkdir "$dirname"

# Check if the directory was created successfully
if [ $? -eq 0 ]; then
  echo "Directory '$dirname' created successfully."
else
  echo "Error: Failed to create directory '$dirname'."
  exit 1
fi

for X in $( ls -1 *.pdf )
do
	pdftk $X cat 1 output $dirname/$X
done
