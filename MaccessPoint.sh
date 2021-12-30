#!/bin/zsh

# Begin IF statement to check if user id(/usr/bin/id -u) is not equal to root (0)
# If user is not root, display a message and exit
# If user is root, do the following script

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "You must be root to run this"
    exit
else

# Display a message asking if dnsmasq should be installed
# read the input and save it to the variable answer
# IF statement checks if answer is y
# If it is then:
# Display a message saying saying what's happening
# Begin a for loop, for var i in range 1-40
# Print a * each loop on the same line (-n)
# Wait 0.01 seconds between each iteration
# End For loop
# Installs dnsmasq
# If answer is not y then
# End IF statement
echo "$prompt Would you like to install dnsmasq y/n"
read answer
if [[ $answer = "y" ]]; then
	echo "Installing DNSMASQ for DNS and DHCP settings"
	for i in {1..40}; do
		echo -n "*"
		sleep 0.01
	done
	echo " "
	apt-get install dnsmasq -y
	echo -e \\n"dnsmasq installed"
else
fi

echo "$prompt Would you like to install hostapd y/n"
read answer
if [[ $answer = "y" ]]; then
	echo -e \\n"Installing HOSTAPD to enable Access Point"
	for i in {1..40}; do
		echo -n "*"
		sleep 0.01
	done
	echo " "
	apt-get install hostapd -y
	echo -e \\n"hostapd installed"
else
fi

# Check if dnsmasq.conf already exists
# Create a backup copy of the old file
# If it doesn't exist
# Create a new dnsmasq.conf file
if [[ -a /etc/dnsmasq.conf ]]; then
	if [[ -a /etc/dnsmasq.conf.bak ]]; then
		echo "Existing dnsmasq.conf.bak file found"
		echo "$prompt Would you like to skip creating a backup? y/n"
		read answer
		if [[ $answer = "n" ]]; then
			echo "Overwriting dnsmasq.conf.bak"
			cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
		else
			echo "Skipping backup"
		fi
	else
		echo "Existing dnsmasq.conf file found, copying to dnsmasq.conf.bak"
		cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
	fi
else
	echo "Creating /etc/dnsmasq.conf"
	touch dnsmasq.conf
fi

if [[ -a /etc/hostapd/hostapd.conf ]]; then
	if [[ -a /etc/hostapd/hostapd.conf.bak ]]; then
		echo "Existing hostapd.conf.bak file found"
		echo "$prompt Would you like to skip creating a backup?"
		read answer
		if [[ $answer = "n" ]]; then
			echo "Overwriting hostapd.conf.bak"
			cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
		else
			echo "Skipping backup"
		fi
	else
		echo "Existing hostapd.conf file found, copying to hostapd.conf.bak"
		cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
	fi
else
	echo "creating /etc/hostapd/hostapd.conf"
	touch /etc/hostapd/hostapd.conf
fi
echo "Setting eth0 up if it exists"
ifconfig eth0 up
echo "Setting wlan0 up if it exists"
ifconfig wlan0 up
echo "Setting wlan1 up if it exists"
ifconfig wlan1 up

echo -e \\n"Network Adapters Found:"
ifconfig -s

echo -e \\n"$prompt Enter the name of the adapter you wish to use as the access point"
read apAdapter

echo "interface=$apAdapter" > /etc/dnsmasq.conf
echo "dhcp-range=10.0.0.10,10.0.0.250,12h" >> /etc/dnsmasq.conf
echo "dhcp-option=3,10.0.0.1" >> /etc/dnsmasq.conf
echo "dhcp-option=6,10.0.0.1" >> /etc/dnsmasq.conf
echo "server=8.8.8.8" >> /etc/dnsmasq.conf
echo "log-queries" >> /etc/dnsmasq.conf
echo "log-dhcp" >> /etc/dnsmasq.conf

echo "Creating /etc/fakehosts.conf"
touch /etc/fakehosts.conf
echo "10.0.0.9 neohub.co.uk" > /etc/fakehosts.conf

echo "Configuring /etc/hostapd/hostapd.conf"
echo "interface=$apAdapter" > /etc/hostapd/hostapd.conf


echo "$prompt Enter your chosen SSID name"
read usrSSID
echo "ssid=$usrSSID" >> /etc/hostapd/hostapd.conf
echo "$prompt Enter the channel you'd like to use"
read usrChannel
echo "channel=$usrChannel" >> /etc/hostapd/hostapd.conf
echo "ap_max_inactivity=1800" >> /etc/hostapd/hostapd.conf
echo "broadcast_deauth=1" >> /etc/hostapd/hostapd.conf
echo "eap_server=0" >> /etc/hostapd/hostapd.conf

echo "DEAMON_CONF=" >> /etc/hostapd
echo "Dnsmasq.conf settings: "
cat /etc/dnsmasq.conf
echo "Hostapd.conf settings: "
cat /etc/hostapd/hostapd.conf

echo "Bringing up chosen adapter and setting it to 10.0.0.1/24"
ifconfig $apAdapter 10.0.0.1/24 up
echo "Unmasking hostapd"
systemctl unmask hostapd
echo "Starting hostapd service"
service hostapd start
echo "Configuration files setup complete"
echo -e \\n"Start dnsmasq by running:"
echo "sudo dnsmasq -C /etc/dnsmasq.conf -H /etc/fakehosts.conf -d"
echo -e \\n"Then start hostapd by running in a new window;"
echo "sudo hostapd /etc/hostapd/hostapd.conf"
echo -e \\n"Once both are running, setup basic NAT by entering:"
echo "sudo sysctl -w net.ipv4.ip_forward=1"
echo "sudo iptables -P FORWARD ACCEPT"
echo "sudo iptables --table nat -A POSTROUTING -o wlan0 -j MASQUERADE"
echo "Substitute wlan0 for the network adapter connected to the real wifi"
echo -e \\n"Once completed you should be able to connect to the Access Point and the Internet"
# End Start IF statement
fi
