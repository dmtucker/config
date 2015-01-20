~/.bashrc: bashrc.bash
	cat $@ 2> /dev/null | grep "source ${PWD}/$^" || \
		printf "source ${PWD}/$^" >> $@

~/.kde/share/config/konversationrc: konversationrc
	cp -i $^ $@

~/.vimrc: vimrc.vim
	cp -i $^ $@


.PHONY: all bash config konversation vim

all: bash vim

bash: ~/.bashrc

konversation: ~/.kde/share/config/konversationrc

vim: ~/.vimrc
