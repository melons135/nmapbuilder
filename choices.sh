#!/bin/bash
PS3=$'\nSelect the functionality you would like: '

# Array for storing the user's choices
declare -a choices=()

select choice in Default XML Searchable Finished
do
	echo $choices
	case $choice in
		Default)
			if [[ "$choices[@]" == "-oN" ]] 
			then
				echo "This option is already selected would you like to removed it? (y/n)"
				read answer
				if [[$answer == "y"]] 
				then
					unset -v $choices["-oN"]
					echo "Default $choice has been removed"
				else
					echo "nothing has been changed"
				fi
			else
				$choices+='-oN'
			fi
			;;
		XML)
			if [[ "$choices[@]" == "-oX" ]] 
			then
				echo "This option is already selected would you like to removed it? (y/n)"
				read answer
				if [[$answer == "y"]] 
				then
					unset -v $choices["-oX"]
					echo "Default $choice has been removed"
					break
				else
					echo "nothing has been changed"
					break
				fi
			else
				choices+=("-oN")
				break
			fi
			;;
		Searchable)
			if [[ "$choices[@]" == "-oG" ]] 
			then
				echo "This option is already selected would you like to removed it? (y/n)"
				read answer
				if [[$answer == "y"]] 
				then
					unset -v $choices["-oG"]
					echo "Default $choice has been removed"
					break
				else
					echo "nothing has been changed"
					break
				fi
			else
				choices+=("-oN")
				break
			fi
			;;	
		Finished)
			break 2
			;;
	esac
done





#
#			choices+=
#  # Stop choosing on this option
#  [[ $choice = Finished ]] && break
#  # Append the choice to the array
#  choices+=( "$choice" )
#  echo "$choice, got it. Any others?"
#done
#
## Write out each choice
#printf "You selected the following: "
#for choice in "${choices[@]}"
#do
#  printf "%s " "$choice"
#done
#printf "\n"
#
#exit 0
