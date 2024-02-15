#!/bin/sh
# Compresses a PDF made of scanned images in grayscale
#
# USAGE:
# >>> pdfshrink input.pdf output.pdf
#
# Some options:
# -dPDFSETTINGS=/screen for lowest quality
# -dPDFSETTINGS=/ebook for slightly better quality
# Delete the above parameters for the high quality default
#
# Ref.: http://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sProcessColorModel=DeviceGray -sColorConversionStrategy=Gray -sOutputFile=$2 $1
