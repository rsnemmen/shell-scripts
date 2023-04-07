#!/bin/sh
#
# Convert Markdown with LaTeX directives to a PDF file. 
#
# Requirements: pandoc
#
# Run this inside your document folder:
#		md2tex.sh <MARKDOWN FILE> <OUTPUT FILE>
#
# where:
# - <MARKDOWN FILE>: name of markdown document 
# - <OUTPUT FILE>: PDF filename
#

# check if there were command-line arguments
if [ $# -eq 0 ]; then
    echo "Usage: "
    echo "  mdtex.sh <MARKDOWN FILE> <OUTPUT FILE> "
    exit 1
fi

pandoc --verbose --from=markdown --output=$2 $1 --variable=geometry:"margin=0.5cm, paperheight=500pt, paperwidth=400pt" --highlight-style=espresso --pdf-engine=xelatex

