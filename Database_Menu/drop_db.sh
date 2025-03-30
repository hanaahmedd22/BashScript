#!/usr/bin/bash

db_list=$(ls ../Databases 2>/dev/null)

if [[ -z "$db_list" ]]; then
    zenity --error --text="No databases found."
    ./main.sh
    exit 1
fi

db_name=$(zenity --list --title="Select Database" --column="Databases" $db_list --height=400 --width=400)
status=$?
if [ "$status" -ne 0 ] || [ -z "$db_name" ]; then
    ./main.sh
    exit 0  
fi
echo "Deleting database '$db_name'..."
rm -rf "../Databases/$db_name"

zenity --info --text="Deleted  '$db_name' successfully."
