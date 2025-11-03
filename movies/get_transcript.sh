#!/bin/bash

# YouTube Video Extractor
# 
# Extracts title, description, and transcript from a YouTube video using yt-dlp.
#
# Usage: ./youtube_extract.sh <youtube_url>
#
# Requirements: yt-dlp, awk
#
# Output files:
#   - title_description.txt: Video title and description
#   - transcript.txt: Clean transcript text (no timestamps/formatting)
#
# Example: ./youtube_extract.sh "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No YouTube URL provided"
    echo "Usage: $0 <youtube_url>"
    exit 1
fi

URL="$1"

echo "Processing YouTube video: $URL"

# Get title and description
echo "Fetching title and description..."
yt-dlp --get-title --get-description "$URL" | tee title_description.txt

# Download subtitles
echo "Downloading subtitles..."
yt-dlp --skip-download --write-subs --write-auto-sub --sub-lang en --convert-subs srt -o "subtitles" "$URL"

# Process subtitles to create transcript
echo "Creating transcript..."
if [ -f "subtitles.en.srt" ]; then
    awk '
    # Skip subtitle sequence numbers (lines with only digits)
    /^[0-9]+$/ { next }
    
    # Skip timestamp lines (contains -->)
    /-->/ { next }
    
    # Skip empty lines
    /^[[:space:]]*$/ { next }
    
    # Process subtitle text lines
    {
        # Remove HTML tags
        gsub(/<[^>]*>/, "")
        
        # Remove leading/trailing whitespace
        gsub(/^[[:space:]]+|[[:space:]]+$/, "")
        
        # Skip if line becomes empty after cleaning
        if (length($0) == 0) next
        
        # Print the cleaned line
        print $0
    }' subtitles.en.srt > transcript.txt
    echo "Transcript created successfully!"
    # Clean up the subtitle file
    rm subtitles.en.srt
else
    echo "Warning: Subtitle file not found. Transcript may not be available for this video."
fi

echo "Done! Created files: title_description.txt and transcript.txt"

# removes duplicate lines
awk '!seen[$0]++' transcript.txt > temp.txt
mv temp.txt transcript.txt