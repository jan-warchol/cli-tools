#!/usr/bin/python

# This script removes trailing whitepace from files.

from sys import argv
import os, sys

# iterate through all arguments.  When the script is called
# with a wildcard, for example 'rstrip *', the _shell_ will
# expand the wildcard and pass all results to the script.
for pathname in argv[1:]:
    if os.path.isfile(pathname):
        print 'Stripping trailing whitepace from', pathname
        f = file(pathname, 'r')
        s = "\n".join([l.rstrip() for l in f])
        f.close()
        f = file(pathname, 'w')
        f.write(s)
        f.close()
