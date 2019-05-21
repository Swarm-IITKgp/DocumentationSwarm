# Raspberry Pi Headless Setup

## Flashing

1. Download a raspbian image. These are some sources for Raspbian images:  
	a. [Raspbian Stretch (Original)](https://www.raspberrypi.org/downloads/raspbian/)  
	b. [Raspbian with preinstalled ROS Kinetic](http://www.robotis.com/service/download.php?no=1738) (Recommended)  		
2. Download Etcher from [here](https://www.balena.io/etcher/)  
3. Burn .img Raspbian to SD card using Etcher
4. Go to the "boot" partition (1st partition, the other is "rootfs") and create an empty file "ssh" without any extension. This will necessary to start allowing ssh connections as soon as RasPi boots.  
        `cd /boot`  
        `touch ssh`
5. Create a file _"wpa_supplicant.conf"_, which will contain Wireless Network login info. Connecting RasPi to a wireless network on boot is must to SSH into it wirelessly. The file will contain the following lines. It is **very important** to stick to this format including case, spaces and indentations as it is a part of the syntax of conf file.  
```
country=IN
update_config=1
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
 	scan_ssid=1
 	ssid="SSID" # Wireless SSID
 	psk="password" #Password
}
```

6. Save the file and unmount the SD Card. Mount it on RasPi and power it up. The filesystem of RasPi automattically expands to occupy the whole SD card on first boot.

## First Login  
7. Connect PC/Linux to the same network to which RasPi has been configured to connect to, in its boot.
8. Use nmap with grep in terminal to identify RasPi devices in the local network. RasPi devices have MAC Address prefix _"B8:27:EB"_. This will not work without "sudo". Find local network _NetMask_ of the wireless network. Here the netmask is **24 bits** long. Run the following:  
	`sudo nmap -sn 192.168.1.0/24 | grep "B8:27:EB"`  
You may also search for devices with open SSH port(22):  
	`sudo nmap -sS -p 22 192.168.1.0/24`	
9. Get the IP Address of the RasPi and SSH into it:(default user name is pi)  
	`ssh pi@192.168.1.68`
10. On prompt enter password _"raspberry"_.
_**Refer end of document for SSH through GPIO Pins.**_

## Set Proxy and Modify Rights  

11. Run the Following lines to change Proxy system-wide. **Don't miss even a single quote**  
```bash
sudo sh -c 'echo export http_proxy="http://172.16.2.30:8080" >> /etc/environment'  
sudo sh -c 'echo export https_proxy="http://172.16.2.30:8080" >> /etc/environment'  
sudo sh -c 'echo export no_proxy="127.0.0.1, localhost, 10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12" >> /etc/environment'  
```  

12. Now open "sudoer" file (using sudo visudo)  

	`sudo visudo`  

13. Add the below line to it and save while exiting.  

	`Defaults env_keep+="http_proxy https_proxy no_proxy"`  

## Change Password  

14. Run the below command and follow the prompts to change the password of the "pi" user.  
	
	`passwd`

## Reboot  

15. Reboot RasPi to apply all changes applied so far. The control moves out of SSHed system into the local terminal.  
	
	`sudo reboot now`

## SSH Keys(Optional)  

16. As the control moves to local terminal, we crate keys for passwordless login.  
	_Give new name/location to the new keys to prevent overwriting of existing keys._  
	Run the following lines on the LOCAL system.  
```
ssh-keygen
ssh-copy-id pi@<IP-ADDRESS> -p <PortNumber> 
```  

17. Follow the prompts from ssh-keygen to complete Key Generation. Add passphrase if needed. The last line copies the public SSH key of our remote system to the list of Authorised keys in Raspi.   

## Install Updates  

18. Update packages  
	`sudo apt-get install update`  
19. Install upgrades  
	`sudo apt-get install upgrade`  
	`sudo rpi-update`  

## Update Time  

20. "raspi-config" offers a lot of options to configure. One of them is Time-Zone, under localization options.  
        `sudo raspi-config`  
21. Install ntpdate  
	`sudo apt-get install ntpdate`  
22. Update time from local proxy server (IITKGP)  
	`sudo ntpdate 10.3.100.225`  

**_End of Basic Changes needed for proper operation of Raspi._**  

## Other Changes  

23. Set language  
```
export LANGUAGE="en_US.UTF-8"
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
```
24. Install apt-fast  
```	
sudo /bin/bash -c "$(curl -sL https://git.io/vokNn)"  
mkdir repos && cd repos && git clone https://github.com/ilikenwf/apt-fast.git && cd apt-fast
sudo cp completions/bash/apt-fast /etc/bash_completion.d/ && sudo chown root:root /etc/bash_completion.d/apt-fast 
source /etc/bash_completion
```
25. Remove unnecessary softwares  
	`sudo apt-get purge wolfram* libreoffice*`  
26. More Packages:  
	`PACKAGES="screen python-picamera python-pip software-properties-common dnsmasq hostapd macchanger ethtool python3-pip ffmpeg vlc"`  
```
sudo apt-fast install $PACKAGES -y
pip install twython
pip3 install twython
```
27. Distro upgrade:  
	`sudo apt-fast dist-upgrade -y`  

## Other Info  

#### Change SSH Port (Not recommended)  

1. Run nano and change the SSH Port to any value of choice above 1024 but less than 65535  
Change the line "#Port 22" to "#Port <NewPort>", and save while exiting.  
        `nano /etc/ssh/sshd_config`  
From now on, to SSH into the device, use this command: (Default port is 22)  
	`ssh pi@<IPAddress> -p <PortNumber>`

#### Serial Port SSH  

1. Apart for wlan and ethernet, RasPi can also be SSHed into through PC USB, using USB to UART converter to connect to TX, RX and GND pins of RasPi. First enable Serial access from raspi-config  
	`sudo raspi-config #--> Interfaces #--> Serial--> Enable`  
2. Use "screen" to access serial port of RasPi:  
	`screen /dev/<ttyUSBX> 115200`  
Where ttyUSBX eg. _ttyUSB0, ttyUSB1_ can be found from:  
	`ls /dev | grep "ttyUSB"`
