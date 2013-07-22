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


