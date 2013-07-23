
export defaultlily='2.17.3'

alias lg='cd $LILYPOND_GIT; git status'
alias lpull='$lilyscripts/pull-all.sh'
alias fixcc='$LILYPOND_GIT/scripts/auxiliar/fixcc.py'
alias flly='flip -ub *.ly; flip -ub *.ily'

alias lgit='$LILYPOND_GIT/build/out/bin/lilypond'
alias lily='$LILYPOND_BUILD_DIR/$defaultlily/out/bin/lilypond'
alias lmaster='$LILYPOND_BUILD_DIR/master/out/bin/lilypond'
alias lstable='$LILYPOND_BUILD_DIR/stable/out/bin/lilypond'
alias lrelease='$LILYPOND_BUILD_DIR/release/out/bin/lilypond'
alias lstroke='$LILYPOND_BUILD_DIR/strokeadjust/out/bin/lilypond'

alias lbuild='$lilyscripts/build-lily.sh'
alias mb='lbuild bin current'
alias mn='lbuild normal current'
alias ms='lbuild scratch current'
