#neofetch
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
###################################
## Find out what distro we're on ##
###################################
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    export COMPUTERNAME=$(hostname)
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
    export COMPUTERNAME=$(hostname)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
    export COMPUTERNAME=$(hostname)
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
    export COMPUTERNAME=$(hostname)
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
    export COMPUTERNAME=$(hostname)
fi
fi
###################################
## Find out what distro we're on ##
###################################
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    export COMPUTERNAME=$(hostname)
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
    export COMPUTERNAME=$(hostname)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
    export COMPUTERNAME=$(hostname)
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
    export COMPUTERNAME=$(hostname)
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
    export COMPUTERNAME=$(hostname)
fi

########################
## Virtualenv loading ##
########################

## PYTHON ##
export PYTHONPATH=$PYTHONPATH:"/usr/bin/python3"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Documents/projects
if [ $EUID != 0 ]; then
  if [ -d "$HOME/.local" ]; then
    if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
      source $HOME/.local/bin/virtualenvwrapper.sh
    fi
  fi
fi

## RUBY ##
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#############
## colorls ##
#############
if [ $(gem which colorls) ]; then
  COLORLS=$(dirname $(gem which colorls))/tab_complete.sh
  source $COLORLS
  alias lc='colorls -lA --sd'
fi

################
## WINEPREFIX ##
################
export WINEPREFIX=~/.wine

####################################################
## Determine if current directory is a git branch ##
####################################################
function git_branch {
  ref=$(git branch 2>/dev/null | grep '^*' | colrm 1 2) || return
  revno=$(git rev-parse HEAD 2> /dev/null | cut -c1-7) || return
  if [ "$ref" ]; then
    printf $RED$DASH$CYAN"[git$DARK_YELLOW:$CYAN${ref}$DARK_YELLOW:$CYAN${revno}]"
  fi
}

## Determine if you're working in a Python virtual environment ##
function virtual_env {
  if [ "$VIRTUAL_ENV" != "" ]; then
    printf $RED$DASH$PURPLE"[${VIRTUAL_ENV##*/}]"
  fi
}

GIT_REF="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
GIT_REV="$(git rev-parse HEAD 2> /dev/null | cut -c1-7)"
if [ "$GIT_REF" ]; then
  GIT_BRANCH="$RED$DASH$CYAN[git$DARK_YELLOW:$CYAN${GIT_REF}$DARK_YELLOW:$CYAN${GIT_REV}]"
else
  GIT_BRANCH=""
fi
echo $GIT_BRANCH
echo ${#GIT_BRANCH}

###################
## Set variables ##
###################
## Colors ##
RED="\e[0;31m"
ROOT_RED="\e[01;31m"
WHITE="\e[0;37m"
LIGHT_YELLOW="\e[01;33m"
DARK_YELLOW="\e[38;5;214m"
DARK_BLUE="\e[38;5;24m"
LIGHT_CYAN="\e[01;96m"
CYAN="\e[0;36m"
PURPLE="\e[0;35m"
GREEN="\e[0;32m"
CURSOR="\e[0m"

## Symbols ##
DASH="\342\224\200"
TOP_CORNER="\342\224\214"
BOT_CORNER="\342\224\224"
SM_SQUARE="\342\225\274"
EX="\342\234\227"

## enable color support of ls and also add handy aliases ##
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    if [ gem ]; then
      if [[ $(gem list '^colorls$' -i) ]]; then
        alias ls='colorls'
      else
        alias ls='ls -CF'
      fi
    fi

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## ls colors ##
LS_COLORS=$LS_COLORS:'di=38;5;229:fi=38;5;202:ln=38;5;155:ow=38;5;120:ex=38;5;207' ; export LS_COLORS

#######################
## PS1 configuration ##
#######################
if [ "$color_prompt" = yes ]; then
    PS1="$RED$TOP_CORNER$DASH\$([[ \$? != 0 ]] && echo -e '$RED[$EX]$DASH')\[$(if [[ ${EUID} == 0 ]]; then echo -e $ROOT_RED'root'; else echo -e $DARK_BLUE$USER; fi)$DARK_YELLOW@$LIGHT_CYAN\h$RED$DASH[$GREEN\w$RED]${WHITE}\[\$(virtual_env)\]$DARK_YELLOW\[\$(git_branch)\]\n\r\[$RED$BOT_CORNER$DASH$DASH$SM_SQUARE $DARK_YELLOW\]$ $CURSOR"
else
    PS1="$RED$TOP_CORNER$DASH\$([[ \$? != 0 ]] && echo -e '$RED[$EX]$DASH')\[$(if [[ ${EUID} == 0 ]]; then echo -e $ROOT_RED'root'; else echo -e $DARK_BLUE$USER; fi)$DARK_YELLOW@$LIGHT_CYAN\h$RED$DASH[$GREEN\w$RED]${WHITE}\[\$(virtual_env)\]$DARK_YELLOW\[\$(git_branch)\]\n\r\[$RED$BOT_CORNER$DASH$DASH$SM_SQUARE $DARK_YELLOW\]$ $CURSOR"
fi
unset color_prompt force_color_prompt

## If this is an xterm set the title to user@host:dir ##
case "$TERM" in
xterm*|rxvt*)
    PS1="$RED$TOP_CORNER$DASH\$([[ \$? != 0 ]] && echo -e '$RED[$EX]$DASH')\[$(if [[ ${EUID} == 0 ]]; then echo -e $ROOT_RED'root'; else echo -e $DARK_BLUE$USER; fi)$DARK_YELLOW@$LIGHT_CYAN\h$RED$DASH[$GREEN\w$RED]${WHITE}\[\$(virtual_env)\]$DARK_YELLOW\[\$(git_branch)\]\n\r\[$RED$BOT_CORNER$DASH$DASH$SM_SQUARE $DARK_YELLOW\]$ $CURSOR"
    ;;
