#!/usr/bin/env bash

set -o errexit;   # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
set -o xtrace;    # Show commands as they execute.

url='https://raw.githubusercontent.com/dmtucker/config/master/bashrc.bash'
configdir="${XDG_CONFIG_HOME:-~/.config}/dmtucker"
wget --directory-prefix "$configdir" "$url" && {
    source_cmd="source '$configdir/$(basename "$url")'"
    bashrc=~/.bashrc
    grep -q "$source_cmd" "$bashrc" || echo "$source_cmd" >> "$bashrc"
}

# You should therefore always have source ~/.bashrc at the end of your .bash_profile
# in order to force it to be read by a login shell.
# http://mywiki.wooledge.org/DotFiles
source_bashrc='source ~/.bashrc'
bash_profile=~/.bash_profile
grep -q "$source_bashrc" "$bash_profile" || echo "$source_bashrc" >> "$bash_profile"
