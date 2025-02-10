#!/bin/bash

# Descriptive header
# Author: Fayaz Khan
# Description: Demonstrates shell scripting fundamentals
# Date: 2025-02-06
#

# Bash scripting allows automation of tasks in Unix/Linux environments. 
# This script covers variables, data types, command substitution, string manipulation, arrays, environment variables, file descriptors, exit codes, and error handling.

# ===== Variables and Data Types =====
# Variables are a core part of scripting to store data.
name="DevOps"                    # String variable
age=25                          # Integer variable (treated as string)
price=99.99                     # Float-like value (bash treats as string)
is_valid=true                   # Boolean-like value (bash treats as string)

# ===== Command Substitution =====
# Allows capturing the output of commands.
current_date=$(date +%Y-%m-%d)  # Modern syntax for command substitution
kernel_version=`uname -r`       # Legacy syntax for command substitution
echo "System Info: $kernel_version, Date: $current_date"

# ===== String Manipulation =====
# Bash provides capabilities to manipulate strings.
text="Welcome to DevOps"
echo "Length: ${#text}"         # Get string length
echo "Uppercase: ${text^^}"     # Convert string to uppercase
echo "Lowercase: ${text,,}"     # Convert string to lowercase
echo "Substring: ${text:0:7}"   # Extract substring

# ===== Arrays =====
# Arrays allow storage of multiple values.
declare -a fruits=("apple" "banana" "orange")    # Indexed array
declare -A users                                 # Associative array
users=([admin]="John" [dev]="Alice")

# Access and operate on array elements.
echo "First fruit: ${fruits[0]}"
echo "All fruits: ${fruits[@]}"
echo "Number of fruits: ${#fruits[@]}"
echo "Admin user: ${users[admin]}"

# ===== Environment Variables =====
# Used to store environment-specific values.
export APP_ENV="production"     # Set a custom environment variable
echo "Path: $PATH"             # Access system environment variable
echo "Home: $HOME"
echo "App Env: $APP_ENV"

# ===== File Descriptors =====
# Handle input/output streams.
# File descriptors 0, 1, 2 represent stdin, stdout, stderr respectively.
exec 3> output.log             # Open file descriptor 3 for writing
echo "Log entry" >&3           # Write to file descriptor 3
exec 3>&-                      # Close file descriptor 3

# Redirect stderr to a file for error logging.
{
    echo "Success message"
    nonexistent_command        # This will generate an error
} 2>error.log

# ===== Exit Codes =====
# Used to indicate success or failure of commands.
check_file() {
    local file="$1"
    if [ -f "$file" ]; then
        return 0               # Return 0 for success
    else
        return 1               # Return 1 for failure
    fi
}

# Test exit codes with example files.
check_file "/etc/hosts"
echo "Exit code: $?"          # $? captures the exit code of the last command

check_file "/nonexistent"
echo "Exit code: $?"

# ===== Error Handling =====
# Handle errors gracefully in scripts.
set -e                        # Exit immediately if a command fails
set -u                        # Treat unset variables as an error
trap 'echo "Error on line $LINENO"' ERR    # Print error message with line number

# ===== Script Execution Examples =====
# Executing this script with different options.
# ./fundamentals.sh           # Basic execution
# bash -x fundamentals.sh     # Execute with debug mode enabled
# chmod +x fundamentals.sh    # Make script executable

