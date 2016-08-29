#!/bin/sh
#
# Convert Markdown to LaTeX 
#
# Run this inside your document folder:
#		md2tex.sh <MARKDOWN FILE> <MAIN TEX FILE> 
#
# where:
# - <MAIN TEX FILE>: main latex file of your project
# - <MARKDOWN FILE>: meat of text written in markdown
#

# LaTeX command to render
tex="/Library/Tex/texbin/pdflatex"

# check if there were command-line arguments
if [ $# -eq 0 ]; then
    echo "Usage: "
    echo "  md2tex.sh <MARKDOWN FILE> <MAIN TEX FILE> "
    exit 1
fi

# Gets tex filename without extension
main=`basename $2 .tex`

# Run Pandoc to turn the markdown file with the bulk of the document into a .TeX file
#pandoc -f markdown --latex-engine=xelatex -R -i disbuild.md -o pandocked.tex
pandoc -R -i $1 -o text.tex

# Remove some of the junk that Markdown adds when converting to TeX.
#sed -i .bak 's/\[<+->\]//g' ~/Documents/dissertation/0_build/pandocked.tex
#sed -i .bak 's/\\def\\labelenumi{\\arabic{enumi}.}//g' ~/Documents/dissertation/0_build/pandocked.tex
#sed -i .bak 's/\\itemsep1pt\\parskip0pt\\parsep0pt//g' ~/Documents/dissertation/0_build/pandocked.tex

# Build the TeX once without stopping for errors (as the hyperref plugin throws errors on the first run)
${tex} --file-line-error --synctex=1 ${main}

# Render the bibliography based on the prior file
bibtex ${main}

# Render the file twice more, to ensure that the bibliographical references are included and that the TOC reflects everything accurately
${tex} --file-line-error --synctex=1 ${main}
${tex} --file-line-error --synctex=1 ${main}

# Open the PDF generated in my PDF reader of choice
#open /Applications/Skim.app ~/Documents/dissertation/0_build/Stylerdissertation.pdf
open ${main}.pdf