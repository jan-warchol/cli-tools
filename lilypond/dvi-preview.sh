#!/bin/bash

# this script generates dvi previews of metafont files;
# they are saved in '~/font-preview/'.
# call this script from top source directory (usually
# 'lilypond-git/')
#
# first argument is the "operating mode"
# second argument is the name of mf file to be compiled
# (for example feta20, feta-noteheads20, parmesan13 etc.)
# third argument (used only in 'c' operating mode)
# is the branch with changed glyph sources.
#
# operating modes
# n = create a dvi preview of a specified mf file
#     and open it with xdvi
# c = creates 3 dvi preview files of specified font file
#     and opens them with xdvi:
#     - file-current = how glyphs from master look like
#     - file-new = how glyphs from specified branch look like
#     - file-revised = at the beginning it's a copy of -new;
#     after making some changes in the glyph sources,
#     run this script with operating mode 'r' to see
#     these new changes in third window.
# r = recompile the 'file-revised' dvi preview.
#

mkdir ~/font-preview/

case $1 in
  c)
  # TODO: use git stash here (and remember branch to return to it)
    git commit -a -m "committing uncommitted changes"
    git checkout master

    cd mf/
    mf $2
    gftodvi $2.2602gf
    mv --force $2.dvi ~/font-preview/$2-current.dvi
    rm $2.log
    rm $2.2602gf
    cd ../

    git checkout $3

    cd mf/
    mf $2
    gftodvi $2.2602gf
    mv --force $2.dvi ~/font-preview/$2-new.dvi
    rm $2.log
    rm $2.2602gf
    cd ../

    cp ~/font-preview/$2-new.dvi ~/font-preview/$2-revised.dvi

    xdvi ~/font-preview/$2-current.dvi &
    xdvi ~/font-preview/$2-new.dvi &
    xdvi ~/font-preview/$2-revised.dvi &
    ;;
    
  n)
    cd mf/
    mf $2
    gftodvi $2.2602gf
    mv --force $2.dvi ~/font-preview/$2.dvi
    rm $2.log
    rm $2.2602gf
    cd ../
    xdvi ~/font-preview/$2.dvi &
    ;;

  r)
    cd mf/
    mf $2
    gftodvi $2.2602gf
    mv --force $2.dvi ~/font-preview/$2-revised.dvi
    rm $2.log
    rm $2.2602gf
    ;;
esac
