# #!/usr/bin/bash

# while true; do
#     choice=$(zenity --list --title="Bash DBMS" --column="Options" \
#         "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit" \
#         --height=300 --width=400)
#     case $choice in
#         "Create Database")
#            . ./create_db.sh
#             ;;
#         "List Databases")
#            . ./list_dbs.sh
#             ;;
#         "Connect to Database")
#            . ./connect_db.sh
#             ;;
#         "Drop Database")
#            . ./drop_db.sh
#             ;;
#         "Exit")
#             exit 0
#             ;;
#         *)
#             zenity --error --text="Invalid choice. Please try again."
#             ;;
#     esac
# done
#!/usr/bin/bash
# =================================================================================================
# without zenity
# =================================================================================================
while true; do
    echo "===== Bash DBMS ====="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect to Database"
    echo "4) Drop Database"
    echo "5) Exit"
    echo "====================="
    read -p "Enter your choice: " choice

    case $choice in
        1) . ./create_db.sh ;;
        2) . ./list_dbs.sh ;;
        3) . ./connect_db.sh ;;
        4) . ./drop_db.sh ;;
        5) exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
