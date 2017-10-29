#!/usr/bin/env bash
# Pretty print a bash script.
# Example: Style an existing script in-place.
#   echo "$(bash-lint < ~/.bashrc)" > ~/.bashrc
usage="usage: $FUNCNAME < file.bash"
if (( $# != 0 ))
then
    echo "$usage" 1>&2
    return "$LINENO"
fi
printf 'pretty(){ %s\n }; declare -f pretty' "$(cat)" | bash
