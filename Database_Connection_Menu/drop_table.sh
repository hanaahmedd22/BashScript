#!/usr/bin/bash
MYDB_name=$1  
MYDB_path=$2  
tables=$(ls $MYDB_path | sed -n 's/.meta$//gp') 
if [ -z "$tables" ]; then
    echo "No tables found in the database to drop ^_^ " 
    zenity --info --text="No tables found in the database $MYDB_name to Drop :]"
    exit 0
fi

tablee_name=$(zenity --list --title="Select Table to Drop" --column="Tables" $tables  --height=400 --width=400)
if [[ $? -ne 0 ]]; then
        zenity --info --text="Operation cancelled by the user."
        echo "User Cancel the Operation..."
        ./main.sh "$MYDB_name"
        exit 0
fi
if [[ -z "$tablee_name" ]]; then
        zenity --error --text="Nothing selected, Try again.." 
        echo "Try to select table to Drop again.."
        ./main.sh "$MYDB_name"
        exit 0
fi
echo "Deleting from database '$MYDB_name' Table '$tablee_name'..."
rm -f "$MYDB_path/$tablee_name.data" "$MYDB_path/$tablee_name.meta"
zenity --info --text="Delete table '$tablee_name'  from '$MYDB_name'  successfully :] "
./main.sh "$MYDB_name"