###################
# 1. general places
# 2. include files
# 3. history settings
# 4. misc settings


######################################
# GENERAL PLACES.
# make sure to update them if there was any reorganization

export LILYPOND_GIT=$HOME/repos/lilypond-git/
export LILYPOND_BUILD_DIR=$HOME/lily-builds/
export scripts="$JANEKDATA/moje/cli/scripts"
export lilyscripts="$JANEKDATA/moje/cli/lilypond"


######################################
# INCLUDE CONFIG FILES:

# import lilypond-specific settings and aliases
source "$bashsettings/bash-lilypond-settings.sh"

# import aliases and other stuff for git work
source "$bashsettings/bash-git-settings.sh"

# import miscellaneous aliases
source "$bashsettings/bash-aliases-misc.sh"

# import file with predefined prompts
source "$bashsettings/bash-prompts.sh"


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

# resize ouput to fit window
shopt -s checkwinsize

