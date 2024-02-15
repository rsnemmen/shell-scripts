#!/bin/sh
echo 'Word count for Science paper. Output of texcount command.'
echo
echo 'Main text'
echo '=========='
echo '(<2500 words)'
awk -f counttext.awk science.tex > tmp
texcount tmp
echo 'Abstract'
echo '========='
echo '(<125 words)'
awk -f countabs.awk science.tex > tmp
texcount tmp
rm -f tmp