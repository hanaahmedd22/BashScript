#!/bin/bash
found=false
databases_list=()

for db in "../Databases"/*/; do 
    [[ -d "$db" ]] || continue 
    db_name=$(basename "$db")  
    databases_list+=("$db_name")
    found=true
done

if ! $found; then
    zenity --error --text="No databases found."
    ./main.sh
    exit 1
else
    # Show the list of databases using zenity
    zenity --list --title="Available Databases" --column="Databases" "${databases_list[@]}"
fi
