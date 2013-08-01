#!/bin/bash

# r - rerun regtests
# o - make regtests 

# s - make regtests from scratch
# <filename> - compile given filename

die()
{
aplay -q ~/src/sznikers.wav
exit 1
}

tested_branch=$(git branch | sed --quiet 's/* \(.*\)/\1/p')

if [ $1 == r ]; then
  make $MAKE_OPTIONS test-clean || die;
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS check || die;

  firefox file://$build/out/test-results/index.html &
  
else if [ $1 == oo ]; then
  # go to master
  git add .
  git commit -a -m "saving unsaved changes"
  git checkout master

  mkdir -p build
  cd build/

  # make test baseline
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS test-baseline || die;

  # stash the baseline so that it could be used later
  #mkdir ../../regtest-baselines; export LILYPOND_BASELINES=~/regtest-baselines

  # compare regtets
  git checkout $tested_branch
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS check || die;

  firefox file://$build/out/test-results/index.html &
  
else if [ $1 == o ]; then
  # compare regtets
  cd build/
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS check || die;

  firefox file://$build/out/test-results/index.html &
  
else if [ $1 == s ]; then
  # go to master
  git add .
  git commit -a -m "saving unsaved changes"
 # git pull -r || die;
  git checkout master
 # git pull -r || die;

  # make from scratch and make test baseline
  rm -r -f build
  sh autogen.sh --noconfigure
  mkdir -p build/
  cd build/
  ../configure
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS test-baseline || die;

  # go to another branch and compare regtets
  cp -r input/regression/ ~/baseline-copy/
  cd ../
  git checkout $tested_branch
  rm -r -f build
  sh autogen.sh --noconfigure
  mkdir -p build/
  cd build/
  ../configure
  cp -r ~/baseline-copy/* input/regression/
  rm -r -f ~/baseline-copy/
  make $MAKE_OPTIONS || die;
  make $MAKE_OPTIONS check || die;

  firefox file://$build/out/test-results/index.html &

else
  cd ../
  ~/clean-master/build/out/bin/lilypond ~/lilypond-git/input/regression/$1.ly
  mv $1.pdf $1-current.pdf
  ~/lilypond-git/build/out/bin/lilypond ~/lilypond-git/input/regression/$1
  mv $1.pdf $1-new.pdf
fi; fi; fi; fi;
  
aplay -q ~/src/sznikers.wav
