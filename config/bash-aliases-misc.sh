
#finish-sound="aplay -q $JANEKDATA/lilypond/auxiliar/sznikers.wav"

#aliases
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias m='man'
alias o="gnome-open "
alias d='cd $JANEKDATA'
alias np='nautilus "$(pwd)"'
alias sai='sudo apt-get install'
alias fr='cd $JANEKDATA/nuty/urs/fried; git status'
alias nuty='cd $JANEKDATA/nuty/warsztat; git status'
alias epi='cd $HOME/Dropbox/Epifania; git status'
alias cli='cd $JANEKDATA/moje/cli; git status'
alias alm='alsamixer'
alias ,='less -R -S'
alias ,,='less -R'
alias smnt='sudo smbmount //192.168.15.210/dane/janek /media/shamon/ -o user=janek'
alias fres='python ~/jw/repos/frescobaldi/frescobaldi'

# directory "bookmarks"
alias s1='alias d1="cd $(pwd)"'
alias s2='alias d2="cd $(pwd)"'
alias s3='alias d3="cd $(pwd)"'

alias bashrc='gedit $bashsettings/* &'

# redefine commands
alias grepp='grep -nri --color=always'
alias mkdp='mkdir -p'

alias grep2='grep -C2'
alias grep3='grep -C3'
alias grep5='grep -C5'
