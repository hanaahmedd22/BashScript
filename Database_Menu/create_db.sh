#!/bin/bash
if [[ -z "$1" ]]; then
    read -p "Enter database name: " db_name
else
    db_name="$1"
fi
source ./helper/validate_db_name.sh 
validate_db_name "$db_name" || exit 1
if mkdir "./$db_name"; then
    echo "Database '$db_name' created successfully."
else
    echo "Error: Failed to create database."
    exit 1
fi
