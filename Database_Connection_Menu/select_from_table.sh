#!/usr/bin/bash
DataB=$1
DBPth=$2

tabls=$(ls "$DBPth" | sed -n 's/.meta$//gp')
if [ -z "$tabls" ]; then
    zenity --info --text="No tables found in the database $DataB to select from."
    ./main.sh "$DataB"
    exit 0
fi

tablName=$(zenity --list --title="Select Table" --column="Tables" $tabls --height=400 --width=400)
if [[ $? -ne 0 ]] || [[ -z "$tablName" ]]; then
    zenity --error --text="No table selected. Operation canceled."
    ./main.sh "$DataB"
    exit 0
fi

meta="$DBPth/$tablName.meta"
data="$DBPth/$tablName.data"
colNames=($(awk 'NR==1' "$meta"))

choice=$(zenity --list --title="Select Option" --column="Options" "View All Rows" "Select by Row (PK)" "Select by Column" --height=300 --width=400)
case "$choice" in
    "View All Rows")
        zen="zenity --list --title='Table: $tablName' --height=400 --width=800"
        for col in "${colNames[@]}"; do
            zen+=" --column='$col'"
        done
        tableData=()
        while IFS=',' read -ra row; do
            tableData+=("${row[@]}")
        done < "$data"
        eval "$zen ${tableData[*]}"
        ;;

"Select by Row (PK)")
    pk_value=$(zenity --entry --title="Enter Pk" --text="Enter the Primary Key value:") 
    if [[ -z "$pk_value" ]]; then
        zenity --error --text="No value entered. Try Again :] "
        ./main.sh "$DataB"
        exit 0
    fi
    selected_row=$(awk -F',' -v pk="$pk_value" '$1 == pk {print}' "$data") 
    if [[ -z "$selected_row" ]]; then
        zenity --error --text="No matching row found for Primary Key: $pk_value"
    else
        zen_col="zenity --list --title='Table: $tablName' --height=400 --width=800"
        for col in "${colNames[@]}"; do
            zen_col+=" --column='$col'"
        done
        formatted_row=$(echo "$selected_row" | tr ',' ' ')
        eval "$zen_col $formatted_row"
    fi
    ;;

    "Select by Column")
        colName=$(zenity --list --title="Select Column" --column="Columns" "${colNames[@]}" --height=400 --width=400)
        if [[ -z "$colName" ]]; then
            zenity --error --text="No column selected. Try Again."
            ./main.sh "$DataB"
            exit 0
        fi

        colIndex=$(awk -v col="$colName" 'NR==1 {for(i=1; i<=NF; i++) if ($i == col) print i}' "$meta")
        if [[ -z "$colIndex" ]]; then
            zenity --error --text="Column not found!"
            exit 0
        fi
        column_data=$(awk -F',' -v ind="$colIndex" '{print $ind}' "$data")
        zen_col="zenity --list --title='Column: $colName' --height=400 --width=400 --column='$colName'"
        formatted_data=$(echo "$column_data" | tr '\n' ' ')
        eval "$zen_col $formatted_data"
        ;;
esac
