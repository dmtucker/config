umask 0027

############################################################################ env

if ! command -v tput &>/dev/null
then tput
elif [[ "$TERM" == '' ]]
then echo "\$TERM is not set."
else
    [[ "$TERM" == *'256'* ]] || echo "\$TERM ($TERM) does not appear to support 256 colors."

    # text
    TXT_RESET="$(tput sgr0)" && export TXT_RESET
    TXT_BLACK_FG="$(tput setaf 0)" && export TXT_BLACK_FG
    TXT_BLACK_BG="$(tput setab 0)" && export TXT_BLACK_BG
    TXT_RED_FG="$(tput setaf 1)" && export TXT_RED_FG
    TXT_RED_BG="$(tput setab 1)" && export TXT_RED_BG
    TXT_GREEN_FG="$(tput setaf 2)" && export TXT_GREEN_FG
    TXT_GREEN_BG="$(tput setab 2)" && export TXT_GREEN_BG
    TXT_YELLOW_FG="$(tput setaf 3)" && export TXT_YELLOW_FG
    TXT_YELLOW_BG="$(tput setab 3)" && export TXT_YELLOW_BG
    TXT_BLUE_FG="$(tput setaf 4)" && export TXT_BLUE_FG
    TXT_BLUE_BG="$(tput setab 4)" && export TXT_BLUE_BG
    TXT_MAGENTA_FG="$(tput setaf 5)" && export TXT_MAGENTA_FG
    TXT_MAGENTA_BG="$(tput setab 5)" && export TXT_MAGENTA_BG
    TXT_CYAN_FG="$(tput setaf 6)" && export TXT_CYAN_FG
    TXT_CYAN_BG="$(tput setab 6)" && export TXT_CYAN_BG
    TXT_WHITE_FG="$(tput setaf 7)" && export TXT_WHITE_FG
    TXT_WHITE_BG="$(tput setab 7)" && export TXT_WHITE_BG
    TXT_BRIGHT_BLACK_FG="$(tput setaf 8)" && export TXT_BRIGHT_BLACK_FG
    TXT_BRIGHT_BLACK_BG="$(tput setab 8)" && export TXT_BRIGHT_BLACK_BG
    TXT_BRIGHT_RED_FG="$(tput setaf 9)" && export TXT_BRIGHT_RED_FG
    TXT_BRIGHT_RED_BG="$(tput setab 9)" && export TXT_BRIGHT_RED_BG
    TXT_BRIGHT_GREEN_FG="$(tput setaf 10)" && export TXT_BRIGHT_GREEN_FG
    TXT_BRIGHT_GREEN_BG="$(tput setab 10)" && export TXT_BRIGHT_GREEN_BG
    TXT_BRIGHT_YELLOW_FG="$(tput setaf 11)" && export TXT_BRIGHT_YELLOW_FG
    TXT_BRIGHT_YELLOW_BG="$(tput setab 11)" && export TXT_BRIGHT_YELLOW_BG
    TXT_BRIGHT_BLUE_FG="$(tput setaf 12)" && export TXT_BRIGHT_BLUE_FG
    TXT_BRIGHT_BLUE_BG="$(tput setab 12)" && export TXT_BRIGHT_BLUE_BG
    TXT_BRIGHT_MAGENTA_FG="$(tput setaf 13)" && export TXT_BRIGHT_MAGENTA_FG
    TXT_BRIGHT_MAGENTA_BG="$(tput setab 13)" && export TXT_BRIGHT_MAGENTA_BG
    TXT_BRIGHT_CYAN_FG="$(tput setaf 14)" && export TXT_BRIGHT_CYAN_FG
    TXT_BRIGHT_CYAN_BG="$(tput setab 14)" && export TXT_BRIGHT_CYAN_BG
    TXT_BRIGHT_WHITE_FG="$(tput setaf 15)" && export TXT_BRIGHT_WHITE_FG
    TXT_BRIGHT_WHITE_BG="$(tput setab 15)" && export TXT_BRIGHT_WHITE_BG
    TXT_BLINK="$(tput blink)" && export TXT_BLINK
    TXT_BOLD_FG="$(tput bold)" && export TXT_BOLD_FG
    TXT_BOLD_BG="$(tput smso)" && export TXT_BOLD_BG
    TXT_BOLD_BG_END="$(tput rmso)" && export TXT_BOLD_BG_END
    TXT_DIM="$(tput dim)" && export TXT_DIM
    TXT_HIDE="$(tput invis)" && export TXT_HIDE
    TXT_ITALIC="$(tput sitm)" && export TXT_ITALIC
    TXT_ITALIC_END="$(tput ritm)" && export TXT_ITALIC_END
    TXT_REVERSE="$(tput rev)" && export TXT_REVERSE
    TXT_UNDERLINE="$(tput smul)" && export TXT_UNDERLINE
    TXT_UNDERLINE_END="$(tput rmul)" && export TXT_UNDERLINE_END

    # cursor
    CUR_HOME="$(tput home)" && export CUR_HOME
    CUR_SAVE="$(tput sc)" && export CUR_SAVE
    CUR_RESTORE="$(tput rc)" && export CUR_RESTORE
    CUR_HIDE="$(tput civis)" && export CUR_HIDE
    CUR_SHOW="$(tput cvvis)" && export CUR_SHOW
    CUR_LEFT="$(tput cub1)" && export CUR_LEFT
    CUR_DOWN="$(tput cud1)" && export CUR_DOWN
    CUR_RIGHT="$(tput cuf1)" && export CUR_RIGHT
    CUR_UP="$(tput cuu1)" && export CUR_UP

    # terminal
    TERM_CLEAR="$(tput clear)" && export TERM_CLEAR
    TERM_FLASH="$(tput flash)" && export TERM_FLASH

    # shellcheck disable=SC2064
    trap "printf '$TXT_RESET'" DEBUG
