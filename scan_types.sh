#!/bin/bash

declare -A options
options=(
["TCP connect"]="-sT"
["TCP SYN (default)"]="-sS"
["TCP ACK"]="-sA"
["UDP (slow)"]="-sU"
["Ignore Discovery (dont ping the host)"]="-Pn"
["Windows port"]="-sW"
["Maimon"]="-sM"
)

#options=("-sT" "-sS" "-sU" "-Pn" "-sA" "-sW" "-sM")

menu() {
    echo "Avaliable options:"
    for i in ${#options[@]}; do 					#lists options
	    printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}" #format specifies (number+string then string and new line)
    done
    if [[ "$msg" ]]; then echo "$msg"; fi				#if msg variable exits then say it 
}

prompt="Check an option (again to uncheck, ENTER when done): "		#display prompt
while menu && read -rp "$prompt" num && [[ "$num" ]]; do		#displays menu and prompt then read inputs ro num
    [[ "$num" != *[![:digit:]]* ]] &&					#check that its only a digit
    (( num > 0 && num <= ${#options[@]} )) ||				#check num is in range
    { msg="Invalid option: $num"; continue; }				#output if invalid
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"	#user feedback (changing check)
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"	#this checks or unchecks the function (still unsure)	
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done
echo "$msg"

##if this is too hard maybe use whiptail, its an already configured menu
