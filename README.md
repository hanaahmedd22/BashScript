# Bash DBMS with GUI (Zenity)

## Overview
This project is a simple Database Management System (DBMS) implemented using Bash scripting with a graphical user interface powered by Zenity. It provides basic functionalities for managing databases and tables through an interactive GUI.

## Features
- **Create Database**: Allows users to create new databases.
- **Delete Database**: Enables users to remove existing databases.
- **List Databases**: Displays a list of all available databases.
- **Create Table**: Allows users to define a table with specific column names and data types.
- **Delete Table**: Removes a selected table from the database.
- **Insert Data**: Adds new records to a table with data validation.
- **View Table Data**: Displays all records in a selected table.
- **Search Data**: Finds records based on specific criteria.
- **Update Data**: Modifies existing records in a table.
- **Delete Data**: Removes specific records from a table.

## Technologies Used
- **Bash Scripting**: For implementing the core logic.
- **Zenity**: For creating the graphical user interface.
- **File System Storage**: Data is stored in structured files.

## Installation
1. Ensure you have **Zenity** installed. If not, install it using:
   ```bash
   sudo apt install zenity  # For Debian-based systems
   sudo dnf install zenity  # For Fedora-based systems
   ```
2. Clone the repository:
   ```bash
   git clone https://github.com/hanaahmedd22/BashScript.git
   ```
3. Navigate to the project directory:
   ```bash
   cd Database_Menu
   ```
4. Grant execution permissions:
   ```bash
   chmod +x *.sh
   ```
5. Run the project:
   ```bash
   ./main.sh
   ```

## Usage
1. Upon launching the script, a GUI menu will appear.
2. Select the desired database operation from the menu.
3. Follow the prompts to perform actions like creating databases, inserting records, or searching for data.
4. Data is stored in structured files, allowing easy retrieval and modification.

