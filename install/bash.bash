#!/usr/bin/env bash
[ "$#" -ne 3 ] && {
    echo "usage: '${BASH_SOURCE[0]}' config-repo config-home config-undo" 1>&2
    exit 1
}
config_repo="$1"
config_home="$2"
config_undo="$3"

# Install configuration for Bash.
command -v bash &>/dev/null || {
    echo 'Bash is not installed. Skipping configuration...'
    exit 0
}
config_bashrc="$config_home/bashrc.bash"
cp -v "$config_repo/config/$(basename "$config_bashrc")" "$config_bashrc"
echo "rm '$config_bashrc'" >> "$config_undo"

signature='# added by dmtucker/config'
source_config="source '$config_bashrc'"
bashrc="$HOME/.bashrc"
grep -q "$source_config" "$bashrc" || {
    echo "sed -i.old '\|$signature|d' '$bashrc'" >> "$config_undo"
    target='# dmtucker/config install target'
    if grep -q "$target" "$bashrc"
    then echo "sed -i.old 's|'$(printf '%q' "$source_config")'  $signature|$target|' '$bashrc'" >> "$config_undo"
    else echo "$target" >> "$bashrc"
    fi
    sed -i.old "s|$target|$source_config  $signature|" "$bashrc"
}

# "You should therefore always have source ~/.bashrc at the end of your .bash_profile
# in order to force it to be read by a login shell."
# http://mywiki.wooledge.org/DotFiles
source_bashrc='source ~/.bashrc'
bash_profile="$HOME/.bash_profile"
grep -q "$source_bashrc" "$bash_profile" || {
    echo "sed -i.old '\|$signature|d' '$bash_profile'" >> "$config_undo"
    echo "$source_bashrc  $signature" >> "$bash_profile"
}

# There is no way to affect the calling environment.
echo 'Bash configuration succeeded. Restart Bash.'
