#!/usr/bin/env bash
[ "$#" -ne 3 ] && {
    echo "usage: '${BASH_SOURCE[0]}' config-repo config-home config-undo" 1>&2
    exit 1
}
config_repo="$1"
config_home="$2"
config_undo="$3"

# Deploy configuration for Bash.
command -v bash &>/dev/null || {
    echo 'Bash is not installed. Skipping configuration...'
    exit 0
}
config_bashrc="$config_home/bashrc.bash"
cp "$config_repo/config/$(basename "$config_bashrc")" "$config_bashrc"
echo "rm '$config_bashrc'" >> "$config_undo"
source_config_bashrc="source '$config_bashrc'"
bashrc="$HOME/.bashrc"
grep -q "$source_config_bashrc" "$bashrc" || {
    echo "$source_config_bashrc" >> "$bashrc"
    echo "sed -i.old '\#'""$(printf '%q' "$source_config_bashrc")""'#d' '$bashrc'" >> "$config_undo"
}

# "You should therefore always have source ~/.bashrc at the end of your .bash_profile
# in order to force it to be read by a login shell."
# http://mywiki.wooledge.org/DotFiles
source_bashrc='source ~/.bashrc'
bash_profile="$HOME/.bash_profile"
grep -q "$source_bashrc" "$bash_profile" || {
    echo "$source_bashrc" >> "$bash_profile"
    echo "sed -i.old '\#'""$(printf '%q' "$source_bashrc")""'#d' '$bash_profile'" >> "$config_undo"
}

# There is no way to affect the calling environment.
echo 'Bash configuration succeeded. Restart Bash.'
