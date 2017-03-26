# $Id: $
# System-wide zshrc configuration
# Robert Sink <rsink@millennialmedia.com>
# This file is automatically disted out by cfengine--if you need changes, put it in
# the ~/.zshrc ...
#

# Some needed autoloads
autoload -U colors zsh/terminfo complist incremental-complete-word compinit promptinit insert-files predict-on

# Path additions
export PATH=$PATH:/cygdrive/c/DAVE-3.1.10/DAVE-3.1.10/DAVE-3.1.10/ARM-GCC/bin:/cygdrive/c/Program\ Files\ \(x86\)/SEGGER/JLinkARM_V484f

# Some convienient aliases for SEGGER stuff
alias jlinkgdbserver="JLinkGDBServerCL.exe -device XMC1302-0032 -if SWD -endian little"
alias jlinkgdb="arm-none-eabi-gdb -ex \"target extended-remote localhost:2331\""

alias winpython="/cygdrive/c/Users/smf0323/Downloads/WinPython-64bit-3.5.2.1Qt5/python-3.5.2.amd64/python.exe"

#LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# Make grep use colors and set matches to inverse video.
alias grep="grep --color"

# Maximum size of directory stack before truncation occurs
export DIRSTACKSIZE=50

# Used for various computations
export BLOCKSIZE=1k

# Set VISUAL to vim
export VISUAL=vim

# If the combined user and system execution time is longer than '10',
# report the time
export REPORTTIME=10

# Set the prompt to show some meaningful stuff
# This is the basic prompt--see the bottom of this file for info
# on the very advanced prompt, if your terminal handles it.
#
# Also, function precmd() and preexec() are defined down there as well.
#
export prompt="[%n<@>%m [%/]-> "

# Do not allow the line editor ZLE to introduce pauses to attempt to make up
# for a slow terminal connection
export BAUD=0

# Give a right prompt @ the end of the line
export RPROMPT='<'

# Make the right prompt disappear if we are inputting to the point of the line where it exists.
export TRANSIENT_RPROMPT=1

# Set up for ZSH completion colors
export ZLS_COLORS=$LS_COLORS

# Use GNU's less as a pager, versus more
export PAGER=less

# This is basically useless since coreadm is writing cores to /var/core
#limit coredumpsize 0
ulimit -c 0

# Add some color to top and make it obvious when the load_avg is high
export TOPCOLOURS="1min=100,200#33:1min=200,1000#31:5min=100,200#33:5min=200,1000#31"

# Set the mask to give optimal installation permissions
umask 022

# Turn on auto directory push to the stack
setopt AUTO_PUSHD

# Some global, time saving aliases
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'

alias -g L='|less -FSRX'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g S='|strings'
alias -g N='&>/dev/null&'


# Use GNU's fileutils/ls over Solaris/SYSV + turn coloring on
# See below color definitions
#
alias ls="ls --color=yes -F"
alias ll="ls --color=yes -ahlF"
alias lt="ls --color=yes -ahltF"

# Use vim by default, over vi
alias vi="vim"

# Set up rm to be safer by default (esp. for 'system' user)
alias rm="rm -i"

# Set less to use color
alias less="less -r"

# Set df to do nothing
alias df=""

# Set ag to use color by default
alias ag="ag --color"

# Set cat to display non prints by default
alias cat="cat -v"

# Stop the .hex file fuckery
alias hgdiff="hg diff -X \"glob:**.hex\" -X \"glob:**.elf\" -X \"glob:**.mk\" -X \"glob:**makefile\" -X \"glob:.*\""

# setenv for csh junkies (including tset)
setenv() { export $1=$2 }

# Give us EMACS-like command line behavior
# Give us VIM-like command line behavior
bindkey -v

#add back in some nice bindings
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Color definitions for GNU's ls (ls)
eval `dircolors -b`

# Now set it up so ZSH'll do colorized completion
export ZLS_COLOURS=$LS_COLOURS

# Remove the silly white space at the end of the prompt
export ZLE_RPROMPT_INDENT=0

# Tag on to GNU's ls (ls) colors for ZSH's completion subsystem
zle -N incremental-complete-word
zle -N insert-files
zle -N predict-on
compinit
promptinit

#add keymap-select triggers
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
  RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$MYRPROMPT"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Completion Styles
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' list-colors ${(s.:.)ZLS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select

