#!/bin/bash

# File: advanced_concepts.sh
# Purpose: Advanced shell scripting concepts including error handling,
#          debugging, optimization, and network operations

###########################################
# 1. ERROR HANDLING
###########################################
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

error_handler() {
    local line_no=$1
    local command=$2
    echo "Error on line ${line_no}: Command '${command}' failed"
    exit 1
}

trap 'error_handler ${LINENO} "$BASH_COMMAND"' ERR

###########################################
# 2. DEBUGGING TECHNIQUES
###########################################
debug_mode() {
    set -x  # Enable debug mode
    
    # Test operations
    local var1="test"
    local var2="debug"
    echo "${var1}_${var2}"
    
    set +x  # Disable debug mode
}

###########################################
# 3. PERFORMANCE OPTIMIZATION
###########################################
optimize_operations() {
    # Use native bash operations instead of external commands
    local start=$SECONDS
    
    # Optimized string operations
    local str="hello,world,test"
    IFS=',' read -ra ADDR <<< "$str"
    
    # Integer arithmetic without expr
    local result=$((5 + 3 * 2))
    
    echo "Execution time: $((SECONDS - start)) seconds"
}

###########################################
# 4. PARALLEL PROCESSING
###########################################
parallel_process() {
    process_item() {
        echo "Processing item $1"
        sleep 1
    }
    
    # Process items in parallel
    for i in {1..5}; do
        process_item $i &
    done
    
    # Wait for all background processes
    wait
}

###########################################
# 5. NAMED PIPES
###########################################
setup_named_pipe() {
    local pipe="/tmp/testpipe"
    mkfifo $pipe
    
    # Writer process
    (echo "Data through pipe" > $pipe) &
    
    # Reader process
    (read line < $pipe; echo "Received: $line")
    
    rm $pipe
}

###########################################
# 6. NETWORK OPERATIONS
###########################################
network_ops() {
    # TCP connection using /dev/tcp
    if exec 3>/dev/tcp/8.8.8.8/53 2>/dev/null; then
        echo "Network is accessible"
        exec 3>&-
    fi
    
    # Simple HTTP GET request
    exec 3</dev/tcp/example.com/80
    printf "GET / HTTP/1.0\r\nHost: example.com\r\n\r\n" >&3
    cat <&3
}

###########################################
# 7. SSH AUTOMATION
###########################################
ssh_operations() {
    local remote_host="example.com"
    local remote_user="user"
    
    # Generate SSH key pair
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    
    # SSH command execution
    ssh -n $remote_user@$remote_host "uptime" 2>/dev/null || echo "SSH failed"
    
    # SCP file transfer
    scp ./test.txt $remote_user@$remote_host:/tmp/ 2>/dev/null || echo "SCP failed"
}

###########################################
# 8. SECURE SHELL SCRIPTING
###########################################
secure_operations() {
    # Secure temporary file creation
    local temp_file=$(mktemp)
    
    # Secure permissions
    umask 077
    
    # Secure variable handling
    local password="sensitive_data"
    readonly password
    
    # Clean up
    shred -u $temp_file
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    echo "=== Advanced Concepts Demo ==="
    
    debug_mode
    optimize_operations
    parallel_process
    setup_named_pipe
    network_ops
    secure_operations
}

main "$@"