*)
    ;;
esac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo -e terminal || echo -e error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
if [ -f ~/.profile ]; then
  . ~/.profile
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
#export HISTFILESIZE=
#export HISTSIZE=
#export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
#export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
#PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

###############
## Functions ##
###############

## Restart network interface connection ##
function ifrestart {
  if [ $1 ]; then
    sudo ifconfig $1 down && sleep 10 && sudo ifconfig $1 up
  else
    echo "This command requires an interface name"
  fi
}

## Probe address for open ports ##
##   Or probe a specific port   ##
## probe [address] [port-range] ##
function probe {
  if [ $1 ]; then
    if [ $2 ]; then
      nc -zv $1 $2 2>&1 | grep succeeded
    else
      echo "missing second arg"
    fi
  else
    echo "no args passed"
  fi
}

## Display ports used by program [arg1] ##
function psport {
	sudo netstat -tulnp | grep $1
}

## Display occurences of arg from syslog ##
function syslog {
	grep $1 /var/log/syslog
}

## Package management shit ##
## Dependent on distribution ##
if [ "$OS" == "Ubuntu" ]; then
  alias ay='sudo apt-get -y install'
  alias yup='sudo apt-get -y update && sudo apt-get -y upgrade'
  alias ar='sudo apt-get remove -y --purge'
elif [ "$OS" == "Fedora" ]; then
  alias dy='sudo dnf -y install'
  alias yy='sudo yum -y install'
  alias yup='sudo yum -y update && sudo dnf -y update'
  alias dr='sudo dnf -y remove'
  alias yr='sudo yum -y remove'
elif [ "$OS" == "CentOS Linux" ]; then
  alias yy='sudo yum -y install'
  alias yup='sudo yum -y update'
  alias yr='sudo yum -y remove'
elif [ "$OS" == "Raspbian GNU/Linux" ]; then
  alias ay='sudo apt-get -y install'
  alias yup='sudo apt-get -y update && sudo apt-get -y upgrade'
  alias ar='sudo apt-get remove -y --purge'
fi

export HISTTIMEFORMAT="%d/%m/%y %T "

####################
## Custom aliases ##
####################

## Do things ##
alias fsearch='flatpak search'
alias fuckingown='sudo chown -Rh $USER /home/$USER'
alias pup='pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U'
alias speedtest='speedtest-cli'
alias neo='clear && neofetch'
alias wine='wine 2>~/.wine.error.log'
alias tclock='tty-clock -s -c -t -n -C 5'
alias matrix='cmatrix -a -C magenta'
alias matrixr='cmatrix -a -r'
# if there is no bash profile, we don't want to source it.
if [ -f ~/.profile ]; then
  alias resh='source ~/.bashrc && source ~/.profile'
else
  alias resh='source ~/.bashrc'
fi

## Shortcuts ##
alias c='clear'
alias dist='echo -e $OS'
alias l='ls'
alias la='ls -A'
alias ll='ls -lA'
alias mkdir='mkdir -p'
alias mount='mount |column -t'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias pa='ps aux | grep'
alias papy='ps -ef | grep python'
alias pwsh='TERM=xterm pwsh'
alias video='lspci -k | grep -EA3 "VGA|3D|Display"'
alias x='exit'

## Editors ##
alias vi='vim'
alias sudo='sudo '

## Navigation ##
alias ..='cd ..'
alias desktop='cd ~/Desktop/'
alias docs='cd ~/Documents/'
alias downloads='cd ~/Downloads/'
alias etc='cd /etc'
alias home='cd ~/'
alias opt='cd /opt'
alias raid0="cd /mnt/Raid0"

## Open in vim ##
alias bashrc='sudo vim ~/.bashrc'

## Stop after sending count echo -e _REQUEST packets ##
alias ping='ping -c 5'

## Do not wait interval 1 second, go fast ##
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'

## do not delete / or prompt if deleting more than 3 files at a time ##
alias rm='rm -I --preserve-root'

## Python ##
alias py='python3'
alias pip='pip3'

## confirmation ##
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

## Parenting changing perms on / ##
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

## become root ##
alias root='sudo -i'

## reboot / halt / poweroff ##
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

## this one saved by butt so many times ##
alias wget='wget -c'
alias rm='rm -i'

## set some other defaults ##
alias df='df -H'
