#!/bin/bash

declare -A options=(
[TCP connect]="-sT"
[TCP SYN (default)]="-sS"
[TCP ACK]="-sA"
[UDP (slow)]="-sU"
[Ignore Discovery (dont ping the host)]="-Pn"
[Windows port]="-sW"
[Maimon]="-sM"
)

#options=("-sT" "-sS" "-sU" "-Pn" "-sA" "-sW" "-sM")

menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    if [[ "$msg" ]]; then echo "$msg"; fi
}

prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done
echo "$msg"
