#!/bin/bash

ports(){
	echo ports
}

scan_options(){
	echo scan
}

SOS_detection(){
	choices=();
	while true; do
	echo -e "~All - displays OS, Version does script scanning and traceroute of target\n~Version - probes open ports for the software of services running on the port, this has intensity options (the higher the longer the scan will take)\n~OS Detection - collects TCP/IP fingerprints that are then compared to a database to return Vendor name, underlying OS, OS generation and device type (somewhat of a guessing game)" 
	select SOS in All Version OS-Detection; do
		case SOS in
			All)
				if [[ ! " ${choices[@]} " =~ " -A " ]]; then 	#check the option isnt in the array already
				choices+=-A					#add it too the array
				else
				echo "This option is already selected"		#let them know it wasnt added but its already there
				fi	
				;;
			Version)
				
				;;
			OS-Detection)

				;;
			*) echo "Invalid option, Try again"; continue;;
		esac
	done
done
}

host_detection(){
	echo host
}

speed(){
	echo speed
}

firewall(){
	echo firewall
}

misc(){
	echo misc
}

scripts(){
	echo scripts 
}

out(){
	echo "Going Back"
	break
}

