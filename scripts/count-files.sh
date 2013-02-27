# count how many files there are in each subdir

IFS=$(echo -en "\n\b")

echo ""
for dir in $(find -mindepth 1 -maxdepth 1 -type d); do
    cd $dir
    echo $(find ./ -maxdepth 99 -type f | wc -l) $dir
    find . -type f -printf "%h\n" | cut -d/ -f-2 | sort | uniq -c | sort -rn
    cd ..
    echo ""
done


