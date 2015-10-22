#!/bin/bash
#
# Script that sets up the Overleaf git server and a possible
# Github server as well for your latex paper. You first need to
# create an overleaf project for this to work.
#
# https://ineed.coffee/3454/how-to-synchronize-an-overleaf-latex-paper-with-a-github-repository/

# Gets URLs of git servers
read -p "Overleaf git server: " overleaf # click share button in your project
read -p "Github or BitBucket server: " github # address of git project
read -p "Destination folder name: " folder 

# Downloads overleaf project 
git clone $overleaf $folder
git remote rename origin overleaf

# Adds Github server
git remote add github $github

# Be able to push to both overleaf and github (git push both)
git remote add both $overleaf
git remote set-url --add --push both $overleaf
git remote set-url --add --push both $github

