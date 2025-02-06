#!/bin/bash

# File: advanced_concepts.sh
# Purpose: Advanced shell scripting concepts and techniques
# Usage: ./advanced_concepts.sh

###########################################
# 1. ERROR HANDLING
###########################################
setup_error_handling() {
    # Enable error handling options
    set -e  # Exit immediately if a command exits with a non-zero status
    set -u  # Treat unset variables as an error and exit immediately
    set -o pipefail  # Return the exit status of the last command in the pipe that failed

    # Trap errors and call error_handler with relevant information
    # - $? : The exit code of the last executed command
    # - $LINENO : The line number where the error occurred
    # - $BASH_LINENO : An array of line numbers for each function call
    # - $BASH_COMMAND : The command that was executed
    # - FUNCNAME : An array of function names currently on the call stack
    trap 'error_handler $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR
}

error_handler() {
    local exit_code=$1
    local line_no=$2
    local bash_lineno=$3
    local last_command=$4
    local func_trace=$5
    
    echo "Error on line $line_no: Command '$last_command' exited with status $exit_code"
    echo "Function trace: $func_trace"
}

###########################################
# 2. DEBUGGING TECHNIQUES
###########################################
enable_debugging() {
    # Enable debug mode
    set -x
    
    # Debug specific section
    {
        set -x
        echo "Debugging this section"
        local var="test"
        echo $var
        set +x
    }
    
    # Stack trace function
    print_stack_trace() {
        local frame=0
        while caller $frame; do
            ((frame++))
        done
    }
}

###########################################
# 3. PERFORMANCE OPTIMIZATION
###########################################
optimize_performance() {
    # Use built-in commands
    local start=$SECONDS
    
    # Array operations
    declare -A hash_map
    for i in {1..1000}; do
        hash_map[$i]=$i
    done
    
    # Fast string operations
    local str="Hello World"
    echo "${str:0:5}"  # Substring
    echo "${str//o/X}"  # Replace
    
    echo "Execution time: $((SECONDS - start)) seconds"
}

###########################################
# 4. PARALLEL PROCESSING
###########################################
parallel_processing() {
    process_item() {
        echo "Processing item $1"
        sleep 1
    }
    
    # Parallel execution with job control
    for i in {1..5}; do
        process_item $i &
    done
    wait
    
    # Using GNU Parallel if available
    if command -v parallel &>/dev/null; then
        parallel echo ::: {1..5}
    fi
}

###########################################
# 5. NAMED PIPES
###########################################
named_pipe_demo() {
    # Create named pipe
    mkfifo /tmp/testpipe
    
    # Writer process
    {
        echo "Data through pipe" > /tmp/testpipe
    } &
    
    # Reader process
    read line < /tmp/testpipe
    echo "Received: $line"
    
    # Cleanup
    rm /tmp/testpipe
}

###########################################
# 6. NETWORK OPERATIONS
###########################################
network_operations() {
    # Check host availability
    check_host() {
        if ping -c 1 "$1" &>/dev/null; then
            echo "$1 is up"
        else
            echo "$1 is down"
        fi
    }
    
    # TCP connection test
    test_port() {
        nc -zv "$1" "$2" 2>&1
    }
    
    # HTTP request
    http_get() {
        curl -sL "$1"
    }
}

###########################################
# 7. SSH AUTOMATION
###########################################
ssh_automation() {
    # Generate SSH key
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/script_key -N ""
    
    # SSH command execution
    remote_command() {
        ssh -i ~/.ssh/script_key user@host "$1"
    }
    
    # SCP file transfer
    transfer_file() {
        scp -i ~/.ssh/script_key "$1" user@host:~/
    }
}

###########################################
# 8. SECURE SHELL SCRIPTING
###########################################
secure_practices() {
    # Secure temporary files
    temp_file=$(mktemp)
    trap 'rm -f $temp_file' EXIT
    
    # Input validation
    validate_input() {
        local input=$1
        if [[ ! $input =~ ^[a-zA-Z0-9_-]+$ ]]; then
            echo "Invalid input"
            return 1
        fi
    }
    
    # Secure file operations
    secure_write() {
        umask 077
        echo "secret data" > "$1"
    }
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    setup_error_handling
    enable_debugging
    optimize_performance
    parallel_processing
    named_pipe_demo
    network_operations
    secure_practices
}

main "$@"