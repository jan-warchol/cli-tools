#!/bin/bash

# support filenames with spaces
IFS=$(echo -en "\n\b")

# we only want to rename files, not directories
for f in $(find -type f); do
  # get the extension - if the file doesn't have extension,
  # $ext should be empty!
  ext=$(echo $f | sed 's|.*/||' | sed 's/.[^.]*//' | sed 's/.*\./\./')
  modif_date=$(stat -c %y $f | sed 's/^\([0-9\-]*\).*/\1/')
  mv "$f" "${f%%$ext}($modif_date)$ext"
done
