#!/bin/bash
source ../helper/validate_db_name.sh
while true; do
    db_name=$(zenity --entry --text="Please Enter a Database name:" --height=50 --width=300)
    [[ $? -ne 0 ]] && zenity --info --text="Operation cancelled by the user." && ./main.sh && exit 1
    validate_db_name "$db_name" && break
done

if mkdir "../Databases/$db_name"; then
    echo "Creating Database '$db_name'..."
    zenity --info --text="Database '$db_name' created successfully."
else
    zenity --error --text="Error: Failed to create database."
    exit 1
fi