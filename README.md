# config

[![Build Status](https://img.shields.io/travis/dmtucker/config.svg)](https://travis-ci.org/dmtucker/config)

## Bash

``` sh
wget -O- 'https://raw.githubusercontent.com/dmtucker/config/master/deploy.bash' | bash
```

## Git

``` sh
url='https://raw.githubusercontent.com/dmtucker/config/master/gitconfig.ini'
configdir="${XDG_CONFIG_HOME:-"$HOME/.config"}/dmtucker"
wget --directory-prefix "$configdir" "$url" && {
    git config --global --type path include.path "$configdir/$(basename "$url")"
}
```

## Vim

``` sh
url='https://raw.githubusercontent.com/dmtucker/config/master/vimrc.vim'
configdir="${XDG_CONFIG_HOME:-"$HOME/.config"}/dmtucker"
wget --directory-prefix "$configdir" "$url" && {
    source_cmd="source $configdir/$(basename "$url")"
    vimrc="$HOME/.vimrc"
    grep -q "$source_cmd" "$vimrc" || echo "$source_cmd" >> "$vimrc"
}
```
