#!/bin/bash

set -e

# Define the docstring/usage function
usage() {
    cat << 'EOF'
Usage: split_to_letter.sh [OPTIONS] <input_image.png>

Slices a tall image into multiple US Letter-sized pages and compiles them 
into a perfectly scaled, multipage PDF.

Options:
    -h, --help      Show this help message and exit

Dependencies:
    ImageMagick 7 (magick)

Behavior:
    1. Reads the pixel width (W) of the input image.
    2. Calculates slice height (H) to exactly match an 8.5x11 aspect ratio.
    3. Slices the image sequentially into WxH chunks.
    4. Pads the final chunk with white space to prevent printer stretching.
    5. Sets PDF DPI so the document natively registers as 8.5x11 inches.

Note:
    Assumes borderless printing. For printers with forced hardware margins, 
    edit the PAGE_W and PAGE_H variables in the script to match the safe 
    printable area (e.g., 8.0 x 10.5) to prevent "Scale to Fit" shrinking.
EOF
    exit 0
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Check for missing arguments
if [ -z "$1" ]; then
    echo "Error: Missing input file."
    echo "Run '$0 --help' for usage information."
    exit 1
fi

IMG="$1"
BASENAME="${IMG%.*}"

# Letter size dimensions in inches
PAGE_W=8.5
PAGE_H=11.0

echo "Processing '$IMG'..."

# 1. Get the exact image width in pixels
W=$(magick identify -format "%w" "$IMG")

# 2. Calculate the pixel height for each chunk to perfectly match a Letter aspect ratio
H=$(awk "BEGIN {printf \"%d\", $W * ($PAGE_H / $PAGE_W)}")

# 3. Calculate the exact DPI required so the PDF metadata specifies 8.5 inches wide
DPI=$(awk "BEGIN {printf \"%d\", $W / $PAGE_W}")

echo "➔ Image Width: $W px"
echo "➔ Chunk Height: $H px"
echo "➔ Target DPI: $DPI"

# 4. Slice, pad, and convert directly to a multipage PDF in one command
magick "$IMG" \
    -crop ${W}x${H} +repage \
    -gravity North -background white -extent ${W}x${H} \
    -units PixelsPerInch -density $DPI \
    "${BASENAME}_printable.pdf"

echo "➔ Success! Created: ${BASENAME}_printable.pdf"