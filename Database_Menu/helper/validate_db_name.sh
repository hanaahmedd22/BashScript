validate_db_name() {
    local db_name="$1"
    local db_name_lower=$(echo "$db_name" | tr '[:upper:]' '[:lower:]')

    # Check if the name is empty
    if [[ -z "$db_name" ]]; then
        zenity --error --text="Error: Database name cannot be empty."
        return 1
    fi

    # Check for spaces
    if [[ "$db_name" =~ [[:space:]] ]]; then
        zenity --error --text="Error: Database name cannot contain spaces."
        return 1
    fi

    # Check if name contains only letters, numbers, and underscores
    if [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Error: Invalid database name. Use only letters, numbers, and underscores."
        return 1
    fi

    # Check if name is completely numeric
    if [[ "$db_name" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Error: Database name cannot be only numbers."
        return 1
    fi

    # Check if name starts with a number
    if [[ "$db_name" =~ ^[0-9] ]]; then
        zenity --error --text="Error: Database name cannot start with a number."
        return 1
    fi

    # Check if name is a reserved SQL keyword
    sql_keywords=("SELECT" "TABLE" "INSERT" "UPDATE" "DELETE" "FROM" "WHERE" "JOIN" "ORDER" "GROUP" "HAVING" "LIMIT" "DROP" "CREATE" "DATABASE")
    for keyword in "${sql_keywords[@]}"; do
        if [[ "$db_name_lower" == "$(echo "$keyword" | tr '[:upper:]' '[:lower:]')" ]]; then
            zenity --error --text="Error: Database name cannot be a reserved SQL keyword."
            return 1
        fi
    done

    # Check if name is already taken (case-insensitive)
    for db in ../Databases/*/; do
        if [[ "$(basename "$db" | tr '[:upper:]' '[:lower:]')" == "$db_name_lower" ]]; then
            zenity --error --text="Error: Database '$db_name' already exists."
            return 1
        fi
    done
    return 0
}

