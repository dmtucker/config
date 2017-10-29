#!/usr/bin/env sh
encoded_attribute () {
    case "$1" in
        0) printf '    normal';;
        1) printf '      bold';;
        4) printf 'underlined';;
        5) printf '  blinking';;
        7) printf '  reversed';;
        8) printf ' invisible';;
    esac
}
encoded_color () {
    case "$1" in
        0) printf '  black';;
        1) printf '    red';;
        2) printf '  green';;
        3) printf ' yellow';;
        4) printf '   blue';;
        5) printf 'magenta';;
        6) printf '   cyan';;
        7) printf '  white';;
    esac
}
for a in 0 1 4 5 7 8  # attribute
do
    for f in $(seq 0 7)  # foreground
    do
        for b in $(seq 0 7)  # background
        do
            printf "$(encoded_attribute "$a") $(encoded_color "$f") on $(encoded_color "$b"): "
            printf   "\\033[${a};3${f};4${b}m"
            printf "\\\\033[${a};3${f};4${b}m"
            printf "$(tput sgr0)\n"
        done
    done
done

