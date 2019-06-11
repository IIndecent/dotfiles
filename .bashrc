# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

## RVM is a bit of a pain... Save this variable later so it can be prepended to PATH ##
GEM_HOME_OLD=""
[[ "$GEM_HOME" ]] && GEM_HOME_OLD="$GEM_HOME/bin"

## Need to hold Python virtual env for it to be appended somewhere after RVM path ##
VIRTUAL_ENV_OLD=""
[[ "$VIRTUAL_ENV" ]] && VIRTUAL_ENV_OLD="$VIRTUAL_ENV/bin"

## Reset path because that can get ugly ##
PATH=$(getconf PATH)

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

export HISTTIMEFORMAT="%d/%m/%y %T "

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

################
## WINEPREFIX ##
################
export WINEPREFIX=~/.wine

###################
## PS1 variables ##
###################
## Colors ##
LIGHT_RED="\[\e[00;31m\]"
ROOT_RED="\[\e[01;31m\]"
RED="\[\e[00;91m\]"
WHITE="\[\e[0;37m\]"
LIGHT_YELLOW="\[\e[01;33m\]"
DARK_YELLOW="\[\e[38;5;214m\]"
DARK_BLUE="\[\e[38;5;24m\]"
LIGHT_CYAN="\[\e[01;96m\]"
BRIGHT_CYAN="\[\e[01;36m\]"
CYAN="\[\e[0;36m\]"
PURPLE="\[\e[0;35m\]"
LIGHT_PURPLE="\[\e[01;35m\]"
LIGHT_GRAY="\[\e[00;37m\]"
DARK_GRAY="\[\e[01;30m\]"
GREEN="\[\e[0;32m\]"
RESET="\[\e[01;39m\]"

## Symbols ##
DASH="─"
TOP_CORNER="┌"
BOT_CORNER="└"
ARROW="▶"
BOX="╼"
EX="✗"
CHECK="✔"
SEPERATOR="ᛃ"
RB_START_FIN="ߦ"
PY_START_FIN="ꛜ"
GIT_START_FIN="Ⲯ"

## Git status symbols ##
GIT_ADDED="$GREEN✚"
GIT_MODIFIED="$DARK_BLUE✹"
GIT_DELETED="$RED✖"
GIT_RENAMED="$PURPLE➜"
GIT_UNMERGED="$DARK_YELLOW═"
GIT_UNTRACKED="$CYAN✭"
GIT_DIVERGED="$BRIGHT_CYAN↕"
GIT_AHEAD="$GREEN↑"
GIT_BEHIND="$RED↓"
GIT_STASHED="$DARK_YELLOW៙"
GIT_UP_TO_DATE="$GREEN$CHECK"

## ls colors ##
LS_COLORS=$LS_COLORS:'di=01;34:fi=38;5;202:ln=38;5;155:ow=38;5;120:ex=38;5;207'; export LS_COLORS

#######################
## PS1 configuration ##
#######################

