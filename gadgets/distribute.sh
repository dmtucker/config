#!/usr/bin/env sh
# Send a command or package to all specified hosts.
# TODO Remove <path> in favor of <[user@]host[:path]>.
USAGE="usage: $(basename "$0") (command <string> | package <URI>) <path> [(<[user@]host>|-) ...]"
if [ "$#" -lt '4' ]
then
    echo "$USAGE" 1>&2
    [ "$#" -lt '3' ] && exit 1
    exit
fi
mode="$1"
x="$2"
path="$3"
shift 3
SUPPORTED_MODES='command package'
if ! echo "$SUPPORTED_MODES" | grep -q "$mode"
then
    echo "'$mode' is not recognized."
    echo "The following modes are supported: $SUPPORTED_MODES."
    exit 2
fi
handle () {
    local host="$1"
    local path="$2"
    local x="$3"
    shift 3
    local user="$(id -un)"
    printf "$user@$(hostname -s)"
    if [ "$user" = 'root' ]
    then printf '# '
    else printf '$ '
    fi
    case "$mode" in
        command) local local_command="ssh -qt $host cd $path; $x" ;;
        package) local local_command="scp $x $host:$path" ;;
    esac
    echo "$local_command"
    $local_command
}
error_count=0
for host in "$@"
do
    if [ "$host" = '-' ]
    then
        while read line
        do
            for host in $line
            do handle "$host" "$path" "$x" || error_count=$(($error_count+1))
            done
        done
    else
        handle "$host" "$path" "$x" || error_count=$(($error_count+1))
    fi
done
exit "$error_count"

