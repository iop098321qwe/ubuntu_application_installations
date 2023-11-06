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

# Dynamic filename for log file based on current date and time
current_datetime=$(date '+%d.%m.%y.%H.%M')
log_filename="${current_datetime}_script_log.ods"
log_directory="$HOME/Documents/update_script_logs"
full_log_path="$log_directory/$log_filename"

# Create directory for storing the log if it doesn't exist
[ ! -d "$log_directory" ] && mkdir -p "$log_directory"

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

# Initialize the log file
echo 'Removed Applications:' > "$full_log_path"

# Remove unwanted applications from APT and SNAP
for app in "${unwanted_apps[@]}"; do
    # Check if the application is installed via APT
    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        run_command "sudo apt remove --purge -y $app"
        echo "$app" >> "$full_log_path"
    fi
    # Check if the application is installed via SNAP
    if snap list "$app" &>/dev/null; then
        run_command "sudo snap remove --purge $app"
        echo "$app (from SNAP)" >> "$full_log_path"
    fi
done

# Remove Firefox user configurations
run_command "rm -rf ~/.mozilla"

# List of desired applications to install
desired_apps=(
    codium # Codium
    python3
    brave-browser # Brave Browser
    htop
    neofetch
    notion
    nextcloud-desktop
    virtualbox
)

# Add section for installed apps in the log
echo -e "\nInstalled Applications:" >> "$full_log_path"

# Install desired applications
for app in "${desired_apps[@]}"; do
    # Check if the application is already installed via APT
    if ! dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "ok installed"; then
        run_command "sudo apt install -y $app"
        echo "$app" >> "$full_log_path"
    fi
done

# Install VS Code

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders


# Update snap packages and log them
run_command "sudo snap refresh"

# Add section for updated apps in the log
echo -e "\nUpdated Applications:" >> "$full_log_path"
updated_apps=$(sudo apt list --upgradable 2>/dev/null | grep upgradable | awk -F/ '{print $1}')
for app in $updated_apps; do
    echo "$app" >> "$full_log_path"
done

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

echo -e "\nFailed Commands:" 
for cmd in "${failed_commands[@]}"; do
    echo "- $cmd"
done

echo -e "\nScript execution completed. Your log is stored here: $full_log_path"

# Prompt to reboot the system
read -p "Would you like to reboot the system now? (yes/no): " choice
case "$choice" in
  yes|Yes|Y|y) run_command "sudo reboot";;
  no|No|N|n) echo "Reboot aborted.";;
  *) echo "Invalid choice. Not rebooting.";;
esac
