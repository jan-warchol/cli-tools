######################################
# MISCELLANEOUS SETTINGS:

# add a program needed for LilyPond patch handling to PATH
PATH=$OTHER_REPOS/git-cl:"${PATH}"

# disable the MagicSysRq key combinations
#echo 0 > /proc/sys/kernel/sysrq ....nope, something's wrong...

# for multi-threaded compilation with 'make':
export MAKE_OPTIONS="-j5 CPU_COUNT=5"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# faster key repetition (110 ms delay, 90 reps/sec) - life is too short to wait!
xset r rate 110 90

export defaultlily='2.17.3'

# a tiny prank ;)
alias huh='alias mommy_help_me="export PS1=\"$PS1\""; PS1="${bold}huh? ${normal}"'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# run Dropbox
#~/.dropbox-dist/dropboxd &

export MY_OWN_DATA=$HOME/moje

# only store the latest occurrence of a command
export HISTCONTROL=erasedups

# combine multiline commands in history
shopt -s cmdhist
