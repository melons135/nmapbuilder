#!/bin/bash

ports(){
	port_options=(Port Range, Exclude Ports, 'Top # Ports', Reset Selected)
	declare -a ports_arr
	select OPTION in port_options; do
		case OPTION in
			Port Range)
				echo -e "Please input the range of ports you would like to scan.\n
				This should be a comma seperated list and you can select a range with #1-#2, you can also input a sevice name and all ports with associated name will be scanned Some examples are:\n
				22,25,80 ; 80-85,443,8080-9000 ; -100,60000- (up to 100 and beyond 60000) ; - (all ports) ; T:<TCP ports to scan>,U:<UDP ports to scan>; <service name>"
				read -p 'list everything you would like to scan' port_no
				ports_arr=+"-p$ports_no"
				;;
			Exclude Ports)
				echo Input a list of the ports to exclude
				read -p 'List ports to exclude' exclude
				ports_arr=+$exclude
				;;
			'Top # Ports')
				echo What number of the top ports would you like to scan, using the top 100 is the same as -F
				read -p 'Number:' top
				ports_arr=+$top
				;;
			Reset Selected)
				ports_arr=()
				;;
			Exit)
				echo Ending Port Selection
				export $ports_arr
				break
		esac
	done
}

scan_options(){

	msg=""
	options_name=( 'TCP connect' 'TCP SYN [default]' 'TCP ACK' 'UDP [slow]' 'Dont Ping Host' 'Windows port' 'Maimon' ) 
	
	options_cmd=(-sT -sS -sU -Pn -sA -sW -sM)
	
	declare -A selected
	
	menu() {
	    echo "Avaliable options:"
	    for i in ${!options_name[@]}; do 					#lists option
		    printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options_name[i]}" #format specifies (number+string then string and new line)
	    done
	    if [[ "$msg" ]]; then echo "$msg"; fi				#if msg variable exits then say it 
	}
	
	#prompt
	prompt="Check an option (again to uncheck, ENTER when done): "
	
	#display menu and take input and display prompt and set the input as variable 'num', when num is input execute body
	while menu && read -rp "$prompt" num && [[ "$num" ]]; do
	
	#check that 'num' is a digit and lies in the range of options
	    [[ "$num" != *[![:digit:]]* ]] &&
	    (( num > 0 && num <= ${#options_name[@]} )) ||
	
	#if doesnt meet the above check, display below message and loop again
	    { msg="Invalid option: $num"; continue; }
	
	# take one away from the number (compensating from the +1 above) then display the option that was checked
	    ((num--)); msg=""		###msg="${options[num]} was ${choices[num]:+un}checked"
	
	# adds or removes the + from the corrisponding option
	    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
	
	done
	
	
	#create an array of selected values
	for i in ${!options_cmd[@]}; do 
		[[ "${choices[i]}" ]] && selected+=" ${options_cmd[i]}" 
	done
	#print results depending on what has been selected
	echo "You selected: $(if [[ "${selected[@]}" ]]; then echo "${selected}"; else echo Nothing.; fi)"
	#export so the 
	export selected
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SOS_detection(){
	#if All is selected then only use that
	#if using version get user to specify the the intesity "-sV --version-intensity <#>"
	#OS detection has options for more aggresive (-O --osscan-guess) and less aggresive (-O --osscan-limit), might include them, might not
	choices=();
	echo -e "~All - displays OS, Version does script scanning and traceroute of target\n\
	~Version - probes open ports for the software of services running on the port, this has intensity options (the higher the longer the scan will take)\n\
	~OS Detection - collects TCP/IP fingerprints that are then compared to a database to return Vendor name, underlying OS, OS generation and device type (somewhat of a guessing game)" 
	select SOS in All Version OS-Detection; do
		case SOS in
			All)
				if [[ ! " ${choices[@]} " =~ " -A " ]]; then 	#check the option isnt in the array already
				choices="-A"					#if all is selected only use -A
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
}

speed(){
	echo "The speeds names are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5). The first two are for IDS evasion. Polite mode slows down the scan to use less bandwidth and target machine resources. Normal mode is the default. Aggressive and insane mode are for fast and super-fast internet connection, they can be used on slower internet connection but accuracy when subsiquently be sacrificed for speed."
	num=null

	#display menu and take input and display prompt and set the input as variable 'num', when num is input execute body
	while ["$num" = null]; do
		read -rp 'Please enter a number between 1 and 5:' num

		#check that 'num' is a digit and lies in the range of options
		if [ "$num" != *[![:digit:]]* && num < 0 && num > 5 ] then
			#if doesnt meet the above check, display below message and loop again
			echo "Invalid option: $num"; continue
		else
			return $num
			break
		fi
	done
}

firewall(){
	echo firewall feaure coming soon
}

scripts(){
	echo -e 'A full list of scripts can be fund here: https://nmap.org/book/nse-scripts-list.html . Scripts are then added with --<name of script> into the box below:\n Please list all the scripts you wwish to use as this is reset each time.'
	read -rp "Space seperate list of scripts (dont forget --):" scriptlist
	export scriptlist
}

out(){
	echo "Going Back"
	break
}

