#!/bin/bash
PS3=$'\nSelect the functionality you would like: '

# Array for storing the user's choices
choices=()

select choice in Default XML Searchable Finished
do
  # Stop choosing on this option
  [[ $choice = Finished ]] && break
  # Append the choice to the array
  choices+=( "$choice" )
  echo "$choice, got it. Any others?"
done

# Write out each choice
printf "You selected the following: "
for choice in "${choices[@]}"
do
  printf "%s " "$choice"
done
printf '\n'

exit 0
