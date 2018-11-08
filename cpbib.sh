#!/bin/bash
#
# Copies my bibtex references file to the current folder,
# removing all hyperlinks from the file along the way to avoid
# displaying the addresses with the latest ApJ latex template.
#
sed '/http/d' ~/work/mypapers/refs.bib > refs.bib