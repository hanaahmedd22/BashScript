#!/usr/bin/bash
cd ../Database_Connection_Menu
db_name=$1
db_path=$2

mapfile -t tables < <(ls "$db_path" | grep ".meta$" | sed 's/.meta$//')

if [ ${#tables[@]} -eq 0 ]; then
    zenity --info --text="No tables found in the database path: $db_path" --width=300  
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi

table=$(zenity --list --title="Available Tables to choose from:" \
    --text="Tables in the database named: $db_name" \
    --column="Tables" "${tables[@]}" \
    --width=400 --height=300)

if [ $? -ne 0 ] || [ -z "$table" ]; then
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi

table_file="$db_path/$table.data"
meta_file="$db_path/$table.meta"

if [ ! -f "$meta_file" ]; then
    zenity --error --text="Meta file for table '$table' not found."
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 1
fi

read -r columns < "$meta_file"
IFS=' ' read -r -a columns <<< "$columns"
read -r -a data_types <<< "$(sed -n '2p' "$meta_file")"
mapfile -t rows < "$table_file"

if [ ${#columns[@]} -eq 0 ]; then
    zenity --error --text="No columns found in the meta file for table '$table'."
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 1
fi

column=$(zenity --list --title="Available Columns to choose from:" \
    --text="Columns in the table named: $table" \
    --column="Columns" "${columns[@]}" \
    --width=400 --height=300)
pk_index=-1
for i in "${!columns[@]}"; do
    if [[ "${columns[$i]}(PK)" == *"(PK)" ]]; then
        pk_index=$i
        break
    fi
done


column_index=-1
for i in "${!columns[@]}"; do
    if [[ "${columns[$i]}" == "$column" ]]; then
        column_index=$i
        break
    fi
done
col_data_type=${data_types[$column_index]}
echo $col_data_type
if [ $? -ne 0 ] || [ -z "$column" ]; then
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi
rows_count=${#rows[@]}
if [ $rows_count -eq 0 ]; then
    zenity --info --text="No data found in the table '$table'."
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi

row_values=()
for i in "${!rows[@]}"; do
    IFS=',' read -r -a row_data <<< "${rows[$i]}"
    row_values+=("$((i+1)) - ${row_data[$column_index]}")
done


row=$(zenity --list --title="Available Rows to choose from:" \
    --text="Rows in the table named: $table (Column: $column)" \
    --column="Row Number - Value" "${row_values[@]}" \
    --width=400 --height=300)

if [ $? -ne 0 ] || [ -z "$row" ]; then
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi

new_value=$(zenity --entry --title="Update Column" \
    --text="Enter new value for $column in row: $row" --width=400)


if [[ "$col_data_type" == "int" ]]; then
    if [[ ! "$new_value" =~ ^[0-9]+$ || -z "$new_value" ]]; then
        zenity --error --text="Invalid input! Expected an integer."
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 0
    fi
elif [[ "$col_data_type" == "varchar" ]]; then
    if [[ -z "$new_value" ]]; then
        zenity --error --text="Invalid input! Varchar cannot be empty."
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 0
    fi
fi

if [[ $column_index -eq $pk_index ]]; then
    for existing_row in "${rows[@]}"; do
        IFS=',' read -r -a row_data <<< "$existing_row"
        if [[ "${row_data[$pk_index]}" == "$new_value" ]]; then
            zenity --error --text="Duplicate Primary Key! Enter a unique value."
            ../Database_Connection_Menu/main.sh "$db_name"
            exit 0
        fi
    done
fi


row_index=$(echo "$row" | awk '{print $1}')

awk -v row_index="$row_index" -v col_index="$((column_index+1))" -v new_value="$new_value" '
BEGIN {
    FS = ",";  
    OFS = ",";  
}
{
    if (NR == row_index) {
        $col_index = new_value; 
    }
    print $0;
}
' "$table_file" > temp_file && mv temp_file "$table_file"



zenity --info --text="Record updated successfully!"
