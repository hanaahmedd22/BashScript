validate_db_name() {
    local db_name="$1"
    local db_name_lower=$(echo "$db_name" | tr '[:upper:]' '[:lower:]')
    # --------------------------------------------------------------------------------------
    # Check if name is empty
    [[ -z "$db_name" ]] && echo "Error: Database name cannot be empty." && return 1
    # --------------------------------------------------------------------------------------
    # Check for spaces
    [[ "$db_name" =~ [[:space:]] ]] && echo "Error: Database name cannot contain spaces." && return 1
    # --------------------------------------------------------------------------------------
    # Check if name contains only letters, numbers, and underscores
    [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]] && echo "Error: Invalid database name. Use only letters, numbers, and underscores." && return 1
    # --------------------------------------------------------------------------------------
    # Check if name is completely numeric
    [[ "$db_name" =~ ^[0-9]+$ ]] && echo "Error: Database name cannot be only numbers." && return 1
    # --------------------------------------------------------------------------------------
    # Check if name starts with a number
    [[ "$db_name" =~ ^[0-9] ]] && echo "Error: Database name cannot start with a number." && return 1
    # --------------------------------------------------------------------------------------
    # Check if name is a reserved SQL keyword
    local sql_keywords=("SELECT" "TABLE" "INSERT" "UPDATE" "DELETE" "FROM" "WHERE" "JOIN" "ORDER" "GROUP" "HAVING" "LIMIT" "DROP" "CREATE" "DATABASE")
    for keyword in "${sql_keywords[@]}"; do
        [[ "$db_name_lower" == "$(echo "$keyword" | tr '[:upper:]' '[:lower:]')" ]] && echo "Error: Database name cannot be a reserved SQL keyword." && return 1
    done
    # --------------------------------------------------------------------------------------
    # Check if name is already taken (case-insensitive)
    for db in ./*/; do
        [[ "$(basename "$db" | tr '[:upper:]' '[:lower:]')" == "$db_name_lower" ]] && 
        echo "Error: Database '$db_name' already exists." && return 1
    done
    return 0
}
