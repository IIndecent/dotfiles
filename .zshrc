# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="indecent/indecent"
#ZSH_THEME="amuse"
##ZSH_THEME="bira"
#ZSH_THEME="fox"
#ZSH_THEME="funky"
#ZSH_THEME="gnzh"
#ZSH_THEME="half-life"
#ZSH_THEME="itchy"
#ZSH_THEME="jaischeema"
#ZSH_THEME="jonathan"
#ZSH_THEME="juanghurtado"
#ZSH_THEME="mikeh"
#ZSH_THEME="muse"
#ZSH_THEME="nebirhos"
#ZSH_THEME="rkj-repos"
#ZSH_THEME="simonoff"
#ZSH_THEME="steeef"
#ZSH_THEME="superjarin"
#ZSH_THEME="trapd00r"
#ZSH_THEME="wedisagree"
#ZSH_THEME="wuffers"
#ZSH_THEME="xiong-chiamiov-plus"
#ZSH_THEME="zhann"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)

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

#############
## colorls ##
#############
if [ gem ]; then
  source $(dirname $(gem which colorls))/tab_complete.sh
  alias lc='colorls -lA --sd'
fi

########################
## Virtualenv loading ##
########################
export PYTHONPATH=$PYTHONPATH:"/usr/bin/python3"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo -e terminal || echo -e error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.profile ]; then
  . ~/.profile
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

## Choose your venv directory, create, and activate it ##
# pyvenv <name>
function pyvenv {
	python3 -m venv $1 & wait
	source $1/bin/activate
}

## Package management shit ##
## Dependent on distribution ##
if [ "$OS" = "Ubuntu" ]; then
  alias ay='sudo apt-get -y install'
  alias yup='sudo apt-get -y update && sudo apt-get -y upgrade'
  alias ar='sudo apt-get remove -y --purge'
elif [ "$OS" = "Fedora" ]; then
  alias dy='sudo dnf -y install'
  alias yy='sudo yum -y install'
  alias yup='sudo yum -y update && sudo dnf -y update'
  alias dr='sudo dnf -y remove'
  alias yr='sudo yum -y remove'
elif [ "$OS" = "CentOS Linux" ]; then
  alias yy='sudo yum -y install'
  alias yup='sudo yum -y update'
  alias yr='sudo yum -y remove'
elif [ "$OS" = "Raspbian GNU/Linux" ]; then
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
alias pup='pip3 list --outdated --format=freeze | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip3 install -U'
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