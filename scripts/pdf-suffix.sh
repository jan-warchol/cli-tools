#!/bin/bash

# add the argument of this script as the suffix to all pdfs in ./

for file in *.pdf; do
  echo "adding $1 to $file"
  mv --force "$file" "${file%%.pdf} $1.pdf"
done 
