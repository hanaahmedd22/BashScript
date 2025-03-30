#!/usr/bin/bash

validate_input() {
    local columns_names=("$@")
    local valid=true
    local error_msg=""

    for i in "${!columns_names[@]}"; do  
        column="${columns_names[i]}"
        datatype="${datatypes[i]}"
        value="${fields[i]}"

        if [[ -z "$value" ]]; then
            valid=false
            error_msg="Error: '$column' cannot be empty."
            break
        fi
        if [[ "$value" =~ [[:space:]] ]]; then
            zenity --error --text="Error: column name cannot contain spaces."
            return 1
        fi
        
        if [[ "$datatype" == "int" && ! "$value" =~ ^[0-9]+$ ]]; then
            valid=false
            error_msg="Error: '$value' is not a valid integer for column '$column'."
            break
        elif [[ "$datatype" == "varchar" && "$value" =~ ^[0-9]+$ ]]; then
            valid=false
            error_msg="Error: '$value' is not a valid string for column '$column'."
            break
        fi

        if [[ "$column" == *"(PK)"* ]]; then
            if awk -F',' -v val="$value" '$1 == val { found=1; exit } END { exit !found }' "$data_file"; then
                valid=false
                error_msg="Error: '$column' must be unique. '$value' already exists."
                break
            fi
        fi
    done

    if ! $valid; then
        zenity --error --text="$error_msg"
        return 1
    fi
    return 0
}
