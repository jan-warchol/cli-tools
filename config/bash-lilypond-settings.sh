
export defaultlily='2.17.3'

alias lg='cd $LILYPOND_GIT; git status'
alias fixcc='scripts/auxiliar/fixcc.py'
alias fll='flip -ub *ly'

alias lily='$LILYPOND_BUILD_DIR/$defaultlily/out/bin/lilypond'
alias lilystable='$LILYPOND_BUILD_DIR/stable/out/bin/lilypond'
alias lilyrelease='$LILYPOND_BUILD_DIR/release/out/bin/lilypond'
alias lpull='$lilyscripts/pull-all.sh'

alias lbuild='$lilyscripts/build-lily.sh'
alias mb='lbuild bin current'
alias mn='lbuild normal current'
alias ms='lbuild scratch current'

