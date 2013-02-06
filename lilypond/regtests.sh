#!/bin/bash

# r - rerun regtests
# o - make regtests without cleaning fonts
# f - make regtests with cleaning fonts
# s - make regtests from scratch
# <filename> - compile given filename

die()
{
aplay -q ~/src/sznikers.wav
exit 1
}

tested_branch=$(git branch | sed --quiet 's/* \(.*\)/\1/p')

if [ $1 == r ]; then
  make test-clean || die;
  make || die;
  make check || die;

  firefox file:///home/janek/lilypond-git/build/out/test-results/index.html &
  
else if [ $1 == o ]; then
  # go to master
  git add .
  git commit -a -m "saving unsaved changes"
  git pull -r || die;
  git checkout master
  git pull -r || die;

  # make from scratch and make test baseline
  cd build/
  make || die;
  make test-baseline || die;

  # go to another branch and compare regtets
  cd ../
  git checkout $tested_branch
  cd build/
  make || die;
  make check || die;

  firefox file:///home/janek/lilypond-git/build/out/test-results/index.html &
  
else if [ $1 == f ]; then
  # update both master and tested branch, go to master
  git add .
  git commit -a -m "saving unsaved changes"
  git pull -r || die;
  git checkout master
  git pull -r || die;

  # make with cleaning fonts and make test baseline
  cd build/mf/
  make clean
  cd ../
  make || die;
  make test-baseline || die;

  # go to another branch and compare regtets
  cd ../
  git checkout $tested_branch
  cd build/mf/
  make clean
  cd ../
  make || die;
  make check || die;

  firefox file:///home/janek/lilypond-git/build/out/test-results/index.html &
  
else if [ $1 == s ]; then
  # go to master
  git add .
  git commit -a -m "saving unsaved changes"
  git pull -r || die;
  git checkout master
  git pull -r || die;

  # make from scratch and make test baseline
  rm -r -f build
  sh autogen.sh --noconfigure
  mkdir -p build/
  cd build/
  ../configure
  make || die;
  make test-baseline || die;

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
  make || die;
  make check || die;

  firefox file:///home/janek/lilypond-git/build/out/test-results/index.html &

else
  cd ../
  lilypond ~/lilypond-git/input/regression/$1.ly
  mv $1.pdf $1-current.pdf
  ~/lilypond-git/build/out/bin/lilypond ~/lilypond-git/input/regression/$1
  mv $1.pdf $1-new.pdf
fi; fi; fi; fi;
  
aplay -q ~/src/sznikers.wav
