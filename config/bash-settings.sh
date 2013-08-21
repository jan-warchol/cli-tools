###################
# 1. general places
# 2. include files
# 3. history settings
# 4. misc settings


######################################
# GENERAL PLACES.
# make sure to update them if there was any reorganization

export MY_DROPBOX="$ALL_MY_STUFF/Dropbox"
export MY_OWN_DATA="$ALL_MY_STUFF/moje"
export MY_REPOSITORIES="$ALL_MY_STUFF/repos"
export LILYPOND_BUILD_DIR="$ALL_MY_STUFF/lily-builds"
export LILYPOND_GIT="$MY_REPOSITORIES/lilypond-git"
export MY_CLI_TOOLS="$MY_REPOSITORIES/cli-tools"
export MY_SCRIPTS="$MY_CLI_TOOLS/scripts"
export LILY_SCRIPTS="$MY_CLI_TOOLS/lilypond"


######################################
# INCLUDE CONFIG FILES:

# import aliases
source "$MY_CONFIGS/bash-aliases.sh"

# import a file containing git-enabled prompt:
source "$MY_CONFIGS/git-prompt.sh"

# enable autocompletion in git
source "$MY_CONFIGS/git-completion.bash"


######################################
# HISTORY SETTINGS:

# save all the histories
export HISTFILESIZE=1000000
export HISTSIZE=100000

# don't save duplicate lines or lines starting with space.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# combine multiline commands in history
shopt -s cmdhist

# append to the history file, don't overwrite it
shopt -s histappend


######################################
# MISCELLANEOUS SETTINGS:

# add a program needed for LilyPond patch handling to PATH
PATH=$MY_REPOSITORIES/git-cl:"${PATH}"

# disable the MagicSysRq key combinations
#echo 0 > /proc/sys/kernel/sysrq ....nope, something's wrong...

# for multi-threaded compilation with 'make':
export MAKE_OPTIONS="-j5 CPU_COUNT=5"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# With this option turned on, pattern "**" will match all files,
# including all files in all levels of subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# keyboard autorepeat settings: 120 ms delay, 66 repetitions/sec
xset r rate 120 66

export defaultlily='2.17.3'

# some colors:
thinblue="\[$(tput setaf 6)\]"
thickcyan="\[\e[1;36m\]"
thickblue="\[\e[1;34m\]"
bold="\[$(tput bold)\]"
normal="\[$(tput sgr0)\]"
violet="\e[00;35m"
yellow="\e[00;33m"
green="\e[00;32m"
red="\e[00;31m"
normalanother="\e[00m"

# several prompts created by me.
alias promptdefault='PS1="\u@\h \w\$"'
alias huh='PS1="$boldhuh? $normal"'
alias promptmaster='PS1="$boldYes, master? $normal"'
alias promptgit='PS1="$thinblue\w$normal\$(__git_ps1)$\n"'
alias promptgithost='PS1="$violet\u@\h $thinblue\w$normal\$(__git_ps1)$\n"'
alias promptgitmaster='PS1="$thickblue\u@\h: \w$normal\$(__git_ps1)\n$thinblue""Yes, master? \[\e[0m\]"'

# choose default prompt:
promptgithost
