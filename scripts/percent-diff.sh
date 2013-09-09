#!/bin/bash

ext="txt"

# support filenames with spaces:
IFS=$(echo -en "\n\b")

working_dir="$PWD"
working_dir_name=$(echo $working_dir | sed 's|.*/||')
all_files="$working_dir/../$working_dir_name-filelist.txt"
remaining_files="$working_dir/../$working_dir_name-remaining.txt"

# get information about files:
find -type f -print0 | xargs -0 stat -c "%s %n" | grep -v "/\." | \
     grep "\.$ext" | sort -nr > $all_files

cp $all_files $remaining_files

while read string; do
    fileA=$(echo $string | sed 's/.[^.]*\./\./')
    tail -n +2 "$remaining_files" > $remaining_files.temp
    mv $remaining_files.temp $remaining_files

    echo Comparing $fileA with other files...

    while read string; do
        fileB=$(echo $string | sed 's/.[^.]*\./\./')

        A_len=$(cat "$fileA" | wc -l)
        B_len=$(cat "$fileB" | wc -l)
        if [[ $A_len>$B_len ]]; then
            bigger=$fileA
            smaller=$fileB
            max_len=$A_len
            min_len=$B_len
        else
            bigger=$fileB
            smaller=$fileA
            max_len=$B_len
            min_len=$A_len
        fi

        differences=$(sdiff -B -s "$fileA" "$fileB" | wc -l)
        common=$(expr $max_len - $differences)

        percentage=$(echo "100 * $common / $min_len" | bc)
        if [[ $percentage -gt 20 ]]; then
            echo "  $percentage% duplication in" \
                 "$(echo $smaller | sed 's|\./||')"
        fi
    done < "$remaining_files"
    echo " "
done < "$all_files"
