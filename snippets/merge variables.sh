# glue two variables together
text="blah-"
date=$(date +"%Y-%m-%d")
concatenated=$text$date

echo $concatenated