# Completion for zsh builtins.
compctl -j -P '%' fg bg wait jobs disown
compctl -A shift
compctl -caF type whence which
compctl -F unfunction
compctl -a unalias
compctl -v export integer typeset declare readonly unset vared
compctl -e disable
compctl -d enable
eval compctl -k "'("`limit | cut -d\  -f1`")'" limit unlimit
compctl -l '' -x 'p[1]' -f -- . source
compctl -s '`unsetopt`' setopt

# Redirection below makes zsh silent when completing unsetopt xtrace
compctl -s '`setopt 2> /dev/null`' unsetopt
compctl -s '${^fpath}/*(N:t)' autoload
compctl -g '*(-/)' cd pushd

# Anything after nohup is a command by itself with its own completion
compctl -l '' nohup exec nice eval
compctl -x 'p[1]' -c - 'p[2,-1]' -k signals -- trap
compctl -l '' -x 'p[1]' -B -- builtin

# Make zsh change to a directory w/o requiring 'cd' & correct misspelled names
setopt autocd correct extended_glob prompt_subst

# A 'which ls', which (heh) combines a which into a ls -alF, good for viewing
# the long list of a file in the path.
function lw () {
  ls --color=yes -alhF `which $*`
}

#
# Advanced prompt, mostly snarfed from: http://www.aperiodic.net/phil/prompt/
#

function precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} ))

    # See if we're in a Mercurial branch
    HG_BRANCH=`echo -n : ; hg branch 2> /dev/null`
    if [[ $HG_BRANCH == : ]]; then
        unset HG_BRANCH
    else
        HG_SHELVE=`hg shelve --list 2> /dev/null | grep "${HG_BRANCH//:}"`
        if [[ -z $HG_SHELVE ]]; then
            unset HG_SHELVE
        else
            HG_SHELVE=":SHELVE"
        fi
    fi
    GIT_BRANCH=`echo -n : ; git rev-parse --abbrev-ref HEAD 2> /dev/null`
    if [[ $GIT_BRANCH == : ]]; then
      unset GIT_BRANCH
    fi

    HG_STATUS=`hg status -mard 2> /dev/null | wc -l`
    if [[ $HG_STATUS == 0 ]]; then
      HG_STATUS=$PR_BLUE
    else
      HG_STATUS=$PR_RED
    fi
    GIT_STATUS=`git status -s 2> /dev/null | wc -l`
    if [[ $GIT_STATUS == 0 ]]; then
      GIT_STATUS=$PR_BLUE
    else
      GIT_STATUS=$PR_RED
    fi


    ###
    # Truncate the path if it's too long.

    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m:%l$HG_BRANCH$GIT_BRANCH$HG_SHELVE)---()--}}
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
            ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi
    print -rP '
$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_YELLOW@%m:$PR_WHITE%l$HG_STATUS$HG_BRANCH$PR_RED$HG_SHELVE$PR_BLUE$GIT_STATUS$GIT_BRANCH\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT'
}

preexec () {
    #if [[ "$TERM" == "screen" ]]; then
    #    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    #fi
}

setprompt () {
    # Need setopt prompt_subst for this to werk

    ###
    # See if we can use colors.

    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}


    ###
    # Decide if we need to set titlebar text.

    #case $TERM in
    #    xterm*)
    #        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
    #        ;;
    #    screen)
    #        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
    #        ;;
    #    *)
    #        PR_TITLEBAR=''
    #        ;;
    #esac


    ###
    # Decide whether to set a screen title
    #if [[ "$TERM" == "screen" ]]; then
    #    PR_STITLE=$'%{\ekzsh\e\\%}'
    #else
    #    PR_STITLE=''
    #fi


    ###
    # Finally, the prompt.

    PROMPT='$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(1j.$PR_LIGHT_RED%j$PR_BLUE:.)\
$PR_LIGHT_BLUE$PR_RED%T$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    #This is concatenedt to RPROMPT
    MYRPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

# Do nothing if we're running vt100
if [[ "$TERM" != "vt100" ]]; then
    setprompt
fi

# Save x lines of CLUI history
#export HISTFILE=~/.history
#export HISTSIZE=2000
#export SAVEHIST=100000

[ -d ~/.history ] || mkdir --mode=0700 ~/.history
[ -d ~/.history ] && chmod 0700 ~/.history
HISTFILE=~/.history/history.$$
# close any old history file by zeroing HISTFILESIZE
HISTFILESIZE=0
# then set HISTFILESIZE to a large value
HISTFILESIZE=4096
HISTSIZE=4096
