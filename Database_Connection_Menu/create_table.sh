#!/usr/bin/bash
cd ../Database_Connection_Menu

source ./helper/validations.sh
db_name=$1
db_path=$2
while true;do 
    table_name=$(zenity --entry --title="Create Table" --text="Enter table name:" --width=300)

    CheckIfValidOfTableName "$table_name" "$db_path"
    if [ $? -eq 0 ]; then
        zenity --info --text="Table '$table_name' created successfully."
        break
    fi
done

data_file="$db_path/${table_name}.data"
meta_data_file="$db_path/${table_name}.meta"

while true;do
    num_col=$(zenity --entry --title="Number of Columns" --text="Enter Number of Columns:" --width=300)

    if ! [[ "$num_col" =~ ^[0-9]+$ ]] || [ "$num_col" -le 0 ]; then
        zenity --error --text="Invalid number of columns. Please enter a positive integer." --width=300
        continue
    elif [ -z "$num_col" ]; then
        zenity --error --text="Number of columns cannot be empty." --width=300
        continue
    fi
    break
done
column=()
data_type=()


for ((i=1; i<=num_col; i++)); do
    while true;do
        col_name=$(zenity --entry --title="Column Name" --text="Enter name for column $i:" --width=300)

        
        CheckIfValidOfName "$col_name"
        if [ $? -ne 0 ]; then
            zenity --error --text="Invalid column name for column $i. Only alphanumeric characters are allowed." --width=300
            continue
        elif [[ " ${column[@]} " =~ " ${col_name} " ]]; then
            zenity --error --text="Column name '$col_name' already exists. Please choose a different name." --width=300
            continue
        fi
        column+=("$col_name")
        break
    done

    while true;do
        col_type=$(zenity --list --title="Data Type" --text="Select data type for column $i:" \
            --column="Data Type" "varchar" "int" --width=400 --height=300)

        if [ $? -ne 0 ] || { [ "$col_type" != "varchar" ] && [ "$col_type" != "int" ]; }; then
            zenity --error --text="Invalid data type for column $i. Please select 'varchar' or 'int'." --width=300
            continue
        fi
        data_type+=("$col_type")
        break
    done
done
for((i=0; i<${#column[@]}; i++)); do
    primary_key=$(zenity --question --text="Is ${column[$i]} a primary key?" --width=300)
    if [ $? -eq 0 ]; then
        column[$i]="${column[$i]}(PK)"
        break
    fi
done
touch "$meta_data_file"
echo "${column[*]}" > "$meta_data_file"
echo "${data_type[*]}" >> "$meta_data_file"


touch "$data_file"

zenity --info --text="Table '$table_name' created successfully in database '$db_name'." --width=300