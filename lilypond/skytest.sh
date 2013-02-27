#!/bin/bash

cd ~/skylines/
text="results-"
branchname=$(git branch | sed --quiet 's/* \(.*\)/\1/p')
date=$(date +"_%Y-%m-%d_%H-%M")

cd ~/Host/integrals-test/
result_dir=$text$branchname$date

mkdir -p $result_dir
cd $result_dir
mkdir -p master
mkdir -p skylines

echo " "

for file in $(find ../ -name "*.ly"); do
  cd master
  echo "PROCESSING " $file " WITH MASTER: --------------"
  time ~/clean-master/build/out/bin/lilypond --loglevel=NONE -ddebug-skylines=#t ../$file
  cd ../
  echo " "
  
  cd skylines
  echo "PROCESSING " $file " WITH SKYLINES: ------------"
  time ~/skylines/build/out/bin/lilypond --loglevel=NONE -ddebug-skylines=#t ../$file
  cd ../
  echo " "
  echo " "
done 

for file in master/*.pdf; do
  mv -f "$file" "${file%%.pdf} master.pdf"
done 
mv -f master/* ./
rm -r -f master

for file in skylines/*.pdf; do
  mv -f "$file" "${file%%.pdf} skylines.pdf"
done 
mv -f skylines/* ./
rm -r -f skylines


aplay -q ~/src/sznikers.wav
