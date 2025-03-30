#!/usr/bin/bash
cd ../Database_Connection_Menu
db_name=$1
db_path=$2
tables=$(ls "$db_path" | grep ".meta$" | sed 's/.meta$//')

if [ -z "$tables" ]; then
    zenity --info --text="No tables found in the database path: $db_path" --width=300  
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0

else

    zenity --list --title="Available Tables" \
        --text="Tables in the database named: $db_name" \
        --column="Tables" $tables \
        --width=400 --height=300
    status=$?
    if [ "$status" -ne 0 ]; then
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 0
    fi
fi
