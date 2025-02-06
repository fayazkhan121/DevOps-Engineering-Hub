#!/bin/bash

# File: 02_control_structures.sh
# Purpose: Demonstrate all control structures in Bash scripting
# Usage: ./02_control_structures.sh [arguments]
# Author: Fayaz Khan
# Date: 2025-02-06

###########################################
# 1. IF-ELSE CONDITIONS
###########################################
check_file_status() {
    local filename="/etc/hosts"
    
    if [ -f "$filename" ]; then
        echo "File exists and is regular file"
    elif [ -d "$filename" ]; then
        echo "This is a directory"
    else
        echo "File does not exist"
    fi
}

###########################################
# 2. CASE STATEMENTS
###########################################
check_os() {
    local os_type=$(uname)
    case "$os_type" in
        "Linux")
            echo "Running on Linux"
            ;;
        "Darwin")
            echo "Running on MacOS"
            ;;
        "MINGW"*|"CYGWIN"*)
            echo "Running on Windows"
            ;;
        *)
            echo "Unknown operating system"
            ;;
    esac
}

###########################################
# 3. FOR LOOPS
###########################################
demonstrate_loops() {
    # Traditional for loop
    echo "Traditional for loop:"
    for ((i=1; i<=3; i++)); do
        echo "Count: $i"
    done

    # For-in loop with array
    echo -e "\nFor-in loop with array:"
    local fruits=("apple" "banana" "orange")
    for fruit in "${fruits[@]}"; do
        echo "Fruit: $fruit"
    done

    # For-in loop with command output
    echo -e "\nFor-in loop with command output:"
    for user in $(cut -d: -f1 /etc/passwd | head -3); do
        echo "User: $user"
    done
}

###########################################
# 4. WHILE/UNTIL LOOPS
###########################################
countdown() {
    local count=5
    
    echo "While loop countdown:"
    while [ $count -gt 0 ]; do
        echo $count
        ((count--))
        sleep 1
    done

    echo -e "\nUntil loop countdown:"
    count=5
    until [ $count -eq 0 ]; do
        echo $count
        ((count--))
        sleep 1
    done
}

###########################################
# 5. BREAK/CONTINUE
###########################################
demonstrate_break_continue() {
    echo "Break demonstration:"
    for ((i=1; i<=5; i++)); do
        if [ $i -eq 3 ]; then
            break
        fi
        echo "Break loop: $i"
    done

    echo -e "\nContinue demonstration:"
    for ((i=1; i<=5; i++)); do
        if [ $i -eq 3 ]; then
            continue
        fi
        echo "Continue loop: $i"
    done
}

###########################################
# 6. SELECT STATEMENTS
###########################################
show_menu() {
    echo "Select an option:"
    select option in "View Date" "View Calendar" "View Uptime" "Exit"; do
        case $option in
            "View Date")
                date
                ;;
            "View Calendar")
                cal
                ;;
            "View Uptime")
                uptime
                ;;
            "Exit")
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

###########################################
# 7. SHIFT COMMAND
###########################################
process_arguments() {
    echo "Processing arguments:"
    while [ $# -gt 0 ]; do
        echo "Current argument: $1"
        shift
    done
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    echo "=== Control Structures Demo ==="
    
    echo -e "\n1. Testing if-else:"
    check_file_status
    
    echo -e "\n2. Testing case statement:"
    check_os
    
    echo -e "\n3. Testing loops:"
    demonstrate_loops
    
    echo -e "\n4. Testing while/until:"
    countdown
    
    echo -e "\n5. Testing break/continue:"
    demonstrate_break_continue
    
    echo -e "\n6. Testing select menu:"
    show_menu
    
    echo -e "\n7. Testing shift command:"
    process_arguments "$@"
}

# Execute main with all script arguments
main "$@"