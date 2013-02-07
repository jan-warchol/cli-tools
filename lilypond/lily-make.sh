#!/bin/bash

# Call this script from lilypond-git/ directory.
# This will run make and then compile test files
# located in parent directory (or its subdirectory if specified).
# Test files will be compiled with installed lilypond
# (suffix "-current") and lilypond built from git ("-new" suffix)
# for easy comparison.
# It will not overwrite existing pdf files without suffix.
#
# "options":
# b = make bin
# o = ordinary make
# s = make from scratch
#
# if the letter is doubled, reference repository used for
# test-files comparison (clean-master) is rebuilt too.
#
# On exit plays a sound.


die()
{
aplay -q ~/src/sznikers.wav
exit 1
}

#?# mkdir -p build/ oraz clean-master/build/?
cd build/

case $1 in
  b)
    make bin || die;
    ;;
  bb)
    make bin || die;
    cd ../../clean-master/build/
    make bin || die;
    ;;
  o)
    make -j5 CPU_COUNT=5 || die;
    ;;
  oo)
    make || die;
    cd ../../clean-master/build/
    make || die;
    ;;
  s)
    cd ../
    rm -r -f build
    ./autogen.sh --noconfigure
    mkdir -p build/
    cd build/
    ../configure
    make -j5 CPU_COUNT=5 || die;
    ;;
  ss)
    cd ../
    rm -r -f build
    ./autogen.sh --noconfigure
    mkdir -p build/
    cd build/
    ../configure
    make || die;
    cd ../../clean-master/
    rm -r -f build
    ./autogen.sh --noconfigure
    mkdir -p build/
    cd build/
    ../configure
    make || die;
    ;;
esac

cd ../

# compile test files using external script
../compiletestfiles $2

aplay -q ~/src/sznikers.wav
