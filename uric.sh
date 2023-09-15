#!/bin/bash

# Update the package list and upgrade installed packages
sudo apt update -y
sudo apt upgrade -y

# List of unwanted applications to remove
unwanted_apps=(
    account-plugin-aim
    account-plugin-facebook
    account-plugin-flickr
    account-plugin-jabber
    account-plugin-salut
    account-plugin-yahoo
    aisleriot
    gnome-mahjongg
    gnome-mines
    gnome-sudoku
    landscape-client-ui-install
    unity-lens-music
    unity-lens-photos
    unity-lens-video
    unity-scope-audacious
    unity-scope-chromiumbookmarks
    unity-scope-clementine
    unity-scope-colourlovers
    unity-scope-devhelp
    unity-scope-firefoxbookmarks
    unity-scope-gmusicbrowser
    unity-scope-gourmet
    unity-scope-guayadeque
    unity-scope-musicstores
    unity-scope-musique
    unity-scope-openclipart
    unity-scope-texdoc
    unity-scope-tomboy
    unity-scope-video-remote
    unity-scope-virtualbox
    unity-scope-zotero
    unity-webapps-common
)

# Remove unwanted applications
for app in "${unwanted_apps[@]}"; do
    sudo apt remove --purge -y "$app"
done

# List of desired applications to install
desired_apps=(
    code # Visual Studio Code
    python3
    brave-browser # Brave Browser
    htop
    neofetch
)

# Install desired applications
for app in "${desired_apps[@]}"; do
    sudo apt install -y "$app"
done

# Run the specified cleanup command
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean

echo "Script execution completed."
