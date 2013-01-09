
# enable autocompletion in git
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# bash aliases for more efficient git use:

    alias g='git'

   alias ga='git add'
  alias gaa='git add --all' #including untracked files
  alias gan='git add -N'
  alias gap='git add -p'
  alias gau='git add --update' #only tracked files
   alias gb='git branch'
  alias gbr='git branch -r'
  alias gba='git branch -a'

   alias gc='git checkout'
  alias gcm='git checkout master'
 alias gcom='git checkout origin/master'
 alias gch0='git checkout HEAD~0'
 alias gch1='git checkout HEAD~1'
 alias gch2='git checkout HEAD~2'
   alias gk='git commit'
  alias gka='git commit -a'
  alias gkm='git commit -m'
 alias gkam='git commit -a -m'

   alias gf='git add --all; git commit -m foo'

   alias gd='git diff'
  alias gd,='git diff | less -R -S'
  alias gdc='git diff --cached'
 alias gdc,='git diff --cached | less -R -S'
  alias gdh='git diff HEAD'
  alias gdm='git diff master'
 alias gdm,='git diff master | less -R -S'
 alias gdom='git diff origin/master'
   alias gl='git log | less -R -S'
  alias glo='git log --oneline'
 alias glod='git log --oneline --decorate | less -R -S'
 alias glog='git log --oneline --graph | less -R -S'
alias glodg='git log --oneline --decorate --graph | less -R -S'
alias glo-m='git log --oneline master..'
alias glo-om='git log --oneline origin/master..'
  alias glp='git log -p | less -R -S'

  alias grb='git rebase'
 alias grba='git rebase --abort'
 alias grbc='git rebase --continue'
 alias grbm='git rebase master'
  alias gri='git rebase -i'
 alias grim='git rebase -i master'
  alias grs='git reset'
 alias grsh='git reset --hard'
alias grshm='git reset --hard master'
alias grshom='git reset --hard origin/master'

   alias gs='git status'
   alias gt='git tag | less -R -S'


