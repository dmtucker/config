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
	if cut -d ':' -f '1' /etc/passwd | grep -q "$$(id -un)"; \
	then chsh -s /bin/bash "$$(id -un)"; \
	fi

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

gnome-gedit:
	gsettings set org.gnome.gedit.preferences.editor auto-indent true
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true
	gsettings set org.gnome.gedit.preferences.editor tabs-size 4
	# For more options, run `gsettings list-recursively | grep -i gedit`.


mac: mac-sublime

mac-sublime: ${PWD}/sublime.json
	ln -fs "$^" ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings


ubuntu: ubuntu-workspaces
	ubuntu-drivers autoinstall

ubuntu-workspaces:
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

