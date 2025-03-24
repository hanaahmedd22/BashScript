#!/bin/bash
found=false
echo "Available Databases:"
for db in "../Databases"/*/; do 
    [[ -d "$db" ]] || continue 
    db_name=$(basename "$db")  
    echo "- $db_name"
    found=true
done
! $found && echo "No databases found" && exit 1
