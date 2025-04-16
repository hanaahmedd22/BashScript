#!/usr/bin/bash

db_list=$(ls ../Databases 2>/dev/null)

if [[ -z "$db_list" ]]; then
    zenity --error --text="No databases found."
    echo "No databases found."
    ./main.sh
    exit 1
fi

db_name=$(zenity --list --title="Select Database" --column="Databases" $db_list --height=400 --width=400)

if [[ $? -ne 0 ]]; then
    zenity --error --text="operation cancelled."
    echo "Operation cancelled."
    ./main.sh
    exit 1   
fi

if [[ -z "$db_name" ]]; then
    zenity --error --text="Nothing selected."
    echo "Nothing selected."
    ./main.sh
    exit 1   
fi

zenity --info --text="Connected to '$db_name' successfully."

../Database_Connection_Menu/main.sh $db_name

