# n-th script argument:
$1 $2 $3 

# number of arguments:
$#

# exit code of the last executed command:
$?

# returns true if $foo (a string) is empty:
[ -z $foo ]

# returns true if script's 1st argument is not empty:
[ -n "$1" ]
# (will not work without double quotes)

case $bla in
  *) #this would be a default action when there are no matches
  
# advanced examples of case usage 
# http://www.thegeekstuff.com/2010/07/bash-case-statement/


