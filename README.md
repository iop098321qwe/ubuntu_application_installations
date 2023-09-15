# Ubuntu Application Installations
## This will be a script to run at the beginning of a fresh Ubuntu installation to set up and remove applications as wished.

This should update and upgrade the system, remove unwanted applications, then install a list of wanted applications, then restart the system.

### Update the system

* This script will update Ubuntu to the latest version, and update all currently installed applications.
* The script will also check for installed applications that we no longer wish to be used on the computer.
* It will then remove those applications and install a list of applications as specified.
* It will then run `sudo apt update && sudo apt upgrade -y` again.
* Then it will open a terminal with a 120 second timer countdown to reboot
* The script will then self-destruct and remove itself from the computer.
* The computer will reboot and your system should be ready to use.

## Run 

* Run prior to using: `chmod +x uric.sh` in the directory where the script is stored.
* Run using: `sudo ./uric.sh` in the directory where the script is stored.

#### Refer to make executable everywhere:

* https://www.maketecheasier.com/make-scripts-executable-everywhere-linux/

#### To install KDE-plasma:

* https://tecadmin.net/how-to-install-kde-desktop-on-ubuntu/

#### Automatically install browser extensions for Brave and copy preferences:

* [Location](https://www.reddit.com/r/brave_browser/comments/hetngh/where_does_brave_store_extensions_from_the_chrome/)
* [Script](https://www.reddit.com/r/brave_browser/comments/hetngh/where_does_brave_store_extensions_from_the_chrome/)
* Path for Brave Browser preferences: `/home/dallas/.config/BraveSoftware/Brave-Browser/Default/Preferences`
* Upload preferences into Brave Browser folder

#### Create the directory 'github_repositories' under /Documents:

* [Instructions](https://linuxhandbook.com/make-directory-only-if-doesnt-exist/)
* Add 'open_work_tabs', 'terminal_documentation', and 'custom_bash_commands' repos in 'github_repositories' directory