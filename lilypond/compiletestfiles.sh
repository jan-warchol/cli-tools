#!/bin/bash

cd ../test-files/

# compile test files with current master and give them "current" suffix
    mkdir -p tempor
    cd tempor/

    ../../clean-master/build/out/bin/lilypond ../*.ly

    for file in *.pdf; do
      mv "$file" "${file%%.pdf} current.pdf"
      echo " "
    done 

    cd ../
    mv tempor/* ./
    rm -r tempor/

    echo " "
    echo " "

# compile test files with lilypond from git and give them "new" suffix
mkdir -p tempor
cd tempor/

../../lilypond-git/build/out/bin/lilypond ../*.ly

for file in *.pdf; do
  mv --force "$file" "${file%%.pdf} new.pdf"
  echo " "
done 

cd ../
mv tempor/* ./
rm -r tempor/


aplay -q ~/src/sznikers.wav
