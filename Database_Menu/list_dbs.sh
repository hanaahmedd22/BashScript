#!/bin/bash
found=false
echo "Available Databases:"
for db in */; do
    [[ -d "$db" ]] || continue
    echo "- ${db%/}"
    found=true
done
! $found && echo "No databases found" && exit 1
