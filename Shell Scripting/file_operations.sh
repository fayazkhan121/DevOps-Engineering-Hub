#!/bin/bash

# File: file_operations.sh
# Purpose: Comprehensive file operations, testing, and text processing
# Usage: ./file_operations.sh [directory]

###########################################
# 1. FILE TESTING
###########################################
test_file_properties() {
    local file="$1"
    
    # File existence and type tests
    [ -e "$file" ] && echo "File exists"
    [ -f "$file" ] && echo "Regular file"
    [ -d "$file" ] && echo "Directory"
    [ -L "$file" ] && echo "Symbolic link"
    
    # File permissions
    [ -r "$file" ] && echo "Readable"
    [ -w "$file" ] && echo "Writable"
    [ -x "$file" ] && echo "Executable"
    
    # File size
    [ -s "$file" ] && echo "File is not empty"
}

###########################################
# 2. FILE PERMISSIONS
###########################################
manage_permissions() {
    local file="$1"
    
    # Change ownership
    sudo chown user:group "$file"
    
    # Set permissions (rwx for owner, rx for group/others)
    chmod 755 "$file"
    
    # Set ACL (if supported)
    if command -v setfacl &>/dev/null; then
        setfacl -m u:specific_user:rx "$file"
    fi
}

###########################################
# 3. READ/WRITE OPERATIONS
###########################################
file_operations() {
    # Write to file
    echo "First line" > test.txt
    echo "Second line" >> test.txt
    
    # Read file line by line
    while IFS= read -r line; do
        echo "Read: $line"
    done < test.txt
    
    # Process file with field separator
    echo "name,age,city" > data.csv
    echo "john,25,nyc" >> data.csv
    
    while IFS=, read -r name age city; do
        echo "Name: $name, Age: $age, City: $city"
    done < data.csv
}

###########################################
# 4. DIRECTORY OPERATIONS
###########################################
directory_ops() {
    local dir="test_dir"
    
    # Create directory structure
    mkdir -p "$dir"/{config,data,logs}
    
    # Create files
    touch "$dir"/config/settings.conf
    touch "$dir"/data/info.txt
    
    # List directory tree
    tree "$dir" 2>/dev/null || find "$dir" -print
    
    # Clean up
    rm -rf "$dir"
}

###########################################
# 5. FIND COMMAND
###########################################
find_examples() {
    # Find files by type and name
    find . -type f -name "*.sh"
    
    # Find files modified in last 24 hours
    find . -type f -mtime -1
    
    # Find and execute
    find . -type f -name "*.tmp" -exec rm {} \;
    
    # Find files by size
    find . -type f -size +1M
}

###########################################
# 6. GREP OPERATIONS
###########################################
grep_examples() {
    # Create sample log file
    cat > sample.log << EOF
2024-02-06 10:00:00 INFO Starting application
2024-02-06 10:00:01 ERROR Database connection failed
2024-02-06 10:00:02 INFO Retrying connection
2024-02-06 10:00:03 SUCCESS Connected to database
EOF

    # Basic grep
    echo "Lines with ERROR:"
    grep "ERROR" sample.log
    
    # Context grep
    echo "ERROR with context:"
    grep -C 1 "ERROR" sample.log
    
    # Recursive grep
    echo "All ERROR in directory:"
    grep -r "ERROR" .
}

###########################################
# 7. SED & AWK
###########################################
text_processing() {
    # Sed examples
    echo "Original text" | sed 's/text/content/'
    
    # Multiple sed operations
    sed -e 's/old/new/g' -e 's/bad/good/g' input.txt
    
    # Awk examples
    echo "Processing Apache logs:"
    awk '{print $1, $9}' apache.log  # IP and status code
    
    # Awk with calculations
    echo "10 20 30" | awk '{sum=$1+$2+$3; print "Sum:", sum}'
}

###########################################
# 8. REGULAR EXPRESSIONS
###########################################
regex_examples() {
    # Email validation
    email="user@example.com"
    if [[ $email =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "Valid email"
    fi
    
    # IP address validation
    ip="192.168.1.1"
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "Valid IP format"
    fi
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    echo "=== File Operations Demo ==="
    
    test_file_properties "/etc/hosts"
    file_operations
    directory_ops
    find_examples
    grep_examples
    text_processing
    regex_examples
}

main "$@"