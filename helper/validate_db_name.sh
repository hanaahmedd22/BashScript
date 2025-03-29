validate_db_name() {
    db_name_input="$1"
    db_name_lower_input=$(echo "$db_name_input" | tr '[:upper:]' '[:lower:]')
    if [[ -z "$db_name_input" ]]; then
        zenity --error --text="Error: Database name cannot be empty."
        return 1
    fi
    if [[ "$db_name_input" =~ [[:space:]] ]]; then
        zenity --error --text="Error: Database name cannot contain spaces."
        return 1
    fi

    if [[ ! "$db_name_input" =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Error: Invalid database name. Use only letters, numbers, and underscores."
        return 1
    fi

    if [[ "$db_name_input" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Error: Database name cannot be only numbers."
        return 1
    fi

    if [[ "$db_name_input" =~ ^[0-9] ]]; then
        zenity --error --text="Error: Database name cannot start with a number."
        return 1
    fi

    sql_keywords=("SELECT" "TABLE" "INSERT" "UPDATE" "DELETE" "FROM" "WHERE" "JOIN" "ORDER" "GROUP" "HAVING" "LIMIT" "DROP" "CREATE" "DATABASE")
    for keyword in "${sql_keywords[@]}"; do
        if [[ "$db_name_lower_input" == "$(echo "$keyword" | tr '[:upper:]' '[:lower:]')" ]]; then
            zenity --error --text="Error: Database name cannot be a reserved SQL keyword."
            return 1
        fi
    done

    for db in ../Databases/*/; do
        if [[ "$(basename "$db" | tr '[:upper:]' '[:lower:]')" == "$db_name_lower_input" ]]; then
            zenity --error --text="Error: Database '$db_name_input' already exists."
            return 1
        fi
    done
    return 0
}

