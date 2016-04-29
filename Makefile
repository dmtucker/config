.PHONY: help all bash bash-extras git screen ssh vim

help:
	@echo 'usage: make <target>'
	@echo '  where target can be:'
	@# Make will include this line as a target unless it begins with @.
	@make -pn | grep -B1 '#  Phony target (prerequisite of .PHONY).' | \
		grep -vE '#|--|@' | cut -d ':' -f '1' | sort | sed 's/^/    /'

all: bash git screen ssh vim

bash: /bin/bash ~/.bash_profile bash-extras
	sudo chsh -s /bin/bash "$$(id -un)"

bash-extras: /usr/bin/bc /usr/bin/curl /usr/games/fortune /usr/games/lolcat

git: /usr/bin/git ~/.gitconfig

screen: /usr/bin/screen ~/.screenrc

ssh: /usr/bin/ssh ~/.ssh/id_ecdsa

vim: /usr/bin/vim ~/.vimrc
	sudo update-alternatives --set editor /usr/bin/vim.basic

################################################################################

/bin/bash /usr/bin/bc /usr/bin/curl /usr/games/fortune /usr/bin/git /usr/games/lolcat /usr/bin/screen /usr/bin/ssh /usr/bin/vim:
	# Installing $@...
	sudo "${PWD}/deploy.sh" "$@" | sed 's/^/# /'

~/.bashrc: ${PWD}/etc/bashrc.bash
~/.bash_profile: ~/.bashrc
~/.bashrc ~/.bash_profile:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	touch '$@'
	grep -q "source '$^'" '$@' || echo "source '$^'" >> '$@'

~/.gitconfig: ${PWD}/etc/gitconfig.ini
~/.screenrc: ${PWD}/etc/screenrc.screen
~/.vimrc: ${PWD}/etc/vimrc.vim
~/.gitconfig ~/.screenrc ~/.vimrc:
	@[ -e "$$(dirname "$@")" ] || mkdir -p "$$(dirname "$@")"
	cp -i "$^" "$@"

~/.ssh/id_ecdsa:
	ssh-keygen -q -N '' -t 'ecdsa' -f "$@"
