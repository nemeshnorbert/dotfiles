# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# file to store history of commands called
HISTFILE=$HOME/.bash_history

# don't put duplicate lines in the history.
# See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE="" # unlimited bash history
HISTFILESIZE="" # unlimited bash history
export HISTTIMEFORMAT='%F %T '

# to correctly work with remote hosts
export LANG=en_US.UTF-8

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# xterm-256 color control sequences
SET_BG="\e[48;5;"
SET_FG="\e[38;5;"
END="m"

# Nice xterm-256color colors
PROMPT_COLOR=100
BG_COLOR=0
OUTPUT_COLOR=230
TIME_COLOR=140
GIT_COLOR=7
USERHOST_COLOR=034
CMD_COLOR=230
SNOWMAN_COLOR=40
SYSTEM_COLOR=124

# For better vim colors
export TERM=xterm-256color

# \n - newline
# \$ - variable
# \[ \] surround characters not to be included in the length calculation
# \` \` surround command to be executed
export PS1="\[$SET_FG$TIME_COLOR$END\]\$LAST_LAUNCH_TIME\[$SET_FG$GIT_COLOR$END\][ \[$SET_FG$SYSTEM_COLOR$END\]$SYSTEM_TYPE\[$SET_FG$USERHOST_COLOR$END\]\u@\h:\[$SET_FG$PROMPT_COLOR$END\]\w \[$SET_FG$GIT_COLOR$END\](\$(git rev-parse --abbrev-ref HEAD 2>/dev/null)) ]$ "


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export LSCOLORS=Gxfxcxdxbxegedabagacad

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set show-all-if-ambiguous on

# Setup `on_prompt` handler to output execution time for each command run
export PROMPT_COMMAND='on_prompt'

LAST_LAUNCH_TIME=

function on_prompt() {
    # Do not trigger on completion
    [ -n "$COMP_LINE" ] && return
    # Save last launch time frame
    if [ -n "$LAST_LAUNCH_TIME" -a "$LAST_LAUNCH_TIME" != "$(date +'%T')" ]; then
        local newline=$'\n'
        local cur_time=$(date +'%s')
        local secs=$(($cur_time - $LAST_LAUNCH_UNIXTIME))
        sec="$(($secs % 60)) sec"
        local mins=$(($secs / 60))
        if [ $mins -gt 0 ]; then
            min="$(($mins % 60)) min "
        else
            min=""
        fi
        local hours=$(($mins / 60))
        if [ $hours -gt 0 ]; then
            hr="$hours h "
        else
            hr=""
        fi
        LAST_LAUNCH_TIME="[$LAST_LAUNCH_TIME - $(date +'%T') ($hr$min$sec)]$newline"
    else
        LAST_LAUNCH_TIME=""
    fi
    # For time tracking, we need to catch the first DEBUG trap
    __interactive__=yes
    history -a # flush history into .bash_history
}

function before_command_execution() {
    if [ -n "$__interactive__" ]; then
        LAST_LAUNCH_TIME=$(date +'%T')
        LAST_LAUNCH_UNIXTIME=$(date +'%s')
        __interactive__=
    fi
}

# Set `before_command_execution` as handler for DEBUG bash signal
trap 'before_command_execution' DEBUG

# Turn off annoying terminal sound
bind 'set bell-style none'
