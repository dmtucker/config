#!/usr/bin/env sh
USAGE="$(basename $0) <path>"
if [ "$#" != '1' ]
then
    echo "$USAGE"
    exit 1
fi
f="$1"
shift
personalize () {
    local f="$1"
    local tag="$2"
    local data="$3"
    shift 3
    local tmp="$f.tmp"
    touch "$tmp"
    while read line
    do
        if [ "$(echo "$line" | grep "$tag" &>/dev/null)" != '' ]
        then line="$(echo "$line" | sed "s/<personalize>/$data/")"
        fi
        echo "$line" >> "$tmp"
    done < "$f"
    sed -i "s/$tag//" "$tmp"
    mv -f "$tmp" "$f"
}
case "$f" in
    *.irssi/config)
        username="$(id -un)"
        printf "Username: [$username] "
        read input
        [ "$input" != '' ] && username="$input"
        nickname="$username"
        printf "Nickname: [$nickname] "
        read input
        [ "$input" != '' ] && nickname="$input"
        printf "NickServ Password: "
        stty -echo && read password; stty echo; printf '\n'
        OS="$(lsb_release -si 2> /dev/null | tr '[:upper:]' '[:lower:]')"
        if [ "$OS" != '' ]
        then
            echo "OS: $OS"
            personalize "$f" '##PERSONALIZE:OS##' "$OS"
        fi
        [ "$password" != '' ] && personalize "$f" '##PERSONALIZE:password##' "$password"
        personalize "$f" '##PERSONALIZE:nickname##' "$nickname"
        personalize "$f" '##PERSONALIZE:username##' "$username"
        ;;
    *)
        echo "$USAGE"
        exit 2
        ;;
esac

