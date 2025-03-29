#!/usr/bin/bash
cd ../Database_Connection_Menu
db_name=$1
db_path=$2
tables=$(ls "$db_path" | grep ".meta$" | sed 's/.meta$//')

if [ -z "$tables" ]; then
    zenity --info --text="No tables found in the database path: $db_path" --width=300
    exit 0
fi

zenity --list --title="Available Tables" \
       --text="Tables in the database named: $db_name" \
       --column="Tables" $tables \
       --width=400 --height=300