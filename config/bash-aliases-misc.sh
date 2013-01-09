
#finish-sound="aplay -q $JANEKDATA/lilypond/auxiliar/sznikers.wav"

#aliases
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias m='man'
alias o="gnome-open "
alias d='cd $JANEKDATA'
alias np='nautilus $(pwd)'
alias sai='sudo apt-get install'
alias fr='cd $JANEKDATA/nuty/urs/fried; git status'
alias nuty='cd $JANEKDATA/nuty/warsztat; git status'
alias alm='alsamixer'
alias ,='less -R -S'
alias ,,='less -R'

# directory "bookmarks"
alias s1='alias d1="cd $(pwd)"'
alias s2='alias d2="cd $(pwd)"'
alias s3='alias d3="cd $(pwd)"'

alias bashrc='gedit $bashsettings/* &'

# redefine commands
alias grep='grep -nr --color=always'
alias mkdir='mkdir -p'

alias grep2='grep -C2'
alias grep5='grep -C5'
