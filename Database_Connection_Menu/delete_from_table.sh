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

read -r columns < "$meta_file"
IFS=' ' read -r -a columns <<< "$columns"
read -r -a data_types <<< "$(sed -n '2p' "$meta_file")"
mapfile -t rows < "$table_file"



choice=$(zenity --list --title="Choose an option:" \
    --text="Select an option to delete from the table '$table':" \
    --column="Options" "Delete table" "Delete by Primary Key" "Delete by Column Value" \
    --width=400 --height=300)
if [ $? -ne 0 ] || [ -z "$choice" ]; then
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
fi

if [ "$choice" == "Delete table" ]; then
    >"$table_file" 
    zenity --info --text="Table '$table' deleted successfully." --width=300
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
elif [ "$choice" == "Delete by Primary Key" ]; then

    pk_index=-1
    for i in "${!columns[@]}"; do
        if [[ "${columns[$i]}(PK)" == *"(PK)" ]]; then
            pk_index=$i
            break
        fi
    done
    
    if [ $pk_index -eq -1 ]; then
        zenity --error --text="No primary key found in the table '$table'." --width=300
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 1
    fi

    pk_data_type=${data_types[$pk_index]}
    pk_value=$(zenity --entry --title="Delete by Primary Key" \
        --text="Enter the value of the primary key to delete:" \
        --width=300)

    if [ $? -ne 0 ] || [ -z "$pk_value" ]; then
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 0
    fi

    if [[ "$pk_data_type" == "int" ]]; then
        if ! [[ "$pk_value" =~ ^[0-9]+$ ]]; then
            zenity --error --text="Invalid input. Please enter a valid integer value." --width=300
            ../Database_Connection_Menu/main.sh "$db_name"
            exit 1
        elif [[ "$pk_value" -lt 0 ]]; then
            zenity --error --text="Invalid input. Please enter a positive integer value." --width=300
            ../Database_Connection_Menu/main.sh "$db_name"
            exit 1
        elif [[ -z "$pk_value" ]]; then
            zenity --error --text="Invalid input. Please enter a valid integer value." --width=300
            ../Database_Connection_Menu/main.sh "$db_name"
            exit 1
        fi
    elif [[ "$pk_data_type" == "varchar" ]]; then
        if [[ -z "$pk_value" ]]; then
            zenity --error --text="Invalid input. Please enter a valid string value." --width=300
            ../Database_Connection_Menu/main.sh "$db_name"
            exit 1
        fi
    fi 
    row_index=-1
    for i in "${!rows[@]}"; do
        IFS=',' read -r -a row_data <<< "${rows[$i]}"
        if [[ "${row_data[$pk_index]}" == "$pk_value" ]]; then
            row_index=$i
            break
        fi
    done
    if [ $row_index -eq -1 ]; then
        zenity --error --text="No matching row found with the primary key value '$pk_value'." --width=300
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 1
    fi
   
    row_number=$((row_index + 1))
    if [ ${#rows[@]} -eq 1 ]; then
        > "$table_file"  
    else
        sed -i "${row_number}d" "$table_file"
    fi
    zenity --info --text="Row with primary key value '$pk_value' deleted successfully." --width=300
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0
elif [ "$choice" == "Delete by Column Value" ]; then
    column=$(zenity --list --title="Available Columns to choose from:" \
        --text="Columns in the table named: $table" \
        --column="Columns" "${columns[@]}" \
        --width=400 --height=300)

    if [ $? -ne 0 ] || [ -z "$column" ]; then
        ../Database_Connection_Menu/main.sh "$db_name"
        exit 0
    fi

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
        zenity --info --text="No data found in the table '$table'." --width=300
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

    del_row_index=$(echo "$row" | awk '{print $1}')
    sed -i "${del_row_index}d" "$table_file"
    zenity --info --text="Row deleted successfully." --width=300
    ../Database_Connection_Menu/main.sh "$db_name"
    exit 0

fi