fi
export PS1="\[$TXT_RESET\][\#] \[$TXT_CYAN_FG\]\u\[$TXT_RESET\]@\[$TXT_GREEN_FG\]\h\[$TXT_RESET\]:\[$TXT_YELLOW_FG\]\w\[$TXT_RESET\] \$ \[$TXT_RED_FG\]"
export PS1="\[$TXT_RESET$TXT_BRIGHT_BLACK_FG\]\D{%FT%T%z} exit \$?\n$PS1"
case $TERM in
    xterm*) export PS1="\[\033]0;\u@\h \l\007\]$PS1";;
esac

[[ ":$PATH:" == *':.:'* ]] || export PATH=".:$PATH"
export PIP_REQUIRE_VIRTUALENV=true

alias cdtmp='cd "$(mktemp -d)"'
alias grep='grep --color=auto'
alias less='less -r'
alias ll='ls -h -l'
alias watch='watch --color'

# system-specific
case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    Linux)
        eval "$(dircolors --sh)"  # Set LS_COLORS.
        alias ls='ls --color=auto'
        alias crontab='crontab -i'
        ;;
    *) echo 'This OS is not recognized.'
esac

###################################################################### functions

address () {
    # Get the public IPv6 and/or IPv4 address of localhost.
    local usage && usage="usage: ${FUNCNAME[0]}"
    if (( $# != 0 ))
    then
        echo "$usage" 1>&2
        return 1
    elif ! command -v wget &>/dev/null
    then wget || return 1
    fi
    local ipv4 && ipv4="$(wget -qO- 'http://v4.ipv6-test.com/api/myip.php')"
    local ipv6 && ipv6="$(wget -qO- 'http://v6.ipv6-test.com/api/myip.php')"
    local pref && pref="$(wget -qO- 'http://v4v6.ipv6-test.com/api/myip.php')"
    if [[ "$pref" = "$ipv4" ]]
    then
        [[ -z "$ipv4" ]] || echo "IPv4: $ipv4"
        [[ -z "$ipv6" ]] || echo "IPv6: $ipv6"
    else
        [[ -z "$ipv6" ]] || echo "IPv6: $ipv6"
        [[ -z "$ipv4" ]] || echo "IPv4: $ipv4"
    fi
}

capture () {
    # Redirect output to unique files.
    local unique && unique="$(date -u "+%Y%m%dT%H%M%SZ").$(hostname -s).$$"
    local stdcmd && stdcmd="$unique.stdcmd.bash"
    local stderr && stderr="$unique.stderr.log"
    local stdout && stdout="$unique.stdout.log"
    echo "#!$BASH" >> "$stdcmd"
    echo "$@" >> "$stdcmd"
    local tmperr && tmperr="$(mktemp)"
    local tmpout && tmpout="$(mktemp)"
    "$@" 1> "$tmpout" 2> "$tmperr"
    [[ -s "$tmperr" ]] && mv "$tmperr" "$stderr"
    [[ -s "$tmpout" ]] && mv "$tmpout" "$stdout"
}

countdown () {
    # Sleep verbosely.
    # Example: Reboot in 10min.
    #   $ countdown 600 && reboot
    local usage && usage="usage: ${FUNCNAME[0]} <seconds>"
    if (( $# != 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    local from && from="$1"
    shift 1
    local prompt && prompt='countdown: '
    printf '%s' "$prompt"
    for i in $(seq -f "%0${#from}g" $((from)) -1 1)
    do
        printf '%d' "$i"
        sleep 1
        for _ in $(seq "${#from}"); do printf '\b \b'; done
    done
    for _ in $(seq "${#prompt}"); do printf '\b \b'; done
}

projects () {
    # Show info about projects.
    # shellcheck disable=SC2068
    for path_ in ${@:-"${PROJECTS:-"$HOME/projects"}/"*}
    do
        git -C "$path_" status > /dev/null || continue
        printf '%s' "$TXT_BOLD_FG$TXT_BLUE_FG"
        basename "$(git -C "$path_" rev-parse --show-toplevel)"
        printf '%s' "$TXT_RESET"
        git -C "$path_" fetch --quiet --tags --prune --all
        git -C "$path_" status --branch --short
        git -C "$path_" stash list
    done
}

refresh_config () {
    # Install the latest dmtucker/config.
    local usage="usage: ${FUNCNAME[0]}"
    if (( $# > 0 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    url='https://raw.githubusercontent.com/dmtucker/config/master/install.bash'
    wget -O- "$url" | "$BASH"
}

weather () {
    # Get the weather.
    local usage="usage: ${FUNCNAME[0]} [city]"
    if (( $# > 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    wget -qO- "http://wttr.in/$1"
}
