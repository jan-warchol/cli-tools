#!/bin/bash

for file in $(find ./ -name *ly) ; do flip -ub $file; done
