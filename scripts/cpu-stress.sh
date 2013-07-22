#!/bin/sh

# create a 'testfile' containing random data
# and repeatedly calculate md5 hash of this file.

echo "Creating a test file..."
dd if=/dev/urandom of=testfile count=20 bs=1024k
echo "Test file created."
echo " "
sleep 2
echo "Testing. Please don't perform other CPU-consuming tasks."

i=1
count=100

START=$(date +%s.%N)

while [ $i -le $count ]
do
   echo "Iteration: $i"
   md5sum testfile >> /dev/null
   i=`expr $i + 1`
done

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)

echo "Time spent doing $count iterations: $DIFF seconds."
rm testfile
