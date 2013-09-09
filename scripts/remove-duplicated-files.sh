#!/bin/bash

# this script walks through all files in the current directory,
# checks if there are duplicates (it compares only files with
# the same size) and moves duplicates to $duplicates_dir.
#
# options:
# -H  remove hidden files (and files in hidden folders)
# -n  dry-run: show duplicates, but don't remove them
# -z  deduplicate empty/very small (0-5 bytes) files as well

while getopts "Hnz" opts; do
    case $opts in
    H)
        remove_hidden="yes";;
    n)
        dry_run="yes";;
    z)
        remove_empty="yes";;
    esac
done

# support filenames with spaces:
IFS=$(echo -en "\n\b")

working_dir="$PWD"
working_dir_name=$(echo $working_dir | sed 's|.*/||')

# prepare some temp directories:
filelist_dir="$working_dir/../$working_dir_name-filelist/"
duplicates_dir="$working_dir/../$working_dir_name-duplicates/"
if [[ -d $filelist_dir || -d $duplicates_dir ]]; then
    echo "ERROR! Directories:"
    echo "  $filelist_dir"
    echo "and/or"
    echo "  $duplicates_dir"
    echo "already exist!  Aborting."
    exit 1
fi
mkdir $filelist_dir
if [[ -z $dry_run ]]; then
    mkdir $duplicates_dir
fi

# get information about files:
find -type f -print0 | xargs -0 stat -c "%s %n" | \
     sort -nr > $filelist_dir/filelist.txt

if [[ "$remove_hidden" != "yes" ]]; then
    grep -v "/\." $filelist_dir/filelist.txt > $filelist_dir/no-hidden.txt
    mv $filelist_dir/no-hidden.txt $filelist_dir/filelist.txt
fi

echo "$(cat $filelist_dir/filelist.txt | wc -l)" \
     "files to compare in directory $working_dir"
echo "Creating file list..."

# divide the list of files into sublists with files of the same size
while read string; do
    number=$(echo $string | sed 's/\..*$//' | sed 's/ //')
    filename=$(echo $string | sed 's/.[^.]*\./\./')
    echo $filename >> $filelist_dir/size-$number.txt
done < "$filelist_dir/filelist.txt"

# plough through the files
for filesize in $(find $filelist_dir -type f | grep "size-"); do
    if [[ -z $remove_empty && $filesize == *size-[0-5].txt ]]; then
        continue
    fi

    filecount=$(cat $filesize | wc -l)
    # there are more than 1 file of particular size ->
    # these may be duplicates
    if [ $filecount -gt 1 ]; then
        if [ $filecount -gt 200 ]; then
            echo ""
            echo "Warning: more than 200 files with filesize" \
                 $(echo $filesize | sed 's|.*/||' | \
                 sed 's/size-//' | sed 's/\.txt//') \
                 "byte(s)."
            echo "Since every file may need to be compared with"
            echo "every other file, this may take a long time."
        fi

        for fileA in $(cat $filesize); do
            if [ -f "$fileA" ]; then
                for fileB in $(cat $filesize); do
                    if [ -f "$fileB" ] && [ "$fileB" != "$fileA" ]; then
                        # diff will exit with 0 iff files are the same.
                        diff -q "$fileA" "$fileB" 2> /dev/null > /dev/null
                        if [[ $? == 0 ]]; then
                            # detect if one filename is a substring of another
                            # so that in case of foo.txt and foo(copy).txt
                            # the script will remove foo(copy).txt
                            # supports filenames with no extension.

                            fileA_name=$(echo $fileA | sed 's|.*/||')
                            fileB_name=$(echo $fileB | sed 's|.*/||')
                            fileA_ext=$(echo $fileA_name | sed 's/.[^.]*//' | sed 's/.*\./\./')
                            fileB_ext=$(echo $fileB_name | sed 's/.[^.]*//' | sed 's/.*\./\./')
                            fileA_name="${fileA_name%%$fileA_ext}"
                            fileB_name="${fileB_name%%$fileB_ext}"

                            if [[ $fileB_name == *$fileA_name* ]]; then
                                echo "  $(echo $fileB | sed 's|\./||')" \
                                    "is a duplicate of" \
                                    "$(echo $fileA | sed 's|\./||')"
                                if [ "$dry_run" != "yes" ]; then
                                    mv --backup=t "$fileB" $duplicates_dir
                                fi
                            else
                                echo "  $(echo $fileA | sed 's|\./||')" \
                                    "is a duplicate of" \
                                    "$(echo $fileB | sed 's|\./||')"
                                if [ "$dry_run" != "yes" ]; then
                                    mv --backup=t "$fileA" $duplicates_dir
                                fi
                            fi
                        fi
                    fi
                done
            fi
        done
    fi
done

rm -r $filelist_dir

if [ "$dry_run" != "yes" ]; then
    echo "Duplicates moved to $duplicates_dir."
fi
