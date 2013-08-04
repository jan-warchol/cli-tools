###################
# 1. general places
# 2. include files
# 3. history settings
# 4. misc settings


######################################
# GENERAL PLACES.
# make sure to update them if there was any reorganization

export MY_DROPBOX="$ALL_MY_STUFF/Dropbox/"
export MY_OWN_DATA="$ALL_MY_STUFF/moje/"
export MY_REPOSITORIES="$ALL_MY_STUFF/repos/"
export LILYPOND_BUILD_DIR=$ALL_MY_STUFF/lily-builds/
export LILYPOND_GIT=$MY_REPOSITORIES/lilypond-git/
export MY_CLI_TOOLS="$MY_REPOSITORIES/command-line-stuff/"
export MY_SCRIPTS="$MY_CLI_TOOLS/scripts"
export LILY_SCRIPTS="$MY_CLI_TOOLS/lilypond"


######################################
# INCLUDE CONFIG FILES:

# import lilypond-specific settings and aliases
source "$MY_CONFIGS/bash-lilypond-settings.sh"

# import aliases and other stuff for git work
source "$MY_CONFIGS/bash-git-settings.sh"

# import miscellaneous aliases
source "$MY_CONFIGS/bash-aliases-misc.sh"

# import file with predefined prompts
source "$MY_CONFIGS/bash-prompts.sh"


######################################
# HISTORY SETTINGS:

# save all the histories
export HISTFILESIZE=1000000
export HISTSIZE=100000

# don't put duplicate lines in the history
export HISTCONTROL=ignoredups

# ... and ignore same successive entries.
export HISTCONTROL=ignoreboth

# combine multiline commands in history
shopt -s cmdhist

# merge session histories
shopt -s histappend


######################################
# MISCELLANEOUS SETTINGS:

# disable the MagicSysRq key combinations
#echo 0 > /proc/sys/kernel/sysrq ....nope, something's wrong...

# for multi-threaded compilation with 'make':
export MAKE_OPTIONS="-j5 CPU_COUNT=5"
alias mko='make $MAKE_OPTIONS'

# resize ouput to fit window
shopt -s checkwinsize

