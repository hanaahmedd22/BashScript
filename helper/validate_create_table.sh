#!/usr/bin/bash

CheckIfValidOfTableName() {
    input=$1
    db_path=$2

    if [ -z "$input" ]; then
        echo "Your input is empty"
        zenity --error --text="Table name cannot be empty."
        return 1
    fi

    if ! [[ "$input" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid input, try again"
        zenity --error --text="Invalid table name. Please use only letters, numbers, and underscores, starting with a letter.Without spaces."
        return 1
    fi

    
    if ls "$db_path/$input"* >/dev/null 2>&1; then
        echo "Table already exists"
        zenity --error --text="Table '$input' already exists."
        return 1
    fi
    return 0
}


CheckIfValidOfName() {
    input=$1
    if [[ $input =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
	    return 0
    elif [ -z $input ];then
	echo "your input is empty"
	    return 1
    else
        echo "Invalid column name. Please use only letters and numbers, starting with a letter.Without spaces"
	    return 1
    fi
}