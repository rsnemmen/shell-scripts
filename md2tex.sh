#!/bin/sh
#
# Convert Markdown to LaTeX 
#

# Captures the date for later use
date=`date +"%m-%d-%y-%H%M"`

# Move into the build folder
#cd ~/Documents/dissertation/0_build/ 

# Gather the files which together constitute a dissertation into one place.
#cat ~/Documents/dissertation/will_dissertation.md > disbuild.md

# Run Pandoc to turn the markdown file with the bulk of the document into a .TeX file
#pandoc -f markdown --latex-engine=xelatex -R -i disbuild.md -o pandocked.tex
pandoc -R -i test.md -o test.tex

# Remove some of the junk that Markdown adds when converting to TeX.
#sed -i .bak 's/\[<+->\]//g' ~/Documents/dissertation/0_build/pandocked.tex
#sed -i .bak 's/\\def\\labelenumi{\\arabic{enumi}.}//g' ~/Documents/dissertation/0_build/pandocked.tex
#sed -i .bak 's/\\itemsep1pt\\parskip0pt\\parsep0pt//g' ~/Documents/dissertation/0_build/pandocked.tex

# This turns the word "F0" into a pretty version, with a subscript.
#perl -pi -w -e 's/F0/F\$_{0}\$/g;' ~/Documents/dissertation/0_build/pandocked.tex

# Concatenate the header file (with the preambles, TOC, etc), the pandoc-created TeX file, and the footer file (with the bibliography) into a single buildable TeX file
#cat ~/Documents/dissertation/0_build/header.tex ~/Documents/dissertation/0_build/pandocked.tex ~/Documents/dissertation/0_build/footer.tex > ~/Documents/dissertation/0_build/Stylerdissertation.tex

# Build the TeX once without stopping for errors (as the hyperref plugin throws errors on the first run)
#pdflatex --file-line-error --synctex=1 main

# Render the bibliography based on the prior file
#bibtex main

# Render the file twice more, to ensure that the bibliographical references are included and that the TOC reflects everything accurately
#pdflatex --file-line-error --synctex=1 main
#pdflatex --file-line-error --synctex=1 main

# Open the PDF generated in my PDF reader of choice
#open /Applications/Skim.app ~/Documents/dissertation/0_build/Stylerdissertation.pdf
