
# sort by unix-timeformat modification date, exclude hidden files and choose only specific extension.
find . -type f -printf '%T@ %p\n' | grep -v "\.\/\." | sort -k 1nr | sed 's/^[^ ]* //' | grep -E "\.pdf|\.txt|\.png" | head -n 100
