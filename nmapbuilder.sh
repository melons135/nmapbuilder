#!/bin/bash

#source /opt/myscripts
source ~/Documents/ScriptTemp/functions_nmapbuilder.sh

echo -e "Hello and welcome to nmap builder for all your simplified scanning needs. Please define target:\n (targets can can be a list of IPs, a range of IPs, a URL or a file with a list of IPs inside [if using a file please use the format '-iL <list-of-ips.txt>'].)"

read TARGET

echo "Now that we have out target what kind of scan would you like to perform"

while true; do 
	select SCAN in Quick-Scan Build-a-Scan Change-Target Exit; do 
		case $SCAN in
			Quick-Scan)
				PORTS=$(nmap -p- -T4 $TARGET 1>/dev/null | grep -oP '^[0-9]{1,5}' | sed ':a;N;$!ba;s/\n/,/g');
				nmap -A -p${PORTS} $TARGET
				;;
			Build-a-Scan)
			echo "Configure Scan:"
			select OPTION in Ports Scan-Types Service/OS-Detection Host-Discovery Speed Firewall Misc Scripts Exit;	do 
				case $OPTION in
					Ports)
						ports
						PORTS=$?
						;;
					Scan-Types)
						scan_options
						SCAN=$?
						;;
					Services/OS-Detection)
						echo before
						SOS_detection
						echo after
						SOS=$?
						;;
					Host-Discovery)
						host_detection	
						HOST=$?
						;;
					Speed)
						speed
						SPEED=$?
						;;
					Firewall)
						firewall
						FIRE=$?
						;;
					Misc)
						misc
						MISC=$?
						#echo "Misc. settings are currently "$MISC
						;;
					Scripts)
						scripts
						SCRIPT=$?
						;;
					Exit)
						out
						#echo Exiting
						#break
						;;
				esac
				done
				;;
			Change-Target)
				echo "Please input target(s)"
				read TARGET
				;;
			Exit)
				echo "stopping script"
				break
				;;
		esac
	done
done
nmap 
