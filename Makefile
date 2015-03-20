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


.PHONY: bash clock git irssi linux linux-gedit ubuntu ubuntu-workspaces vim

bash: ~/.bash_profile
	chsh -s /bin/bash "$$(id -un)"

clock:
	sudo ntpdate -u 'pool.ntp.org'

git: ~/.gitconfig

irssi: ~/.irssi/config

linux: linux-gedit

linux-gedit:
	# Run the following command for a list of all options:
	# gsettings list-recursively | grep -i gedit
	gsettings set org.gnome.gedit.preferences.editor auto-indent true
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true
	gsettings set org.gnome.gedit.preferences.editor tabs-size uint32 4

ubuntu: linux ubuntu-workspaces
	ubuntu-drivers autoinstall

ubuntu-workspaces:
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

vim: ~/.vimrc
