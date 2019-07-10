#!/usr/bin/env bash
[ "$#" -ne 3 ] && {
    echo "usage: '${BASH_SOURCE[0]}' config-repo config-home config-undo" 1>&2
    exit 1
}
config_repo="$1"
config_home="$2"
config_undo="$3"

# Deploy configuration for Vim.
command -v vim &>/dev/null || {
    echo 'Vim is not installed. Skipping configuration...'
    exit 0
}
config_vimrc="$config_home/vimrc.vim"
cp "$config_repo/config/$(basename "$config_vimrc")" "$config_vimrc"
echo "rm '$config_vimrc'" >> "$config_undo"
source_config_vimrc="source $config_vimrc"
vimrc="$HOME/.vimrc"
grep -q "$source_config_vimrc" "$vimrc" || {
    echo "$source_config_vimrc" >> "$vimrc"
    echo "sed -i.old '\#'""$(printf '%q' "$source_config_vimrc")""'#d' '$vimrc'" >> "$config_undo"
}
echo 'Vim configuration succeeded.'
