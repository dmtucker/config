# config

[![Build Status](https://img.shields.io/travis/dmtucker/config.svg)](https://travis-ci.org/dmtucker/config)

## Bash

``` sh
wget -O- 'https://raw.githubusercontent.com/dmtucker/config/master/deploy.bash' | bash
```

## Git

``` sh
path="$HOME/.dmtucker.gitconfig"
wget -O- 'https://raw.githubusercontent.com/dmtucker/config/master/gitconfig.ini' > "$path" && {
    git config --global --type path include.path "$HOME/.dmtucker.gitconfig"
}
```

## Vim

``` sh
path="$HOME/.dmtucker.vimrc"
wget -O- 'https://raw.githubusercontent.com/dmtucker/config/master/vimrc.vim' > "$path" && {
    source_path="source $path"
    home_vimrc="$HOME/.vimrc"
    grep -q "$source_path" "$home_vimrc" || echo "$source_path" >> "$home_vimrc"
}
```
