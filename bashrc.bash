[[ $- = *i* ]] || return  # Require an interactive shell.

export PATH="$PATH:."

# cursor
export CUR_HOME="$(tput home)"
export CUR_SAVE="$(tput sc)"
export CUR_RESTORE="$(tput rc)"
export CUR_HIDE="$(tput civis)"
export CUR_SHOW="$(tput cvvis)"
export CUR_LEFT="$(tput cub1)"
export CUR_DOWN="$(tput cud1)"
export CUR_RIGHT="$(tput cuf1)"
export CUR_UP="$(tput cuu1)"

# text
export TXT_RESET="$(tput sgr0)"

export TXT_BLACK_FG="$(tput setaf 0)"
export TXT_BLACK_BG="$(tput setab 0)"
export TXT_RED_FG="$(tput setaf 1)"
export TXT_RED_BG="$(tput setab 1)"
export TXT_GREEN_FG="$(tput setaf 2)"
export TXT_GREEN_BG="$(tput setab 2)"
export TXT_YELLOW_FG="$(tput setaf 3)"
export TXT_YELLOW_BG="$(tput setab 3)"
export TXT_BLUE_FG="$(tput setaf 4)"
export TXT_BLUE_BG="$(tput setab 4)"
export TXT_MAGENTA_FG="$(tput setaf 5)"
export TXT_MAGENTA_BG="$(tput setab 5)"
export TXT_CYAN_FG="$(tput setaf 6)"
export TXT_CYAN_BG="$(tput setab 6)"
export TXT_WHITE_FG="$(tput setaf 7)"
export TXT_WHITE_BG="$(tput setab 7)"
export TXT_DEFAULT_FG="$(tput setaf 9)"
export TXT_DEFAULT_BG="$(tput setab 9)"
export TXT_DEFAULT="$TXT_DEFAULT_FG$TXT_DEFAULT_BG"

export TXT_BLINK="$(tput blink)"
export TXT_BOLD_FG="$(tput bold)"
export TXT_BOLD_BG="$(tput smso)"
export TXT_BOLD_BG_END="$(tput rmso)"
export TXT_DIM="$(tput dim)"
export TXT_HIDE="$(tput invis)"
export TXT_ITALIC="$(tput sitm)"
export TXT_ITALIC_END="$(tput ritm)"
export TXT_REVERSE="$(tput rev)"
export TXT_UNDERLINE="$(tput smul)"
export TXT_UNDERLINE_END="$(tput rmul)"

# shortcuts
export BLACK="$TXT_BLACK_FG"
export RED="$TXT_RED_FG"
export GREEN="$TXT_GREEN_FG"
export YELLOW="$TXT_YELLOW_FG"
export BLUE="$TXT_BLUE_FG"
export MAGENTA="$TXT_MAGENTA_FG"
export CYAN="$TXT_CYAN_FG"
export WHITE="$TXT_WHITE_FG"

# other
export CLEAR="$(tput clear)"
export FLASH="$(tput flash)"

# terminal
export TERM_CUR_TITLE='\033]0'
export TERM_CUR_TITLE_END='\007'
case $TERM in
    xterm*) TITLE="\[$TERM_CUR_TITLE;\u@\h$TERM_CUR_TITLE_END\]";;
    *)      TITLE='';;
esac

export PS1="$TITLE\[$TXT_CYAN_FG\][\#] \u@\H:\w \\$\[$TXT_YELLOW_FG\] "
trap "printf '$TXT_RESET'" DEBUG                                                # https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Different_colors_for_text_entry_and_console_output

TIME_SERVER='pool.ntp.org'
if ping -qc1 "$TIME_SERVER" 1>/dev/null 2>&1
then ntpdate -u "$TIME_SERVER"
fi

ISILON_TIME='time.isilon.com'
if ping -qc1 "$ISILON_TIME" 1>/dev/null 2>&1
then ntpdate -u "$ISILON_TIME"
fi

ISILON_GITHUB='github.west.isilon.com'
if ping -qc1 "$ISILON_GITHUB" 1>/dev/null 2>&1
then
    # These are for `gist` on Isilon networks.
    export GITHUB_URL="https://$ISILON_GITHUB/"
    export BROWSER='google-chrome'
fi

case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1  # TODO This is a BSD thing, not just OS X.
        toggle_hidden_files () {
            check='defaults read com.apple.Finder AppleShowAllFiles'
            if [ ! $check -o $("$check") = 'NO' ]
            then defaults write com.apple.Finder AppleShowAllFiles YES
            else defaults write com.apple.Finder AppleShowAllFiles NO
            fi
            killall Finder
        }
        alias hidden='toggle_hidden_files'
        alias ls='ls -G'  # TODO This is a BSD thing, not just OS X.
        ;;
    Linux)
        alias ls='ls --color=auto'
        ;;
    *) echo 'This OS is not recognized by dmtucker.bashrc.'
esac

alias ll='ls -lh'
refresh () {
    clear
    ll
}
alias cll='refresh'; alias r='refresh'
fresh () {
    cd "$@"
    refresh
}
alias cdr='fresh'

preview () {
    if [[ "$#" = '0' ]]
    then paths='.'
    else paths="$@"
    fi
    for path in $paths
    do
        if [[ ! -e "$path" ]]
        then
            if [[ "${path:0:1}" == '-' ]]
            then echo "$FUNCNAME cannot handle runtime options yet!" 1>&2
            else echo "$path does not exist." 1>&2
            fi
        elif [[ -d "$path" ]]
        then ls -l "$path"  # TODO -l doesn't belong here.
        elif [[ -f "$path" ]]
        then less "$path"
        else echo "$FUNCNAME cannot handle special files yet!" 1>&2
        fi
    done
}
alias l='preview'

wan_ip () {
    echo "$(curl -s 'http://api.ipify.org?format=txt')"
}
alias wimi='wan_ip'

generate_key () {                                                               # https://gist.github.com/earthgecko/3089509
    cat /dev/urandom |                                                          # http://en.wikipedia.org/?title=/dev/random
    env LC_CTYPE=C tr -dc "a-zA-Z0-9" |
    fold -w "${1:-32}" |
    head -n 1
}
alias keygen='generate_key'

alias projects='cdr ~/projects; gizmos/git.sh status'

if command -v fortune &> /dev/null; then fortune; fi

