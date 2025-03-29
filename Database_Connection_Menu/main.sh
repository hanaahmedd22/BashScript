#!/usr/bin/bash
cd ../Database_Connection_Menu
db_name=$1
db_path="../Databases/$db_name"
echo "Connected to database '$db_name' successfully."
while true; do
    choice=$(zenity --list --title="Database Connection Menu" --column="Options" "Create Table" "List Tables" "Drop Table" "Insert into Table"  "Select from Table"  "Delete from Table" "Modify Table " "Exit" --height=300 --width=400)
    echo $choice
    case $choice in
        "Create Table")
            . ./create_table.sh $db_name $db_path
            ;;
        "List Tables")
            . ./list_tables.sh $db_name $db_path
            ;;
        "Drop Table")
            . ./drop_table.sh $db_name $db_path
            ;;
        "Insert into Table")
            . ./insert_into_table.sh $db_name $db_path
            ;;
        "Select from Table")
            . ./select_from_table.sh $db_name $db_path
            ;;
        "Delete from Table")
            . ./delete_from_table.sh $db_name $db_path
            ;;
        "Modify Table")
            . ./modify_table.sh $db_name $db_path
            ;;
        "Exit")
            exit 0
            ../Database_Menu/main.sh
            ;;
        *)
            zenity --error --text="Invalid choice. Please try again."
            ;;
    esac
done
