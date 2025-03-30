#!/usr/bin/bash
DBName=$1  
DBPath=$2

tbls=$(ls "$DBPath" | sed -n 's/.meta$//gp')
if [ -z "$tbls" ]; then
    zenity --info --text="No tables found in the database $DBName to insert into."
    ./main.sh "$DBName"
    exit 0
fi

TableName=$(zenity --list --title="Select Table to Insert Data" --column="Tables" $tbls --height=400 --width=400)
if [[ $? -ne 0 ]] || [[ -z "$TableName" ]]; then
    zenity --error --text="No table selected. Operation canceled :]"
    ./main.sh "$DBName"
    exit 0
fi

meta_file="$DBPath/$TableName.meta"
data_file="$DBPath/$TableName.data"
columns_names=($(awk 'NR==1' "$meta_file"))
datatypes=($(awk 'NR==2' "$meta_file"))

source ../helper/validate_input.sh

cmd="zenity --forms --title='Insert Data' --text='Insert into \"$TableName\"' --separator=','"
for col in "${columns_names[@]}"; do
    cmd+=" --add-entry=\"$col\""
done
while true; do
    values=$(eval "$cmd")
    if [[ $? -ne 0 ]]; then
        zenity --info --text="Operation cancelled by the user."
        ./main.sh "$DBName"
        exit 0
    fi

    IFS=',' read -ra fields <<< "$values"
    if ! validate_input "${columns_names[@]}"; then
        continue
    fi

    echo "$values" >> "$data_file"
    zenity --info --text="Data inserted successfully into '$TableName'!"
    break
done
