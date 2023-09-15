#!/bin/bash

# Initialize lists to track command success and failures
successful_commands=()
failed_commands=()

# Helper function to run a command and track its success or failure
run_command() {
    local cmd="$1"
    eval "$cmd"
    local status=$?
    if [ $status -eq 0 ]; then
        successful_commands+=("$cmd")
    else
        failed_commands+=("$cmd")
    fi
    return $status
}

# Update the package list and upgrade installed packages
run_command "sudo apt update -y"
run_command "sudo apt upgrade -y"

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
    firefox
    obs-studio
    screenrec
    pycharm
    remmina
    rocketchat-desktop
    rhythmbox
)

# Create an .ods file for logging removed applications
run_command "echo 'Removed Applications:' > 15.09.23_removed_apps.ods"

# Remove unwanted applications from APT and SNAP
for app in "${unwanted_apps[@]}"; do
    # Check if the application is installed via APT
    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        run_command "sudo apt remove --purge -y $app"
        run_command "echo $app >> 15.09.23_removed_apps.ods"
    else
        echo "$app is not installed via APT."
    fi
    # Check if the application is installed via SNAP
    if snap list "$app" &>/dev/null; then
        run_command "sudo snap remove --purge $app"
        run_command "echo $app (from SNAP) >> 15.09.23_removed_apps.ods"
    else
        echo "$app is not installed via SNAP."
    fi
done

# Remove Firefox user configurations
run_command "rm -rf ~/.mozilla"

# List of desired applications to install
desired_apps=(
    code # Visual Studio Code
    python3
    brave-browser # Brave Browser
    htop
    neofetch
    notion
)

# Install desired applications
for app in "${desired_apps[@]}"; do
    # Check if the application is already installed via APT
    if ! dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        run_command "sudo apt install -y $app"
    else
        echo "$app is already installed."
    fi
done

# Update snap packages
run_command "sudo snap refresh"

# Check and fix broken package dependencies
run_command "sudo apt --fix-broken install -y"

# Check for and install firmware updates
run_command "sudo fwupdmgr refresh --force"
run_command "sudo fwupdmgr update"

# Run distribution upgrade
run_command "sudo apt dist-upgrade -y"

# Cleanup residual files
run_command "sudo apt autoremove -y && sudo apt clean"

# Output successful and failed commands
echo -e "\nSuccessful Commands:"
for cmd in "${successful_commands[@]}"; do
    echo "- $cmd"
done

echo -e "\n"

echo -e "Failed Commands:"
for cmd in "${failed_commands[@]}"; do
    echo "- $cmd"
done

echo -e "\n"

echo "Script execution completed."

# Prompt to reboot the system
read -p "Would you like to reboot the system now? (yes/no): " choice
case "$choice" in
  yes|Yes|Y|y) run_command "sudo reboot";;
  no|No|N|n) echo "Reboot aborted.";;
  *) echo "Invalid choice. Not rebooting.";;
esac
