~/.bashrc: ${PWD}/bashrc.bash
~/.bash_profile: ~/.bashrc
~/.bashrc ~/.bash_profile:
	cat $@ 2> /dev/null | grep "source $^" || echo "source $^" >> $@


~/.irssi/config: ${PWD}/irssi.pl
	if [ -w $@ ] || ([ ! -e $@ ] && [ -w "$$(dirname $@)" ]); then cp -i $^ $@; else sudo cp -i $^ $@; fi
	./personalize.sh $@


~/.gitconfig: ${PWD}/gitconfig.ini
~/.vimrc: ${PWD}/vimrc.vim
~/.gitconfig ~/.vimrc:
	if [ -w "$@" ] || ([ ! -e "$@" ] && [ -w "$$(dirname "$@")" ]); then cp -i "$^" "$@"; else sudo cp -i "$^" "$@"; fi


.PHONY: bash clock gedit git irssi ubuntu ubuntu-workspaces vim

bash: ~/.bash_profile
	chsh -s /bin/bash "$$(id -un)"

clock:
	sudo ntpdate -u 'pool.ntp.org'

gedit:
	# Run the following command for a list of all options:
	# gsettings list-recursively | grep -i gedit
	gsettings set org.gnome.gedit.preferences.editor auto-indent true           # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true         # default: false?
	gsettings set org.gnome.gedit.preferences.editor tabs-size uint32 4         # default: 8?

git: ~/.gitconfig

irssi: ~/.irssi/config

ubuntu: ubuntu-workspaces
	ubuntu-drivers autoinstall

ubuntu-workspaces:
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

vim: ~/.vimrc
