#### LILYPOND ALIASES:

alias lpull='$LILY_SCRIPTS/pull-all.sh'
alias fixcc='$LILYPOND_GIT/scripts/auxiliar/fixcc.py'

lily() {
    lil="$1"
    shift
    "$LILYPOND_BUILD_DIR/$lil/out/bin/lilypond" "$@"
}
conv-ly() {
    lil="$1"
    shift
    "$LILYPOND_BUILD_DIR/$lil/out/bin/convert-ly" "$@"
}
alias lgit='$LILYPOND_GIT/build/out/bin/lilypond'
alias lcurrent='$LILYPOND_BUILD_DIR/current/out/bin/lilypond'
alias lmaster='$LILYPOND_BUILD_DIR/master/out/bin/lilypond'

alias lbuild='$LILY_SCRIPTS/build-lily.sh -t 2'
alias mb='$LILY_SCRIPTS/build-lily.sh -t 0 -b; alert'
alias mn='$LILY_SCRIPTS/build-lily.sh -t 0   ; alert'
alias ms='$LILY_SCRIPTS/build-lily.sh -t 0 -s; alert'

alias lbuildtesting='$LILY_SCRIPTS/build-lily.sh -t 1 -c master -m "springs stroke cleaned-alignment add-dur-moll  thinner_skylines" -d testing'
