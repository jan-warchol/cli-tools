#!/bin/bash

# Call this script from any directory.  It will compile lilypodn.

# $1 = operating mode (Bin or Scratch or sth else)
# $2 = build directory (default $LILYPOND_BUILD_DIR)
# $3 = repository directory (default $LILYPOND_GIT)

die() {
    #aplay -q ~/src/sznikers.wav
    exit 1
}

echo "========================================"

# we may need to convert given paths to absolute paths
# we use readlink for that and for consistency of the format
if [ "$2" != "" ]; then 
    build=$(readlink -m $2)
else 
    build=$(readlink -m $LILYPOND_BUILD_DIR)
fi

if [ "$3" != "" ]; then 
    source=$(readlink -m $3)
else
    source=$(readlink -m $LILYPOND_GIT)
fi

echo -e "Attempting to build \n"
git log -n 1
echo -e "\n(using option: $1) in \n  $build"
echo -e "from sources located in \n  $source"
#echo "press any key to continue"
#read confirmation
sleep 3

if [[ "$1" == s* ]]; then
    echo -e "\nbuilding from scratch.\n"
    sleep 1
    rm -rf $build
fi

# build dir may have not existed
mkdir -p $build; cd $build
configured_source=$(grep -s configure-srcdir config.make \
                     | sed s/configure-srcdir\ =\ //)

if [ "$configured_source" != "$source" ]; then
    # this dir was previously configured to build from another source
    # or wasn't configured at all.  Need to run autogen and configure
    cd $source; ./autogen.sh --noconfigure
    echo ""
    cd $build; $source/configure || die
fi

echo "----------------------------------------"
if [[ "$1" == b* ]]; then
echo ffff
    make $MAKE_OPTIONS bin || die
else
echo fdff
    make $MAKE_OPTIONS || die
fi

echo "________________________________________"

