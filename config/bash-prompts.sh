# import a file contating nice features for git:
source "$bashsettings/git-prompt.sh"

# some colors:
thinblue="\[$(tput setaf 6)\]"
thickcyan="\[\e[1;36m\]"
thickblue="\[\e[1;34m\]"
bold="\[$(tput bold)\]"
normal="\[$(tput sgr0)\]"

# several prompts created by me.
alias promptnormal='PS1="\u@\h \w\$"'
alias huh='PS1="$boldhuh? $normal"'
alias promptmaster='PS1="$boldYes, master? $normal"'
alias prompt2master='PS1="$thickblue\u@\h: \w$normal\$(__git_ps1)\n$thinblueYes, master? \[\e[0m\]"'
alias promptgit='PS1="$thinblue\w$normal\$(__git_ps1)$\n"'

# choose default prompt:
promptgit


