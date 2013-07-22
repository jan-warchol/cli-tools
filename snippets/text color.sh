coloredtext="blah"
echo -e "\e[00;34m$coloredtext\e[00m"
echo -e "\e[00;32m$coloredtext\e[00m"

# some color definitions:
thinblue="\[$(tput setaf 6)\]"
thickcyan="\[\e[1;36m\]"
thickblue="\[\e[1;34m\]"
bold="\[$(tput bold)\]"
normal="\[$(tput sgr0)\]"    
