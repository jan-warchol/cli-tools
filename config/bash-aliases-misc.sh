
#finish-sound="aplay -q $MY_OWN_DATA/lily/auxiliar/sznikers.wav"

#aliases
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias m='man'
alias o="gnome-open "
alias s="sudo !!"
alias d='cd $MY_OWN_DATA'
alias np='nautilus "$(pwd)"'
alias sai='sudo apt-get install'
alias fr='cd $MY_REPOSITORIES/fried-songs; git status'
alias nuty='cd $MY_REPOSITORIES/warsztat-nutowy; git status'
alias epi='cd $MY_DROPBOX/Epifania; git status'
alias cli='cd $MY_CLI_TOOLS; git status'
alias alm='alsamixer'
alias ifs='IFS=$(echo -en "\n\b")'
alias ,='less -R -S'
alias ,,='less -R'
alias smnt='sudo smbmount //192.168.15.210/dane/janek /media/shamon/ -o user=janek'
alias fres='python $MY_REPOSITORIES/frescobaldi/frescobaldi'

# directory "bookmarks"
alias s1='alias d1="cd $(pwd)"'
alias s2='alias d2="cd $(pwd)"'
alias s3='alias d3="cd $(pwd)"'

alias editconf='gedit $MY_CONFIGS/* &'

# redefine commands
alias grepp='grep -nri --color=always'
alias mkdp='mkdir -p'

alias grep2='grep -C2'
alias grep3='grep -C3'
alias grep5='grep -C5'
