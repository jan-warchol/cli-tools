#!/bin/bash

cd ~/Host/integrals-test/Epifania

find -type d -iname "* *" | \
while read file; do \
mv "${file}" "${file// /_}"; \
done

echo " "

for dir in $(find -type d -iname "midi"); do
  rm -r -f $dir;
done

echo " "

find -type f -iname "* *.ly" | \
while read file; do \
mv "${file}" "${file// /_}"; \
done

aplay -q ~/src/sznikers.wav
