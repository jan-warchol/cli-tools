
alias s='sudo'
alias sagi='sudo apt-get install'
alias df='df --human-readable'
alias mkdir='mkdir --parents'
alias ,='less --chop-long-lines'  # I prefer to scroll horizontally than to have strange line wrapping
# BASH ALIASES:


alias monl='xrandr --output HDMI1 --rotate left; xrandr --output DP1 --rotate left'
alias monn='xrandr --output HDMI1 --rotate normal; xrandr --output DP1 --rotate normal'

alias np='nautilus "$(pwd)"'
alias mko='make $MAKE_OPTIONS'
alias ifs='alias reset_ifs="IFS=$IFS"; IFS=$(echo -en "\n\b")'
alias smnt='sudo smbmount //192.168.15.210/dane/janek /media/shamon/ -o user=janek'
fres() { python $OTHER_REPOS/frescobaldi/frescobaldi "$@" &>/dev/null & }
alias intj='$HOME/bin/idea-IC-133.193/bin/idea.sh &'
alias h='history'
alias hf='history | grep'

ved() { kate "$@" &>/dev/null & }
editconf() {
    edit ~/bash-aliases.sh \
         ~/bash-settings.sh \
         ~/.gitconfig
}



# directory "bookmarks"
alias s1='alias d1="cd $(pwd)"'
alias s2='alias d2="cd $(pwd)"'
alias s3='alias d3="cd $(pwd)"'

# redefine commands
alias grep2='grep -C2'
alias grep3='grep -C3'
alias grep5='grep -C5'


#### LILYPOND ALIASES:

alias lpull='$LILY_SCRIPTS/pull-all.sh'
alias fixcc='$LILYPOND_GIT/scripts/auxiliar/fixcc.py'
alias flly='flip -ub *.ly; flip -ub *.ily'

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

#!/bin/bash

alias dfs='dotfiles'
complete -o default -o nospace -F _git dfs

 alias gd,,='git diff | less -R'
alias gdw,,='git diff --word-diff=color | less -R'
alias gdwc,,='git diff --word-diff=color --cached | less -R'
alias gdcsv='git diff --word-diff=color --word-diff-regex="[^;^\s]+"'
alias gdcsv,='git diff --word-diff=color --word-diff-regex="[^;^\s]+" | less -R -S'
  alias gdh='git diff HEAD'
alias gdom,='git diff origin/master | less -R -S'

  alias gla='gitk --all HEAD &'
alias gloa,='git log --oneline --decorate --graph --all | less -R -S'
alias glos,='git log --oneline --stat --decorate --graph | less -R -S'
 alias glom='git log --oneline master..'
alias gloom='git log --oneline origin/master..'

 alias gmbd='git merge-base-diff HEAD'
alias gmbd,='git merge-base-diff HEAD | less -R -S'

   alias gs='git status'

 alias gdis='git stash save "discarded changes"'

  alias gsh='git stash save'
      gsa() {
            git stash save "a backup just in case, $(date +'%Y-%m-%d %H:%M')"
            git stash apply &>/dev/null
            }

   alias gt='git tag'
  alias gt,='git tag | less -R -S'
