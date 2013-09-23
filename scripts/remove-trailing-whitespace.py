#!/usr/bin/python

# This script removes trailing whitespace from files.
# It doesn't remove trailing newlines; in fact, it makes
# sure that at least one trailing newline is present.

import os, sys

# Iterate through all arguments.  When the script is called
# with a wildcard (for example 'remove-trailing-whitespace.py *'),
# it's the *shell* that will expand the wildcard, and pass all
# resulting paths as arguments to the script.

for pathname in sys.argv[1:]:
    if os.path.isfile(pathname):
        print 'Stripping trailing whitepace from', pathname
        f = file(pathname, 'r')
        s = "\n".join([l.rstrip() for l in f])
        f.close()

        f = file(pathname, 'w')
        f.write(s+"\n")
        f.close()
