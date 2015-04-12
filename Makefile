.PHONY: help

help:
	@echo 'usage: make <target>'
	@echo '  where target can be:'
	@# Make will include this line as a target unless it begins with @.
	@make -pn | grep -B1 '#  Phony target (prerequisite of .PHONY).' | \
		grep -vE '#|--|@' | cut -d ':' -f '1' | sort | sed 's/^/    /'

################################################################################


/bin/bash /usr/bin/git /usr/bin/irssi /usr/bin/screen /usr/bin/vim:
	# Installing $@...
	@case "$$(uname -s)" in \
		Darwin) \
			echo "Install '$$(basename "$@")' with Homebrew."; \
			false;; \
		Linux) \
			case "$$(lsb_release -is)" in \
				Debian) \
					sudo apt-get -y -qq install "$$(basename "$@")" | \
						sed 's/^/# /';; \
			esac;; \
		*) \
			echo "Your operating system ($$(uname -s)) is not supported."; \
			false;; \
	esac


~/.bashrc: ${PWD}/bashrc.bash
~/.bash_profile: ~/.bashrc
~/.bashrc ~/.bash_profile:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	grep -q "source '$^'" '$@' || echo "source '$^'" >> '$@'


~/.gitconfig: ${PWD}/gitconfig.ini
~/.irssi/config: ${PWD}/irssi.pl
~/.screenrc: ${PWD}/screenrc.screen
~/.vimrc: ${PWD}/vimrc.vim
~/.gitconfig ~/.irssi/config ~/.screenrc ~/.vimrc:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	cp -i "$^" "$@"


.PHONY: bash git irssi screen vim

bash: /bin/bash ~/.bash_profile
	-[ "$$(uname -s)" = 'Linux' ] && chsh -s /bin/bash

git: /usr/bin/git ~/.gitconfig

irssi: /usr/bin/irssi ~/.irssi/config
	./personalize.sh "$^"

screen: /usr/bin/screen ~/.screenrc

vim: /usr/bin/vim ~/.vimrc


.PHONY: cli cli-all

cli: bash git screen vim

cli-all: cli irssi


################################################################################


.PHONY: gnome gnome-gedit mac mac-sublime ubuntu ubuntu-workspaces


gnome: gnome-gedit
	command -v gnome-session > /dev/null || exit

gnome-gedit:
	command -v gedit > /dev/null || exit
	gsettings set org.gnome.gedit.plugins.filebrowser open-at-first-doc false
	gsettings set org.gnome.gedit.preferences.editor auto-indent true
	gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true
	gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
	gsettings set org.gnome.gedit.preferences.editor tabs-size 4
	gsettings set org.gnome.gedit.preferences.ui side-panel-visible true
	# For more options, run `gsettings list-recursively | grep -i gedit`.


mac:
	[ "$$(uname -s)" = 'Darwin' ] || exit

mac-sublime: ${PWD}/sublime.json
	[ "$$(uname -s)" = 'Darwin' ] || exit
	ln -fs "$^" ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings


ubuntu: ubuntu-workspaces
	[ "$$(lsb_release -is)" = 'Ubuntu' ] || exit
	ubuntu-drivers autoinstall

ubuntu-workspaces:
	[ "$$(lsb_release -is)" = 'Ubuntu' ] || exit
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

