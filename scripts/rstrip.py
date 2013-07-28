#!/usr/bin/python

from sys import argv

f = file(argv[1], 'r')
s = "\n".join([l.rstrip() for l in f])
f.close()
f = file(argv[1], 'w')
f.write(s)
f.close()
