# config

[![Build Status](https://img.shields.io/travis/dmtucker/config.svg)](https://travis-ci.org/dmtucker/config) [![Docker Build Status](https://img.shields.io/docker/build/dmtucker/config.svg)](https://hub.docker.com/r/dmtucker/config/)

``` sh
make help
```

# Automatic Deployment

``` sh
wget -qO- https://dmtucker.github.io/config/deploy.sh | bash
```

OR

``` sh
curl -sSL https://dmtucker.github.io/config/deploy.sh | bash
```

## Git

``` sh
path="$HOME/.dmtucker.gitconfig"
curl -sSL 'https://raw.githubusercontent.com/dmtucker/config/master/etc/gitconfig.ini' > "$path" && {
    git config --global --type path include.path "$HOME/.dmtucker.gitconfig"
}
```

## Vim

``` sh
path="$HOME/.dmtucker.vimrc"
curl -sSL 'https://raw.githubusercontent.com/dmtucker/config/master/etc/vimrc.vim' > "$path" && {
    source_path="source $path"
    home_vimrc="$HOME/.vimrc"
    grep -q "$source_path" "$home_vimrc" || echo "$source_path" >> "$home_vimrc"
}
```
