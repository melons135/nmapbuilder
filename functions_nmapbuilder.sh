#!/bin/bash

ports(){
	#this needs:
	#	-p <port ranges>
	#	--exclude-ports <port ranges>
	#	-F (fast and limited port scan; top 100 ports)
	#	-r (dont randomise ports)
	#	--top-ports <#>
	#these ranges should use standard nmap rules e.g.: -p 22,25,80 ; -p80-85,443,8080-9000 ; -p-100,60000- (up to 100 and beyond 60000) ; -p- ; -pT:<ports>,U:<ports>,P:<IP protocol>,S:<SCTP> ; -p <service name> (these work with regex so http* scans everything that starts with http)
	echo ports
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

