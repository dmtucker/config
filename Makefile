~/.bashrc: ${PWD}/bashrc.bash
~/.bash_profile: ~/.bashrc
~/.bashrc ~/.bash_profile:
	cat $@ 2> /dev/null | grep "source $^" || echo "source $^" >> $@


~/.irssi/config: irssi.cfg
	if [ -w $@ ] || ([ ! -e $@ ] && [ -w "$$(dirname $@)" ]); then cp -i $^ $@; else sudo cp -i $^ $@; fi
	./personalize.sh $@


/etc/hosts: $(shell hostname -f | cut -d. -f2-).hosts
~/.gitconfig: gitconfig.cfg
~/.vimrc: vimrc.vim

/etc/hosts ~/.gitconfig ~/.vimrc:
	if [ -w $@ ] || ([ ! -e $@ ] && [ -w "$$(dirname $@)" ]); then cp -i $^ $@; else sudo cp -i $^ $@; fi

/usr/bin/vim:
	sudo apt-get install vim


.PHONY: bash chrome gedit git hosts nvidia pycharm time ubuntu vim workspaces

bash: ~/.bash_profile
	chsh -s /bin/bash "$$(id -un)"

chrome:
	# Source: http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line
	# Access: 2014-11-17
	apt-get install libxss1 libappindicator1 libindicator7  # TODO Are these really necessary?
	wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'  # TODO Use 'i386' instead of 'amd64' for 32bit systems.
	dpkg -i google-chrome*.deb

gedit:
	# TODO Install if not already.
	# Run the following command for a list of all options:
	# gsettings list-recursively | grep -i gedit
	gsettings set org.gnome.gedit.preferences.editor auto-indent true           # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true         # default: false?
	gsettings set org.gnome.gedit.preferences.editor tabs-size uint32 4         # default: 8?

git: ~/.gitconfig

hosts: /etc/hosts

irssi: ~/.irssi/config

nvidia:
	apt-get install nvidia-current
	nvidia-xconfig

pycharm:
	# Install PyCharm CE on a Debian-like system.
	# Source: http://www.sysads.co.uk/2014/06/install-pycharm-3-4-ubuntu-14-04/
	# Access: 2014-11-10
	wget -q -O - 'http://archive.getdeb.net/getdeb-archive.key' | sudo apt-key add -
	sudo echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -sc)-getdeb apps" >> '/etc/apt/sources.list.d/getdeb.list'
	sudo apt-get update
	sudo apt-get install pycharm
	# TODO PyCharm profiles?

time:
	sudo ntpdate -u 'pool.ntp.org'

ubuntu: linux workspaces
	ubuntu-drivers autoinstall

vim: ~/.vimrc /usr/bin/vim

workspaces:
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
