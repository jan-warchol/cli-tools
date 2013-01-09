
export defaultlily='2.17.3'

alias lg='cd $LILYPOND_GIT; git status'
alias fixcc='scripts/auxiliar/fixcc.py'
alias fll='flip -ub *ly'

alias lily='$LILYPOND_BUILD_DIR/$defaultlily/out/bin/lilypond'
alias lilystable='$LILYPOND_BUILD_DIR/stable/out/bin/lilypond'
alias lilyrelease='$LILYPOND_BUILD_DIR/release/out/bin/lilypond'
alias lbuild='$lilyscripts/build-lily.sh'
alias lmake='lbuild normal current'
alias lpull='$lilyscripts/pull-all.sh'

alias mb='lbuild b'
alias mbb='lbuild bb'
alias mn='lbuild n'
alias mnn='lbuild nn'
alias ms='lbuild s'
alias mss='lbuild ss'

