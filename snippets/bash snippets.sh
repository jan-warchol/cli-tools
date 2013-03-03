﻿#! /bin/bash

VARIABLE="Let's test this string!"

# This is for regular expressions:
if [[ "$VARIABLE" =~ "Let's.*ring" ]]
then
    echo "matched"
else
    echo "nope"
fi

# And here we have Bash Patterns:
if [[ "$VARIABLE" == L*ing! ]]
then
    echo "matched"
else
    echo "nope"
fi


#!/bin/bash

date=$(date +"_%Y-%m-%d_%H-%M")

branchname=$(git branch | sed --quiet 's/* \(.*\)/\1/p')
text="results-"
result_dir=$text$branchname$date

for file in $(find); do
    touch $file
done


# if [ $? = 0 ];


aplay -q /usr/share/games/chromium-bsu/wav/boom.wav    # zagraj grzmot

mv "$file" "${file%%.rozszerzenie} zakończenie.rozszerzenie"    # dodaj " zakończenie" do nazwy pliku
for i in *.pdf; do mv -f "$i" "../`basename "$i" ".pdf"`"coś.pdf; done      # albo tak (by Franio)

ls *.pdf | xargs -I {} basename '{}' .pdf | xargs -I {} mv '{}.pdf' '{} new.pdf'   # dodaj " new" do wszystkich pdfów w katalogu

$1 $2 $3 - n-th argument
$# - number of arguments
-z - true if a string is empty
-n - true if a string is not empty
[ -n "$1" ] - true if 1st argument is not empty. will not work without double quotes.

$? - exit code of last executed command

case $bla in
  *) #this would be a default action when there are no matches
  
#advanced examples of case usage 
#http://www.thegeekstuff.com/2010/07/bash-case-statement/

