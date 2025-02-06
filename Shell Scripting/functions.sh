#!/bin/bash

# File: functions.sh
# Purpose: Demonstrate function usage, returns, and argument handling
# Usage: ./functions.sh -n name -c count -v
# Author: Fayaz Khan
# Date: 2025-02-06

###########################################
# 1. FUNCTION LIBRARY IMPORT
###########################################
# First, create a separate library file: utils.sh
cat > ./lib/utils.sh << 'EOF'
#!/bin/bash

# Utility function for logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Utility function for validation
validate_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}
EOF

# Source the library
source ./lib/utils.sh

###########################################
# 2. BASIC FUNCTION DECLARATION
###########################################
greet() {
    local name=$1
    echo "Hello, $name!"
}

###########################################
# 3. RETURN VALUES
###########################################
calculate_sum() {
    local num1=$1
    local num2=$2
    # Return numeric value
    return $((num1 + num2))
}

get_server_status() {
    # Return string via echo
    if ping -c 1 google.com &> /dev/null; then
        echo "online"
    else
        echo "offline"
    fi
}

###########################################
# 4. LOCAL VARIABLES
###########################################
demonstrate_scope() {
    local local_var="I am local"
    global_var="I am global"
    echo "Inside function: $local_var"
    echo "Inside function: $global_var"
}

###########################################
# 5. RECURSIVE FUNCTIONS
###########################################
factorial() {
    local num=$1
    if [ $num -eq 0 ]; then
        echo 1
    else
        local prev=$(factorial $((num - 1)))
        echo $((num * prev))
    fi
}

###########################################
# 6. COMMAND LINE ARGUMENTS
###########################################
process_arguments() {
    while getopts "n:c:vh" opt; do
        case $opt in
            n) name="$OPTARG";;
            c) count="$OPTARG";;
            v) verbose=true;;
            h) show_help; exit 0;;
            ?) echo "Invalid option"; exit 1;;
        esac
    done
}

show_help() {
    cat << EOF
Usage: $0 [options]
Options:
    -n NAME    Specify name
    -c COUNT   Specify count
    -v         Verbose mode
    -h         Show this help
EOF
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    # Test basic function
    greet "DevOps Engineer"

    # Test return values
    calculate_sum 5 3
    echo "Sum result: $?"
    
    # Test server status
    status=$(get_server_status)
    echo "Server is $status"
    
    # Test variable scope
    demonstrate_scope
    echo "Outside function: $global_var"
    echo "Outside function: $local_var" # Will be empty

    # Test recursive function
    echo "Factorial of 5: $(factorial 5)"
    
    # Process command line arguments
    process_arguments "$@"
    
    # Use library function
    log_message "Script completed successfully"
}

# Execute main with all script arguments
main "$@"