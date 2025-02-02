#!/bin/bash

# Script to download a file from Google Drive using wget
# Usage: ./gdrive_download.sh <FILE_ID> <OUTPUT_FILENAME>

# Check if the user provided the required arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <FILE_ID> <OUTPUT_FILENAME>"
  exit 1
fi

# Assign arguments to variables
FILE_ID="$1"
OUTPUT_FILENAME="$2"

# Inform the user that the download is starting
echo "Downloading file with ID: $FILE_ID"
echo "Saving as: $OUTPUT_FILENAME"

wget --no-check-certificate -r \
    "https://docs.google.com/uc?export=download&id=${FILE_ID}" \
    -O "${OUTPUT_FILENAME}"

