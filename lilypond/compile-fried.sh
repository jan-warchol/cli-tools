#!/bin/bash

# first argument - opus pattern to use
if [ "$1" != "" ]; then opus=$1; else opus="0[1-4]"; fi

# second argument - lily version to use
if [ "$2" != "" ]; then lily=$2; else lily=$defaultlily; fi

echo "========================================"

for file in $(find $opus* -name "*standalone.ly"); do
    echo "compiling $file with $lily..."
    $LILYPOND_BUILD_DIR/$lily/out/bin/lilypond --loglevel=ERROR $file
    echo "----------------------------------------"
done

ext="pdf"
suffix=" $lily"

for file in *.$ext; do
   mv "$file" "${file%%.$ext}$suffix.$ext"
done

rm *.midi
mkdir -p ../$lily
mv *.$ext ../$lily
