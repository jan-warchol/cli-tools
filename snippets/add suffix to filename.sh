ext="pdf"
suffix="blah"

# here's one way to do this
for file in *.$ext; do
   mv "$file" "${file%%.$ext}$suffix.$ext"
done

# another way (by Franio).  This uses basename,
# so directories are not preserved (use only for files in ./)
for file in *.$ext; do 
    mv $file $(basename $file .$ext)$suffix.$ext
done

# yet another way.
ls *.$ext | xargs -I {} basename '{}' .$ext \
| xargs -I {} mv "{}.$ext" "{}$suffix.$ext"
