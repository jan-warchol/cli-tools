#!/bin/sh

# create a file 'testfile' using
# dd if=/dev/urandom of=testfile count=20 bs=1024k
# and run this script

i=0
 
while [ 1 ]
do
   md5sum testfile
   i=`expr $i + 1`
   echo "Iteration: $i"
done
