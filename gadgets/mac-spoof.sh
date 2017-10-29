#!/usr/bin/env sh

# Randomly generate a new MAC, and apply it to an interface (if provided).

if [ "$#" -gt '1' ]
then
    echo "usage: $(basename "$0") [interface]" 1>&2
    exit 1
fi

random_mac="$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')"

if [ "$#" = '1' ]
then
    interface="$1"
    case "$(uname -s)" in
        Darwin)
            printf "$(ifconfig "$interface" | grep ether | awk '{ print $2 }') -> "
            sudo ifconfig "$interface" ether "$random_mac"
            sudo ifconfig "$interface" down
            sudo ifconfig "$interface" up
            ;;
        Linux)
            printf "$(ip link show dev "$interface" | grep ether | awk '{ print $2 }') -> "
            sudo ip link set dev "$interface" down
            sudo ip link set dev "$interface" address "$random_mac"
            sudo ip link set dev "$interface" up
            ;;
        *)
            echo "Your OS ($(uname -s)) is not supported." 1>&2
            exit 1
    esac
fi

echo "$random_mac"
