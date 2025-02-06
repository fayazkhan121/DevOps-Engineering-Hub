#!/bin/bash

# Descriptive header
# Author: Fayaz Khan
# Description: Demonstrates shell scripting fundamentals
# Date: 2025-02-06
#

# Variables and Data Types
# Command Substitution
# String Manipulation
# Arrays
# Environment Variables
# File Descriptors

# ===== Variables and Data Types =====
name="DevOps"                    # String
age=25                          # Integer
price=99.99                     # Treated as string (bash doesn't have float)
is_valid=true                   # Boolean (treated as string)

# ===== Command Substitution =====
current_date=$(date +%Y-%m-%d)  # Modern syntax
kernel_version=`uname -r`       # Legacy syntax
echo "System Info: $kernel_version, Date: $current_date"

# ===== String Manipulation =====
text="Welcome to DevOps"
echo "Length: ${#text}"         # String length
echo "Uppercase: ${text^^}"     # Convert to uppercase
echo "Lowercase: ${text,,}"     # Convert to lowercase
echo "Substring: ${text:0:7}"   # Extract substring (Welcome)

# ===== Arrays =====
# Declare arrays
declare -a fruits=("apple" "banana" "orange")    # Indexed array
declare -A users                                 # Associative array
users=([admin]="John" [dev]="Alice")

# Array operations
echo "First fruit: ${fruits[0]}"
echo "All fruits: ${fruits[@]}"
echo "Number of fruits: ${#fruits[@]}"
echo "Admin user: ${users[admin]}"

# ===== Environment Variables =====
export APP_ENV="production"     # Set environment variable
echo "Path: $PATH"             # Access system env variable
echo "Home: $HOME"
echo "App Env: $APP_ENV"

# ===== File Descriptors =====
# 0 - stdin, 1 - stdout, 2 - stderr
exec 3> output.log             # Open FD 3 for writing
echo "Log entry" >&3           # Write to FD 3
exec 3>&-                      # Close FD 3

# Redirect stderr to file
{
    echo "Success message"
    nonexistent_command        # This will generate an error
} 2>error.log

# ===== Exit Codes =====
# Function to demonstrate exit codes
check_file() {
    local file="$1"
    if [ -f "$file" ]; then
        return 0               # Success
    else
        return 1              # Error
    fi
}

# Test exit codes
check_file "/etc/hosts"
echo "Exit code: $?"          # $? contains last command's exit code

check_file "/nonexistent"
echo "Exit code: $?"

# ===== Error Handling =====
set -e                        # Exit on error
set -u                        # Exit on undefined variable
trap 'echo "Error on line $LINENO"' ERR    # Trap errors

# ===== Script Execution Examples =====
# ./fundamentals.sh           # Basic execution
# bash -x fundamentals.sh     # Debug mode
# chmod +x fundamentals.sh    # Make executable
