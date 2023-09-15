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
    # Check if the application is installed
    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        sudo apt remove --purge -y "$app"
    else
        echo "$app is not installed."
    fi
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
    # Check if the application is already installed
    if ! dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        sudo apt install -y "$app"
    else
        echo "$app is already installed."
    fi
done

# Run the specified cleanup command
sudo apt autoremove -y && sudo apt clean

echo "Script execution completed."

# Prompt to reboot the system
read -p "Would you like to reboot the system now? (yes/no): " choice
case "$choice" in
  yes|Yes|Y|y) sudo reboot;;
  no|No|N|n) echo "Reboot aborted.";;
  *) echo "Invalid choice. Not rebooting.";;
esac
