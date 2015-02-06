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
export TRUNKNE_LIED_HOME="$MY_REPOSITORIES/nuty/trunkne-lied"
export MY_SCRIPTS="$MY_CLI_TOOLS/scripts"
export LILY_SCRIPTS="$MY_CLI_TOOLS/lilypond"
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export HADOOP_INSTALL=$HOME/codilime/hadoop-1.2.1/
export PATH=$PATH:$HADOOP_INSTALL/bin


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
normal="\e[00m"
red="\e[00;31m"
green="\e[00;32m"
yellow="\e[00;33m"
blue="\e[00;34m"
violet="\e[00;35m"
cyan="\e[00;36m"
gray="\e[00;37m"

bold="$(tput bold)"
strongred="\e[1;31m"
stronggreen="\e[1;32m"
strongyellow="\e[1;33m"
strongblue="\e[1;34m"
strongviolet="\e[1;35m"
strongcyan="\e[1;36m"

# several prompts created by me.
alias promptdefault='PS1="\u@\h \w\$"'
alias huh='PS1="$bold""huh? $normal"'
alias promptmaster='PS1="$bold""Yes, master? $normal"'
alias promptgit='PS1="$cyan\w$normal\$(__git_ps1)$\n"'
alias promptgithost='PS1="$violet\u@\h $cyan\w$normal\$(__git_ps1)$\n"'
alias promptgitmaster='PS1="$strongblue\u@\h: \w$normal\$(__git_ps1)\n$cyan""Yes, master? $normal"'

# choose default prompt:
promptgithost
