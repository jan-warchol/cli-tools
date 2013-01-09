# import a file contating nice features for git:
source "$bashsettings/git-prompt.sh"

# colors:
thinblue="\[$(tput setaf 6)\]"
thickcyan="\[\e[1;36m\]"
thickblue="\[\e[1;34m\]"
bold="\[$(tput bold)\]"
normal="\[$(tput sgr0)\]"

# several prompts created by me.
alias promptnormal='PS1="\u@\h \w\$"'
alias huh='PS1="\[$(tput bold)\]huh? \[$(tput sgr0)\]"'
alias promptmaster='PS1="\[$(tput bold)\]Yes, master? \[$(tput sgr0)\]"'
alias prompt2master='PS1="\[\e[1;34m\]\u@\h: \w\[$(tput sgr0)\]\$(__git_ps1)\n\[\e[1;36m\]Yes, master? \[\e[0m\]"'
alias promptgit='PS1="$thinblue\w$normal\$(__git_ps1)$\n"'

# choose default prompt:
promptgit


