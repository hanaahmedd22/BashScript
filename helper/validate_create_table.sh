#!/usr/bin/bash

CheckIfValidOfTableName() {
    input=$1
    db_path=$2

    if [ -f "$db_path/$table_name*" ]; then
        echo "Table already exists"
        zenity --error --text="Table '$table_name' already exists."
        return 1 
    elif [[ $input =~ ^[a-zA-Z]+[0-9]*$ ]]; then
        input=$(echo "$input" | tr ' ' '_')
	    return 0
    elif [ -z $input ];then
	    echo "your input is empty"
        zenity --error --text="Table name cannot be empty."
	    return 1
    else
        echo "Invalid input try again"
        zenity --error --text="Invalid table name. Please use only letters and numbers, starting with a letter."
	    return 1
        
    fi
}

CheckIfValidOfName() {
    input=$1
    if [[ $input =~ ^[a-zA-Z]+[0-9]*$ ]]; then
        input=$(echo "$input" | tr ' ' '_')
	    return 0
    elif [ -z $input ];then
	echo "your input is empty"
	    return 1
    else
        echo "Invalid input try again"
	    return 1
        
    fi
}