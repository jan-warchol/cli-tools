
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
  alias gdc='git diff --cached'
 alias gdc,='git diff --cached | less -R -S'
  alias gdh='git diff HEAD'
  alias gdm='git diff master'
 alias gdm,='git diff master | less -R -S'
 alias gdom='git diff origin/master'
alias gdom,='git diff origin/master | less -R -S'

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

  alias grb='git rebase'
 alias grba='git rebase --abort'
 alias grbc='git rebase --continue'
 alias grbm='git rebase master'
  alias gri='git rebase --interactive'
 alias gria='git rebase --interactive --autosquash'
 alias grim='git rebase --interactive master'
alias griam='git rebase --interactive --autosquash master'
alias gri11='git rebase --interactive HEAD~11'
alias gri22='git rebase --interactive HEAD~22'

  alias grs='git reset'
   alias gu='git reset HEAD~1'

   alias gs='git status'
  alias gst='git status'

   alias gt='git tag'
  alias gt,='git tag | less -R -S'
