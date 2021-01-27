#!/bin/bash

#source /opt/myscripts
source ./functions_nmapbuilder.sh

echo -e "Hello and welcome to nmap builder for all your simplified scanning needs. Please define target:\n (targets can can be a comma seperated list of IPs {<IP1>,<IP2>,...}, a range of IPs {192.168.0.1-20}, a subnet {192.168.0.0/24} or a URL or a file with a list of IPs inside [if using a file please use the format '-iL <list-of-ips.txt>'].)"

read TARGET

echo "Now that we have out target what kind of scan would you like to perform"

while true; do 
	select SCAN in Quick-Scan All-Info-Scan Scan-and-Search Check-DDOS-Protection Build-a-Scan Change-Target Exit; do 
		case $SCAN in
			Quick-Scan)
				echo quick scan
				;;
			All-Info-Scan)
				PORTS=$(nmap -p- -T4 $TARGET 1>/dev/null | grep -oP '^[0-9]{1,5}' | sed ':a;N;$!ba;s/\n/,/g');
				nmap -A -p${PORTS} -oN "nmap $TARGET" $TARGET
				;;
			Scan-and-Search)
				sudo nmap -T4 -sS -sU -sV -oX nmap.xml $TARGET 1>/dev/null; searchsploit -v --nmap nmap.xml --exclude="/dos/" | tee "exploit_list_$TARGET.txt"; rm nmap.xml
				;;
			Check-DDOS-Protection)
				sudo nmap –sU –A –PN –n –pU:19,53,123,161 –script=ntp-monlist,dns-recursion,snmp-sysdescr $TARGET
				;;
			Build-a-Scan)
				echo "Configure Scan:"
				select OPTION in Ports Scan-Options Service/OS-Detection Speed Firewall Misc Scripts Execute Back;	do 
					case $OPTION in
						Ports)
							ports
							PORTS=$?
							;;
						Scan-Options)
							scan_options
							SCAN=$?
							;;
						Services/OS-Detection)
							SOS_detection
							SOS=$?
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
							;;
						Scripts)
							scripts
							SCRIPT=$?
							;;
						Execute)
							echo "Executing command: nmap $PORTS $SCAN $SOS $FIRE $MISC $SCRIPT $TARGET"
							nmap $PORTS $SCAN $SOS $FIRE $MISC $SCRIPT $TARGET
							exit
							;;
						Back)
							echo Exiting
							break
							;;
						esac
					done
				;;
			Change-Target)
				echo "Please input target(s):"
				read TARGET
				;;
			Exit)
				echo Exiting...
				exit	
				;;
		esac
	done
	done
nmap 
