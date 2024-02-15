#!/bin/sh
# 
# Clear latex files
echo "Cleaning non-essential LaTeX files..."
rm -vf *~ *.aux *.log *.bbl *.blg *.lof *.lot *.toc *.dvi *.bak *.gz *.out
echo "Done!"
