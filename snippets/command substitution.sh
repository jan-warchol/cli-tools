# enclosing some commands in backticks - e.g. like this
for branch in `git branch | sed s/*//`; do
# is an old syntax for command substitution (i.e. to make
# the ouput of one command be the input for another command)
# it's better to use $() syntax - like this: 
for branch in $(git branch | sed s/*//); do
# unless your shell doesn't support it.
