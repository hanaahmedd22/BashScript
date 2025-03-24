#!/usr/bin/bash

db_list=$(ls ../Databases 2>/dev/null)

if [[ -z "$db_list" ]]; then
    zenity --error --text="No databases found."
    ./main.sh
    exit 1
fi

db_name=$(zenity --list --title="Select Database" --column="Databases" $db_list --height=400 --width=400)

if [[ -z "$db_name" ]]; then
    zenity --error --text="Nothing selected."
    ./main.sh
    exit 1   
fi

zenity --info --text="Connected to '$db_name' successfully."

bash ../Database_Connection_Menu/main.sh $db_name

