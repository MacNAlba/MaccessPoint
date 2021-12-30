# MaccessPoint

ABOUT

This is a Linux based WiFi access point for use with two Network Interface Cards.
It is intended to be a "one-click" installation and execution script to make the
process of setting up an access point as painless as possible.

Currently it is written using Zsh shell and uses DHCPD and HOSTAPD but there are
plans to create a python version and bash version that can run on other linux distros.

BUILT WITH

Zsh Linux

GETTING STARTED

To execute the script open a terminal, navigate to the folder containing the script
and make the file executable with:

chmod +x MaccessPoint.sh

Then run the file with:

 ./MaccessPoint.sh

The script will then run and give prompts to install DHCPD and HOSTAPD, enter y or n
to make choices.

Once installed the script will begin configuring the files necessary to run the access
point. First the script will check for pre-existing configuration files and if found
offer a prompt to skip the backup. If y is chosen to skip the backup, any pre-existing
files will be overwritten. If n is chosen, the configuration files will be backed up
by appending .bak to the end of the file name, after the file extension, in the same
folder where the configuration files were found.

If the program is run again and backups are created again, the old backups will be
overwritten with the previously created configuration file. This is so that the program
doesn't create whole folders full of backup configuration files.

If you have custom written config files, it is recommended to change the name to
something completely different so that they are protected from this script's actions.

During the process of writing the configuration files, the Network Interface Cards will
be scanned and the results printed to the terminal, the user will then be asked which 
device they would like to use for the access point, this should be the device that is NOT
connected to the internet and the one which will be used for devices to connect TO.

The user will then be asked for an Access Point name, this is how your Access Point will
appear in WiFi scans, there is no default option for this, you must provide a name.

Next the user will be prompted for a Channel, it is adviseable to scan nearby networks to 
see what the most commonly used channel is for the closest WiFi signals. It is adviseable
to use a number that is 2 channels apart from neighbouring signals. For example if a nearby
signal is using channel 5 and another is using channel 1, use channel 3 since channels 2 and
4 are unused and can act as a buffer zone to prevent signal overlap that will disrupt the
access point.

Once these settings have been configured, the access point will have the minimal configuration
needed to run an access point. A few instructions will then be displayed to the screen, copy and
paste these commands into separate terminal windows and run them at the same time to initialise
the access point.


