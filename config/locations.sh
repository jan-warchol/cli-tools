# env variables pointing to various locations in my system
export MY_DROPBOX=$HOME/Dropbox
export MY_REPOSITORIES=$HOME/repos
export OTHERS_REPOSITORIES=$HOME/repos
# LilyPond-related
export LILYPOND_BUILD_DIR=$HOME/lily-builds
export LILYPOND_GIT=$MY_REPOSITORIES/lilypond-git
export LILY_SCRIPTS=$MY_REPOSITORIES/cli-tools/lilypond
export TRUNKNE_LIED_HOME=$MY_REPOSITORIES/nuty/trunkne-lied

# "shortcut" aliases for quick navigation
alias lg='cd $LILYPOND_GIT; git status'
alias fr='cd $MY_REPOSITORIES/nuty/fried-songs; git status'
alias tl='cd $TRUNKNE_LIED_HOME/das-trunkne-lied; git status'
alias oll='cd $MY_REPOSITORIES/openlilylib; git status'
alias epi='cd $MY_DROPBOX/Epifania; git status'
alias nuty='cd $MY_REPOSITORIES/nuty/warsztat-nutowy; git status'
alias ties='cd "$MY_DROPBOX/LilyPond ties"; git status'
