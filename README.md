# config

All you need is `make` (and CentOS, Debian, OS X, or Ubuntu).

```
$ make
usage: make <target>
  where target can be:
    bash
    chrome
    cli
    cli-all
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

### Utilities

* `r` (a.k.a. "refresh") clears the terminal and does an `ls -h -l`.
* `cdr` behaves like `cd`, but it does a refresh (see above) after.
* `l` behaves like `ls` if you give is a directory or `less` if you give it a file.
* `ll` (a.k.a. "long list") is an alias for `ls -h -l`.
* `capture` makes saving output easy by redirecting `stdout` and `stderr` to unique files in `$PWD`.
* `countdown` is basically a digital kitchen timer. Substitute `sleep` for it to add visible delays.
* `functions` will show you all set shell functions.
* `monitor` wraps commands that are then called every second forever. This is useful with tools like `ifconfig` while debugging network issues.
* `pprint` is a pretty printer for Bash code (which it accepts via `stdin`).
* `projects` (a.k.a. `proj`) will show the status of one or more `git` projects in `$PWD` or `$PROJECTS`. Usage tips are included below.
* `ssh_copy_id` emulates `ssh-copy-id`.
* `wan_ip` (a.k.a. `wimi`) will show your public IP address.

#### Projects

I'm a major `git` fan. My projects have projects (literally), and I context-switch between them a lot.
This workflow offers handy shortcuts for working with `git` projects.
Unfortunately, the color does not show here.

```
$ cd $PROJECTS
$ ls
EAP           botd          conmon        gjtk          ogre          sandbox       www
backlog       config        gizmos        keysmith      openfusion    vizit
$ proj config
total 152
-rw-r--r--  1 david  staff    18K Jan 20 00:13 LICENSE
-rw-r--r--  1 david  staff   5.4K Jun  8 23:26 Makefile
-rw-r--r--  1 david  staff    24B Jun  4 23:57 README.md
-rw-r--r--  1 david  staff   6.9K Jun  8 23:40 bashrc.bash
-rwxr-xr-x  1 david  staff   1.4K Apr 13 00:26 customize.py
-rwxr-xr-x  1 david  staff   873B Jun  4 23:57 deploy.sh
-rw-r--r--  1 david  staff   177B Apr 13 00:26 gitconfig.ini
-rw-r--r--  1 david  staff    53B Apr 11 13:55 screenrc.screen
-rw-r--r--@ 1 david  staff   293B Apr  9 12:32 sublime.json
-rw-r--r--  1 david  staff    25B Jan 31 14:26 vimrc.vim
On branch master
Your branch is behind 'origin/master' by 3 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)
nothing to commit, working directory clean
$ cd -
/Users/david/projects
proj config gizmos
config
## master...origin/master [behind 3]
gizmos
## master...origin/master
```

If `projects` cannot find a project in `$PWD`, it will look in `$PROJECTS` (which defaults to `$HOME/projects`).
This allows it to be very used very flexibly:

```
$ ls .
projA   projC
$ ls $PROJECTS
projA   projB
$ projects projA projB projC
projA
## master...origin/master
projB
## master...origin/master
projC
## master...origin/master
```
* Note: `./projA` was selected above, not `$PROJECTS/projA`.
 
Also, whenever multiple projects are selected, `$PWD` is preserved.
```
$ pwd
/Users/david/projects/openfusion
$ proj config gizmos
config
## master...origin/master [behind 3]
gizmos
## master...origin/master
$ pwd
/Users/david/projects/openfusion
```

# customize.py

Some personal configs contain sensitive information (e.g. passwords, etc.) that should not be published.
This script attempts to support those types of configs by asking the user to replace lines that contain a specified tag.

```
$ customize.py --help
usage: customize.py [-h] [-p PREFIX] [-t TAG] path [path ...]

positional arguments:
  path                  Specify files to customize.

optional arguments:
  -h, --help            show this help message and exit
  -p PREFIX, --prefix PREFIX
                        Specify a prefix for each line of output.
  -t TAG, --tag TAG     Specify a tag to search for.
```

# Docker

Try this environment out with Docker!

[![Docker Build Status](http://dockeri.co/image/dmtucker/config)](//registry.hub.docker.com/u/dmtucker/config)
