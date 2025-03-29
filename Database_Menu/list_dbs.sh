#!/bin/bash
DBS=$(ls ../Databases)

[[ -z "$DBS" ]] && zenity --error --text="No databases found" && ./main.sh && exit 1   

zenity --list --title="Available Databases" --column="Databases" $DBS --height=400 --width=400