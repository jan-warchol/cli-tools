#!/usr/bin/env python

# This will move/rename files and directories.
# If you want to use wildcards, enclose args in double-quotes.
# It doesn't return an error if the file didn't exist.

# The glob module finds all the pathnames matching a specified
# pattern according to the rules used by the Unix shell.

from sys import argv
import os, shutil, glob, sys

if len(sys.argv) !=3:
    print 'Error: wrong number of arguments (there should be 2)'
    exit(1)

src = argv[1]
dest = argv[2]

# create intermediate directories if necessary..
dest_dir = os.path.dirname(dest)
if dest_dir and not os.path.exists(dest_dir):
    print 'creating directory', os.path.dirname(dest), '...'
    os.mkdir(dest_dir)

# move stuff.
for stuff in glob.glob(src):
    print 'moving', stuff, 'to', dest, '...'
    shutil.move(stuff, dest)
