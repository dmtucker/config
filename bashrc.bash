[[ $- = *i* ]] || return  # Require an interactive shell.
if command -v fortune &>/dev/null; then fortune; fi

######################################################################## exports

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

######################################################################### prompt

TITLE=''
case $TERM in
    xterm*) TITLE="\[$TERM_CUR_TITLE;\u@\h$TERM_CUR_TITLE_END\]";;
esac
export PS1="$TITLE\[$TXT_CYAN_FG\][\D{%F}T\t\D{%z}] \u@\H \\$\[$TXT_YELLOW_FG\] "
trap "printf '$TXT_RESET'" DEBUG  # Make output the default color.

################################################################ system-specific

ISILON_GITHUB='github.west.isilon.com'
if ping -q -w '1' -i '0.2' "$ISILON_GITHUB" &>/dev/null
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
    *) echo 'This OS is not recognized.'
esac

###################################################################### utilities
# Note: A utility tier may only use utilities on lower tiers.
######################################################################### tier 0

alias ll='ls -lh'

refresh () {
    [[ "$#" != '0' ]] && echo "usage: $FUNCNAME" 1>&2 && return 1
    clear
    ll
}
alias r='refresh'

fresh () {
    cd $@
    refresh
}
alias cdr='fresh'

######################################################################### tier 1

preview () {
    paths='.'
    [[ "$#" = '0' ]] || paths="$@"
    for path in $paths
    do
        if [[ ! -e "$path" ]]
        then
            if [[ "${path:0:1}" == '-' ]]
            then echo "$FUNCNAME cannot handle runtime options yet!" 1>&2
            else echo "$path does not exist." 1>&2
            fi
        elif [[ -d "$path" ]]
        then ll "$path"
        elif [[ -f "$path" ]]
        then less "$path"
        else echo "$FUNCNAME cannot handle special files yet!" 1>&2
        fi
    done
}
alias l='preview'

projects () {
    [[ "$#" != '0' ]] && echo "usage: $FUNCNAME" 1>&2 && return 1
    local loc="$HOME/projects"
    [[ -e "$loc" ]] || mkdir -p "$loc"
    cdr "$loc"
    for repo in $(echo * | sort)
    do
        echo "$(tput setaf 4)$repo$(tput sgr0)"
        cd "$loc/$repo" &&
        for cmd in 'fetch --all -q' 'status -bs'
        do git $cmd
        done
    done
    cd "$loc"
}

######################################################################### tier 2

countdown () {
    [[ "$#" != '1' ]] && echo "usage: $FUNCNAME <seconds>" 1>&2 && return 1
    local from="$1"
    shift 1
    local prompt='countdown: '
    printf "$prompt"
    for i in $(seq -f "%0${#from}g" $(($from)) -1 1)
    do
        printf "$i"
        sleep 1
        for j in $(seq "${#from}"); do printf '\b'; done
    done
    for i in $(seq "${#prompt}"); do printf '\b'; done
}

generate_key () {  # https://gist.github.com/earthgecko/3089509
    [[ "$#" != '0' ]] && echo "usage: $FUNCNAME" 1>&2 && return 1
    cat /dev/urandom |
    env LC_CTYPE=C tr -dc "a-zA-Z0-9" |
    fold -w "${1:-32}" |
    head -n 1
}
alias keygen='generate_key'

random_ipv6 () {
    echo "$(
        od -An -tx2 -N1  /dev/urandom | sed 's/^\s00/fd/'\
    ):$(\
        od -An -tx2 -N14 /dev/urandom | sed -e 's/ *//' -e 's/ /:/g'
    )"
}

wan_ip () {
    [[ "$#" != '0' ]] && echo "usage: $FUNCNAME" 1>&2 && return 1
    echo "$(curl -s 'http://api.ipify.org?format=txt')"
}
alias wimi='wan_ip'

where () {
    [[ "$#" != '1' ]] && echo "usage: $FUNCNAME <name>" 1>&2 && return 1
    local name="$1"
    shift 1
    find . -iname $name \( -type f -o -type d \) -print
}
