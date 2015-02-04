~/.bashrc: bashrc.bash
	# TODO Install if not already.
	cat $@ 2> /dev/null | grep "source ${PWD}/$^" || echo "source ${PWD}/$^" >> $@


/etc/hosts: $(shell hostname -f | cut -d. -f2-).hosts
~/.irssi/config: irssi.cfg
~/.kde/share/config/konversationrc: konversationrc.cfg
~/.vimrc: vimrc.vim

/etc/hosts ~/.irssi/config ~/.kde/share/config/konversationrc.cfg ~/.vimrc:
	if [ -w $@ ]; then cp -i $^ $@; else sudo cp -i $^ $@; fi

/usr/bin/vim:
	sudo apt-get install vim


.PHONY: bash chrome gedit gnome hosts konversation nvidia pycharm time ubuntu vim workspaces

bash: ~/.bashrc
	#chsh -s /bin/bash "$(whoami)"  # This is the non-LDAP way to do this.
	#echo "nss_override_attribute_value loginShell /bin/bash" >> /etc/ldap/ldap.conf

chrome:
	# Source: http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line
	# Access: 2014-11-17
	apt-get install libxss1 libappindicator1 libindicator7  # TODO Are these really necessary?
	wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'  # TODO Use 'i386' instead of 'amd64' for 32bit systems.
	dpkg -i google-chrome*.deb

gedit: gnome
	# TODO Install if not already.
	# Run the following command for a list of all options:
	# gsettings list-recursively | grep -i gedit
	gsettings set org.gnome.gedit.preferences.editor auto-indent true           # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true  # default: false?
	gsettings set org.gnome.gedit.preferences.editor insert-spaces true         # default: false?
	gsettings set org.gnome.gedit.preferences.editor tabs-size uint32 4         # default: 8?

gnome:

hosts: /etc/hosts

irssi: ~/.irssi/config

konversation: ~/.kde/share/config/konversationrc.cfg
	# TODO Install if not already.

nvidia:
	apt-get install nvidia-current
	nvidia-xconfig

pycharm:
	# Install PyCharm CE on a Debian-like system.
	# Source: http://www.sysads.co.uk/2014/06/install-pycharm-3-4-ubuntu-14-04/
	# Access: 2014-11-10
	wget -q -O - 'http://archive.getdeb.net/getdeb-archive.key' | apt-key add -
	echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -sc)-getdeb apps" >> '/etc/apt/sources.list.d/getdeb.list'
	apt-get update
	apt-get install pycharm
	# TODO PyCharm profiles?

time:
	sudo ntpdate -u 'pool.ntp.org'

ubuntu: linux workspaces
	ubuntu-drivers autoinstall

vim: ~/.vimrc /usr/bin/vim

workspaces:
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
