
export defaultlily='2.17.3'
export defaultbuild='current'

alias lg='cd $LILYPOND_GIT; git status'
alias lpull='$LILY_SCRIPTS/pull-all.sh'
alias fixcc='$LILYPOND_GIT/scripts/auxiliar/fixcc.py'
alias flly='flip -ub *.ly; flip -ub *.ily'

alias lgit='$LILYPOND_GIT/build/out/bin/lilypond'
alias lily='$LILYPOND_BUILD_DIR/$defaultlily/out/bin/lilypond'
alias lcurrent='$LILYPOND_BUILD_DIR/current/out/bin/lilypond'
alias lmaster='$LILYPOND_BUILD_DIR/master/out/bin/lilypond'
alias lstable='$LILYPOND_BUILD_DIR/stable/out/bin/lilypond'
alias lrelease='$LILYPOND_BUILD_DIR/release/out/bin/lilypond'
alias lstroke='$LILYPOND_BUILD_DIR/strokeadjust/out/bin/lilypond'

alias lbuild='$LILY_SCRIPTS/build-lily.sh -t 2'
alias mb='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild -b'
alias mn='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild'
alias ms='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild -s'
