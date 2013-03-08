
export defaultlily='2.17.3'

alias lg='cd $LILYPOND_GIT; git status'
alias fixcc='scripts/auxiliar/fixcc.py'
alias fll='flip -ub *ly'

alias lily='$LILYPOND_BUILD_DIR/$defaultlily/out/bin/lilypond'
alias lgit='$LILYPOND_GIT/build/out/bin/lilypond'
alias lmaster='$LILYPOND_BUILD_DIR/master/out/bin/lilypond'
alias lstable='$LILYPOND_BUILD_DIR/stable/out/bin/lilypond'
alias lrelease='$LILYPOND_BUILD_DIR/release/out/bin/lilypond'
alias lpull='$lilyscripts/pull-all.sh'

alias lbuild='$lilyscripts/build-lily.sh'
alias mb='lbuild bin current'
alias mn='lbuild normal current'
alias ms='lbuild scratch current'

