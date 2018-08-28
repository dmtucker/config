.PHONY: help  all dev env  apt-optional bash bash-deps git pipenv ssh vim

help:
	@echo 'usage: make <target>'
	@echo '  where target can be:'
	@# Make will include this line as a target unless it begins with @.
	@make -pn | grep -B1 '#  Phony target (prerequisite of .PHONY).' | \
		grep -vE '#|--|@' | cut -d ':' -f '1' | sort | sed 's/^/    /'

################################################################################

all: dev env apt-optional

dev: git pipenv vim

env: bash ssh vim

################################################################################

# Assume essential packages are installed.
# https://www.debian.org/doc/debian-policy/#essential-packages
# apt-listbugs goes last to avoid test issues.
apt-optional: /usr/bin/apt-file /usr/bin/apt-listchanges /usr/bin/apt-transport-https /usr/bin/unattended-upgrades /usr/sbin/needrestart /usr/bin/apt-listbugs

bash: /bin/bash ~/.bashrc ~/.bash_profile /usr/bin/sudo /usr/bin/chsh bash-deps
	chsh -s /bin/bash

bash-deps: /bin/ping /usr/bin/curl /usr/bin/watch /usr/games/fortune /usr/games/lolcat git

git: /usr/bin/git ~/.gitconfig ~/.gitignore

# Depend on bash to make sure ~/.local/bin is in $PATH.
pipenv: ~/.local/bin/pipenv bash

ssh: /usr/bin/ssh ~/.ssh/id_ecdsa

vim: /usr/bin/vim.basic ~/.vimrc
	update-alternatives --set editor /usr/bin/vim.basic

################################################################################

/bin/ping: /usr/bin/sudo /usr/bin/apt-get
	sudo apt-get install -yqq iputils-ping | sed 's/^/# /'

/usr/bin/apt-file: /usr/bin/sudo /usr/bin/apt-get
	sudo apt-get install -yqq apt-file | sed 's/^/# /'
	sudo apt-file update | sed 's/^/# /'

/usr/bin/apt-get:
	echo 'Please install apt and try again: https://packages.debian.org/stable/apt' 1>&2
	false

/usr/bin/sudo:
	echo 'Please install sudo and try again: https://packages.debian.org/stable/sudo' 1>&2
	false

/usr/bin/vim.basic: /usr/bin/sudo /usr/bin/apt-get
	sudo apt-get install -yqq vim | sed 's/^/# /'

/usr/bin/apt-listbugs /usr/bin/apt-listchanges /usr/bin/apt-transport-https /usr/bin/chsh /usr/bin/curl /usr/bin/git /usr/bin/pip3 /usr/bin/ssh /usr/bin/ssh-keygen /usr/bin/unattended-upgrades /usr/bin/watch /usr/sbin/needrestart /usr/games/fortune /usr/games/lolcat: /usr/bin/sudo /usr/bin/apt-file /usr/bin/apt-get
	sudo apt-get install -yqq "$$(apt-file find "$@ " | cut -d: -f1)" | sed 's/^/# /'

~/.bashrc: ${PWD}/etc/bashrc.bash
~/.bash_profile: ~/.bashrc
~/.bashrc ~/.bash_profile:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	touch '$@'
	grep -q "source '$^'" '$@' || echo "source '$^'" >> '$@'

~/.gitconfig: ${PWD}/etc/gitconfig.ini
~/.gitignore: ${PWD}/etc/gitignore
~/.vimrc: ${PWD}/etc/vimrc.vim
~/.gitconfig ~/.gitignore ~/.vimrc:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	cp -i "$^" "$@"

~/.ssh/id_ecdsa: /usr/bin/ssh-keygen
	ssh-keygen -q -N '' -t 'ecdsa' -f "$@"

~/.local/bin/pipenv: /usr/bin/pip3
	PIP_REQUIRE_VIRTUALENV=false pip3 install --upgrade --user pipenv | sed 's/^/# /'