set_prompt () {
  ## This variable needs to be set first to enusre accurate alert ##
  local CMD=$?

  ## Tossing this in here because RVM is a shitbox and can't act right ##
  ## If it's not the first variable path in PATH it throws it's ass... ##
  PATH=${PATH//$GEM_HOME_OLD}
  PATH="$GEM_HOME_OLD:$PATH"

  ## Set local variables and clear PS1 ##
  local PY_VENV=""
  local RB_VENV=""
  local PS1_PY_VENV=""
  local PS1_RB_VENV=""
  local CUR_DIR
  local USR
  local FILLER_LINE
  local CMD_RESULT
  local GIT_PROMPT=""
  local PS1_GIT=""
  local GIT_STAT=""
  local GIT_CLEAN
  local GIT_DIRTY
  local GIT_STATUS
  PS1=""


  ## Get the user ##
  if [ $EUID == 0 ]; then
    USR="$ROOT_RED$USER"
  else
    USR="$DARK_BLUE$USER"
  fi

  ## Add username, hostname, and working directory to PS1 ##
  CUR_DIR="$RED$TOP_CORNER$DASH$RED[$USR$DARK_YELLOW@$LIGHT_CYAN$HOSTNAME$RED]$DASH[$GREEN$(dirs)$RED]"
  PS1+="$CUR_DIR"

  ## Python virtual environment ##
  if [ "$VIRTUAL_ENV" != "" ]; then
    PS1_PY_VENV="$RED[$DARK_GRAY$PY_START_FIN$RED${PURPLE}py$DARK_YELLOW$SEPERATOR${PURPLE}env$DARK_YELLOW$SEPERATOR$PURPLE${VIRTUAL_ENV##*/}$DARK_GRAY$PY_START_FIN$RED$RED]"
  else
    PS1_PY_VENV=""
  fi
  PY_VENV=$PS1_PY_VENV

  ## Ruby virtual environment ##
  if [ "$GEM_HOME" != "" ]; then
    GEMSET=$(rvm gemset list | grep '^=> ')
    GEMSET=${GEMSET//"=> "}
    PS1_RB_VENV="$RED[$DARK_GRAY$RB_START_FIN$RED${LIGHT_RED}rb$DARK_YELLOW$SEPERATOR${LIGHT_RED}env$DARK_YELLOW$SEPERATOR$LIGHT_RED${GEM_HOME##*/}$DARK_YELLOW$SEPERATOR$LIGHT_RED$GEMSET$DARK_GRAY$RB_START_FIN$RED]"
  else
    PS1_RB_VENV=""
  fi
  RB_VENV=$PS1_RB_VENV

  ## Git branch, head, and status ##
  local REF=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
  local REVNO=$(git rev-parse HEAD 2> /dev/null | cut -c1-7)
  if [ "$REF" ]; then
    GIT_DIRTY="$EX"
    GIT_CLEAN="$CHECK"
    GIT_STATUS=$(git status --porcelain --ignore-submodules=dirty 2> /dev/null | tail -n1)
    if [[ -n $GIT_STATUS ]]; then
      GIT_STAT="$RED$GIT_DIRTY"
    else
      GIT_STAT="$GREEN$GIT_CLEAN"
    fi
    PS1_GIT="$RED[$DARK_GRAY$GIT_START_FIN$GIT_STAT$DARK_YELLOW$SEPERATOR${CYAN}git$DARK_YELLOW$SEPERATOR$CYAN$REF$DARK_YELLOW$SEPERATOR$CYAN$REVNO$DARK_YELLOW$SEPERATOR$(git_status)$DARK_GRAY$GIT_START_FIN$RED]"
    GIT_PROMPT="${PS1_GIT//\\\[}"
    GIT_PROMPT="${GIT_PROMPT//\\\]}"
  else
    PS1_GIT=""
  fi

  ## Remove color codes from variables to get accurate length of the strings ##
  ## Do this so that the dashes can be drawn across the first line accurately ##
  COLORS=("$LIGHT_RED" "$RED" "$ROOT_RED" "$WHITE" "$LIGHT_YELLOW" "$DARK_YELLOW" "$DARK_BLUE" "$LIGHT_CYAN" "$BRIGHT_CYAN" "$CYAN" "$PURPLE" "$LIGHT_PURPLE" "$LIGHT_GRAY" "$DARK_GRAY" "$GREEN" "$RESET")
  for i in "${COLORS[@]}"
  do
    i="${i//\\\[}"
    i="${i//\\\]}"
    GIT_PROMPT="${GIT_PROMPT//$i}"
    PY_VENV="${PY_VENV//$i}"
    RB_VENV="${RB_VENV//$i}"
    CUR_DIR="${CUR_DIR//$i}"
  done
  
  ## Escapes in color codes need to be removed seperately ##
  ## This will also unintentionally remove any backslach (\) in environment names ##
  GIT_PROMPT="${GIT_PROMPT//\\}"
  PY_VENV="${PY_VENV//\\\[}"
  PY_VENV="${PY_VENV//\\\]}"
  PY_VENV="${PY_VENV//\\}"
  RB_VENV="${RB_VENV//\\\[}"
  RB_VENV="${RB_VENV//\\\]}"
  RB_VENV="${RB_VENV//\\}"
  CUR_DIR="${CUR_DIR//\\\[}"
  CUR_DIR="${CUR_DIR//\\\]}"
  CUR_DIR="${CUR_DIR//\\}"

  ## Add a dash after Python virtual environment if there is Git information to follow ##
  if [ "$PY_VENV" ] && [ "$GIT_PROMPT" ]; then
    PS1_PY_VENV="$PS1_PY_VENV$RED$DASH"
    PY_VENV="$PY_VENV$DASH"
  fi

  ## Add a dash after Ruby virtual environment if there is Git information to follow ##
  if [ "$RB_VENV" ] && ([ "$GIT_PROMPT" ] || [ "$PY_VENV" ]); then
    PS1_RB_VENV="$PS1_RB_VENV$RED$DASH"
    RB_VENV="$RB_VENV$DASH"
  fi

  ## Subtract the length of the strings in the first line to know how many dashes to add ##
  ## Add 2 because the trailing dash and box won't be added to the string until later ##
  local SPACE
    ((SPACE=$COLUMNS - (${#CUR_DIR} + ${#GIT_PROMPT} + ${#PY_VENV} + ${#RB_VENV} + 2)))
  for ((i = 0; i < $SPACE; i++)); do
    FILLER_LINE+="$DASH"
  done

  ## Determine if the previous command was successful or not, and alert accordingly ##
  if [[ $CMD == 0 ]]; then
    CMD_RESULT="$GREEN[$CHECK]"
  else
    CMD_RESULT="$RED[$EX]"
  fi

  ## Add strings to PS1 ##
  PS1+="$RED$FILLER_LINE$PS1_RB_VENV$PS1_PY_VENV$PS1_GIT$RED$DASH$BOX\r\n$BOT_CORNER$DASH[$DARK_GRAY$(date '+%a.%b.%d.%Y' | tr '[a-z]' '[A-Z]')$RED][$DARK_GRAY$(date '+%T')$RED]$DASH$CMD_RESULT$RED$DASH$ARROW $RESET"
}

# Get the status of the working tree
function git_status() {
  local INDEX STATUS
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    STATUS="$GIT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$GIT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$GIT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$GIT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$GIT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$GIT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$GIT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$GIT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$GIT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$GIT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$GIT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$GIT_DELETED$STATUS"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$GIT_STASHED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$GIT_UNMERGED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    STATUS="$GIT_AHEAD$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
    STATUS="$GIT_BEHIND$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
    STATUS="$GIT_DIVERGED$STATUS"
  fi
  echo $STATUS
}

PROMPT_COMMAND='set_prompt'

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
## if there is no bash profile, we don't want to source it. ##
function resh {
  if [ -f ~/.profile ]; then
    source $HOME/.profile
  fi
  source $HOME/.bashrc
}

####################
## Custom aliases ##
####################

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

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo -e terminal || echo -e error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

## Do things ##
alias fsearch='flatpak search'
alias fuckingown='sudo chown -Rh $USER /home/$USER'
alias pup='pip3 list --outdated --format=freeze | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip3 install -U'
alias speedtest='speedtest-cli'
alias neo='clear && neofetch'
alias wine='wine 2>~/.wine.error.log'
alias tclock='tty-clock -s -c -t -n -C 5'
alias matrix='cmatrix -a -C magenta'
alias matrixr='cmatrix -a -r'

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

## Remove Python virtual environment from path so it's not added multiple times. ##
PATH="${PATH//$VIRTUAL_ENV_OLD}"

###**##################################################**###
## **                IF YOU USE RVM:                   ** ##
## ** REMOVE THIS LINE FROM .profile AND .bash_profile ** ##
## **       OTHERWISE WARNING WILL PERSIST!!           ** ##
###**##################################################**###
## Add RVM to PATH for scripting. Make sure this is the last PATH variable change. ##
if [ "$VIRTUAL_ENV_OLD" ]; then
  export PATH="$VIRTUAL_ENV_OLD:$PATH:$HOME/.rvm/bin"
fi
if [ "$GEM_HOME_OLD" ];then
  export PATH="$GEM_HOME_OLD:$PATH:$HOME/.rvm/bin"
fi

## Load RVM into a shell session *as a function* ##
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
