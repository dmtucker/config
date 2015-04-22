.PHONY: help

help:
	@echo 'usage: make <target>'
	@echo '  where target can be:'
	@# Make will include this line as a target unless it begins with @.
	@make -pn | grep -B1 '#  Phony target (prerequisite of .PHONY).' | \
		grep -vE '#|--|@' | cut -d ':' -f '1' | sort | sed 's/^/    /'

################################################################################


/bin/bash /usr/bin/gedit /usr/bin/git /usr/bin/irssi /usr/bin/screen /usr/bin/ssh /usr/bin/vim:
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
				*) \
					echo "Your distribution ($$(lsb_release -is)) is not supported."; \
					false;; \
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


~/.ssh/id_ecdsa:
	ssh-keygen -q -N '' -t 'ecdsa' -f "$@"


.PHONY: bash git irssi screen ssh vim

bash: /bin/bash ~/.bash_profile
	-[ "$$(uname -s)" = 'Linux' ] && chsh -s /bin/bash

git: /usr/bin/git ~/.gitconfig

irssi: /usr/bin/irssi ~/.irssi/config
	./customize.py -t '##customize.py##' -p '# ' ~/.irssi/config

screen: /usr/bin/screen ~/.screenrc

ssh: /usr/bin/ssh ~/.ssh/id_ecdsa

vim: /usr/bin/vim ~/.vimrc


.PHONY: cli cli-all

cli: bash git screen ssh vim

cli-all: cli irssi


################################################################################


.PHONY: chrome gedit nautilus print sublime

chrome:
	@case "$$(uname -s)" in \
		Darwin) \
			echo "Install '$$(basename "$@")' with Homebrew."; \
			false;; \
		Linux) \
			case "$$(lsb_release -is)" in \
				Debian) \
					case "$$(uname -m)" in \
						x86_64) \
							wget -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
							sudo dpkg -i ./google-chrome*.deb && \
							rm ./google-chrome*.deb;; \
						*) \
							echo "Your architecture $$(uname -m) is not supported."; \
							false;; \
					esac;; \
				*) \
					echo "Your distribution ($$(lsb_release -is)) is not supported."; \
					false;; \
			esac;; \
		*) \
			echo "Your operating system ($$(uname -s)) is not supported."; \
			false;; \
	esac

gedit: /usr/bin/gedit
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

nautilus:
	gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
	# For more options, run `gsettings list-recursively | grep -i nautilus`.


print:
	@case "$$(uname -s)" in \
		Darwin) \
			echo "Use System Preferences."; \
			false;; \
		Linux) \
			case "$$(lsb_release -is)" in \
				Debian) \
					sudo apt-get install cups && \
					sudo adduser "$$(id -un)" lpadmin && \
					echo 'http://localhost:631/admin';; \
				*) \
					echo "Your distribution ($$(lsb_release -is)) is not supported."; \
					false;; \
			esac;; \
		*) \
			echo "Your operating system ($$(uname -s)) is not supported."; \
			false;; \
	esac

sublime: ${PWD}/sublime.json
	@case "$$(uname -s)" in \
		Darwin) \
			ln -fs "$^" ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings;;
		*) \
			echo "Your operating system ($$(uname -s)) is not supported."; \
			false;; \
	esac


.PHONY: gnome

gnome: gedit nautilus


################################################################################

.PHONY: workstation

workstation: cli-all gnome chrome print
