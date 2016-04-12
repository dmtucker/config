# config

All you need is `make` (and CentOS, Debian, OS X, or Ubuntu).

```
$ make
usage: make <target>
  where target can be:
    bash
    chrome
    cli
    gedit
    git
    gnome
    help
    nautilus
    print
    screen
    ssh
    sublime
    vim
    workstation
```

## bash

I like to use `bash`, but I generally script in `sh` for portability.

### Color

Life is better in color.

* The prompt, the command, and the output are different colors which makes it easier to see the beginning and end of the output in the scrollback.
* `git`, `grep`, and `ls` coloring is almost essential.
* Portable (ANSI) color constants are included.

### Functions

A number of handy functions are included.

``` bash
define -f
```

#### Aliases
* `ll` (a.k.a. "long list") is an alias for `ls -h -l`.
* `r` (a.k.a. "refresh") clears the terminal and does an `ls -h -l`.

# Docker

[Try this environment out with Docker!](https://registry.hub.docker.com/u/dmtucker/config)


# Auto-deploy

I like to be able to reimage often (or quickly setup a new workstation).
That is what `deploy.sh` is for.

``` sh
wget -qO- https://dmtucker.github.io/config/deploy.sh | sh
```
