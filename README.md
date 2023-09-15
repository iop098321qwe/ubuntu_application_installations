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

* Run using `chmod +x uric.sh && sudo ./uric.sh`