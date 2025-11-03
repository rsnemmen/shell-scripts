#!/bin/bash

# YouTube Video Extractor
#
# Extracts title, description, and transcript from a YouTube video using yt-dlp.
#
# Usage: ./youtube_extract.sh <youtube_url> [subtitle_lang]
#   - subtitle_lang: Optional. Defaults to "en" if not provided (e.g., es, fr, en-US)
#
# Requirements: yt-dlp, awk
#
# Output files:
#   - title_description.txt: Video title and description
#   - transcript.txt: Clean transcript text (no timestamps/formatting)
#
# Example:
#   ./youtube_extract.sh "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
#   ./youtube_extract.sh "https://www.youtube.com/watch?v=dQw4w9WgXcQ" es

# Check if URL is provided
if [ $# -lt 1 ]; then
    echo "Error: No YouTube URL provided"
    echo "Usage: $0 <youtube_url> [subtitle_lang]"
    exit 1
fi

URL="$1"
SUB_LANG="${2:-en}"

echo "Processing YouTube video: $URL"
echo "Using subtitle language: $SUB_LANG"

# Get title and description
echo "Fetching title and description..."
yt-dlp --get-title --get-description "$URL" | tee title_description.txt

# Download subtitles
echo "Downloading subtitles..."
yt-dlp --skip-download --write-subs --write-auto-sub --sub-lang "$SUB_LANG" --convert-subs srt -o "subtitles" "$URL"

# Process subtitles to create transcript
SUB_FILE="subtitles.${SUB_LANG}.srt"

echo "Creating transcript..."
if [ -f "$SUB_FILE" ]; then
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
    }' "$SUB_FILE" > transcript.txt
    echo "Transcript created successfully!"
    # Clean up the subtitle file
    rm -f "$SUB_FILE"
else
    echo "Warning: Subtitle file not found for language '$SUB_LANG'. Transcript may not be available for this video."
fi

# Remove duplicate lines in transcript if it exists
if [ -f "transcript.txt" ]; then
    awk '!seen[$0]++' transcript.txt > temp.txt && mv temp.txt transcript.txt
    echo "Done! Created files: title_description.txt and transcript.txt"
else
    echo "Done! Created file: title_description.txt (no transcript generated)"
fi