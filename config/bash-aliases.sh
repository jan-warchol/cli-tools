
# BASH ALIASES:

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'

alias m='man'
alias o="gnome-open "
alias s="$MY_SCRIPTS/"
alias d='cd $MY_OWN_DATA'
alias np='nautilus "$(pwd)"'
alias mko='make $MAKE_OPTIONS'
alias sai='sudo apt-get install'
alias alm='alsamixer'
alias ifs='IFS=$(echo -en "\n\b")'
alias ,='less -R -S'
alias ,,='less -R'
alias smnt='sudo smbmount //192.168.15.210/dane/janek /media/shamon/ -o user=janek'
alias fres='python $MY_REPOSITORIES/frescobaldi/frescobaldi'
alias editconf='gedit $MY_CONFIGS/* &'

alias lg='cd $LILYPOND_GIT; git status'
alias fr='cd $MY_REPOSITORIES/fried-songs; git status'
alias nuty='cd $MY_REPOSITORIES/warsztat-nutowy; git status'
alias epi='cd $MY_DROPBOX/Epifania; git status'
alias epinuty='cd $MY_REPOSITORIES/epinuty; git status'
alias cli='cd $MY_CLI_TOOLS; git status'

# directory "bookmarks"
alias s1='alias d1="cd $(pwd)"'
alias s2='alias d2="cd $(pwd)"'
alias s3='alias d3="cd $(pwd)"'

# redefine commands
alias grepp='grep -nri --color=always'
alias mkdp='mkdir -p'

alias grep2='grep -C2'
alias grep3='grep -C3'
alias grep5='grep -C5'

# Add an "alert" alias.
# Use by appending to the command after a semicolon:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'



#### LILYPOND ALIASES:

alias lpull='$LILY_SCRIPTS/pull-all.sh; alert'
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
alias mb='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild -b; alert'
alias mn='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild; alert'
alias ms='$LILY_SCRIPTS/build-lily.sh -t 0 -d $defaultbuild -s; alert'



############ BASH GIT ALIASES #############
# bash aliases for more efficient git use:

    alias g='git'

   alias ga='git add'
  alias gaa='git add --all' #including untracked files
  alias gan='git add -N'
  alias gap='git add -p'
  alias gau='git add --update' #only tracked files

   alias gb='git branch'
  alias gba='git branch -a'
  alias gbr='git branch -r'

   alias gc='git checkout'
  alias gch='git checkout'
  alias gcm='git checkout master'
 alias gcom='git checkout origin/master'
 alias gch0='git checkout HEAD~0'
 alias gch1='git checkout HEAD~1'
 alias gch2='git checkout HEAD~2'

   alias gk='git commit'
  alias gka='git commit -a'
  alias gkm='git commit -m'
  alias gkp='git commit -p'
 alias gkam='git commit -a -m'
  alias gam='git commit -a --amend'

   alias gd='git diff'
  alias gd,='git diff | less -R -S'
 alias gdw,='git diff --word-diff=color | less -R -S'
  alias gdc='git diff --cached'
 alias gdc,='git diff --cached | less -R -S'
alias gdwc,='git diff --word-diff=color --cached | less -R -S'
  alias gdh='git diff HEAD'
  alias gdm='git diff master'
 alias gdm,='git diff master | less -R -S'
 alias gdom='git diff origin/master'
alias gdom,='git diff origin/master | less -R -S'
 alias gdis='git stash save "discarded changes"'

   alias gf='git fetch'
  alias gfa='git fetch --all'
  alias gfo='git fetch origin'

   alias gl='git log'
  alias gl,='git log | less -R -S'
  alias glo='git log --oneline'
 alias glo,='git log --oneline | less -R -S'
 alias glod='git log --oneline --decorate'
alias glod,='git log --oneline --decorate | less -R -S'
 alias glog='git log --oneline --graph'
alias glog,='git log --oneline --graph | less -R -S'
alias glodg='git log --oneline --decorate --graph'
alias glodg,='git log --oneline --decorate --graph | less -R -S'
alias glodga='git log --oneline --decorate --graph --all'
alias glodga,='git log --oneline --decorate --graph --all | less -R -S'
 alias glos='git log --oneline --stat'
alias glos,='git log --oneline --stat | less -R -S'
alias glosg='git log --oneline --stat --graph'
alias glosg,='git log --oneline --stat --graph | less -R -S'
 alias glom='git log --oneline master..'
alias gloom='git log --oneline origin/master..'
  alias glp='git log -p'
 alias glp,='git log -p | less -R -S'
 alias glpr='git log -p --reverse master..'
alias glpr,='git log -p --reverse master.. | less -R -S'

  alias gpo='git push origin'
 alias gpom='git push origin master'

  alias grb='git rebase'
 alias grba='git rebase --abort'
 alias grbc='git rebase --continue'
 alias grbm='git rebase master'
  alias gri='git rebase --interactive'
 alias grim='git rebase --interactive master'
 alias gri5='git rebase --interactive HEAD~5'
alias gri11='git rebase --interactive HEAD~11'
alias gri22='git rebase --interactive HEAD~22'

  alias grs='git reset'
   alias gu='git reset HEAD~1'

   alias gs='git status'
  alias gst='git status'

   alias gt='git tag'
  alias gt,='git tag | less -R -S'
