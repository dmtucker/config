#!/usr/bin/env sh
configure_gedit () 
{ 
    gsettings set org.gnome.gedit.plugins.filebrowser open-at-first-doc false;
    gsettings set org.gnome.gedit.preferences.editor auto-indent true;
    gsettings set org.gnome.gedit.preferences.editor create-backup-copy false;
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers true;
    gsettings set org.gnome.gedit.preferences.editor display-right-margin true;
    gsettings set org.gnome.gedit.preferences.editor insert-spaces true;
    gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion';
    gsettings set org.gnome.gedit.preferences.editor tabs-size 4;
    gsettings set org.gnome.gedit.preferences.ui side-panel-visible true;
    gsettings set org.gnome.gedit.plugins active-plugins "['filebrowser', 'time', 'git', 'modelines', 'docinfo', 'spell', 'drawspaces', 'bookmarks']"
};
configure_nautilus () 
{ 
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
};
configure_terminal () 
{ 
    gsettings set org.gnome.Terminal.Legacy.Settings dark-theme true
};
configure_gedit;
configure_nautilus;
configure_terminal