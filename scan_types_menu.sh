#!/bin/bash

options_name=( 'TCP connect' 'TCP SYN [default]' 'TCP ACK' 'UDP [slow]' 'Dont Ping Host' 'Windows port' 'Maimon' ) 

options_cmd=(-sT -sS -sU -Pn -sA -sW -sM)

declare -A selected


scan_type(){

menu() {
    a=0
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
    ((num--)); #msg="${options[num]} was ${choices[num]:+un}checked"

# adds or removes the + from the corrisponding option
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"

done

printf "You selected "; msg="nothing, previous selections have been cleared"
for i in ${!options_cmd[@]}; do 
	[[ "${choices[i]}" ]] && selected+=" ${options_cmd[i]}" #{ printf " %s" "${options_cmd[i]}"; msg=""; }
done
echo ${selected}
export selected
}

