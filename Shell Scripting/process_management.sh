#!/bin/bash

# File: process_management.sh
# Purpose: Process management, job control, and daemon operations
# Usage: ./process_management.sh
# Note: Some operations require root privileges

###########################################
# 1. BACKGROUND PROCESSES
###########################################
manage_background_processes() {
    # Start process in background
    sleep 100 &
    bg_pid=$!
    echo "Background process PID: $bg_pid"
    
    # List background jobs
    jobs
    
    # Bring to foreground
    fg %1 2>/dev/null
    
    # Kill background process
    kill $bg_pid 2>/dev/null
}

###########################################
# 2. JOB CONTROL
###########################################
demonstrate_job_control() {
    # Start multiple processes
    sleep 100 &
    sleep 200 &
    
    # List all jobs
    jobs
    
    # Suspend/Resume jobs
    kill -STOP %1
    echo "Job 1 stopped"
    kill -CONT %1
    echo "Job 1 continued"
    
    # Clean up
    killall sleep 2>/dev/null
}

###########################################
# 3. PROCESS IDS
###########################################
process_info() {
    # Current process
    echo "Current script PID: $$"
    
    # Parent process
    echo "Parent PID: $PPID"
    
    # List all processes for current user
    ps -u $USER
    
    # Process tree
    pstree -p $$ 2>/dev/null
}

###########################################
# 4. SIGNAL HANDLING
###########################################
setup_signal_handlers() {
    # Trap SIGINT (Ctrl+C)
    trap 'echo "SIGINT caught"; cleanup' SIGINT
    
    # Trap SIGTERM
    trap 'echo "SIGTERM caught"; cleanup' SIGTERM
    
    # Trap EXIT
    trap cleanup EXIT
}

cleanup() {
    echo "Cleaning up..."
    # Add cleanup operations here
}

###########################################
# 5. DAEMON PROCESSES
###########################################
create_daemon() {
    # Example daemon process
    cat > daemon.sh << 'EOF'
#!/bin/bash
while true; do
    echo "Daemon running at $(date)" >> daemon.log
    sleep 60
done
EOF
    chmod +x daemon.sh
    
    # Start daemon
    ./daemon.sh &
    daemon_pid=$!
    
    # Write PID file
    echo $daemon_pid > daemon.pid
}

###########################################
# 6. CRON JOBS
###########################################
setup_cron_jobs() {
    # Create cron job (runs every hour)
    cron_job="0 * * * * /path/to/script.sh"
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
    
    # List cron jobs
    crontab -l
}

###########################################
# 7. PROCESS PRIORITY
###########################################
manage_priority() {
    # Start process with nice
    nice -n 10 sleep 100 &
    nice_pid=$!
    
    # Change priority with renice
    renice -n 15 -p $nice_pid
    
    # Show process priority
    ps -o pid,nice,cmd -p $nice_pid
    
    # Clean up
    kill $nice_pid
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    echo "=== Process Management Demo ==="
    
    setup_signal_handlers
    manage_background_processes
    demonstrate_job_control
    process_info
    create_daemon
    setup_cron_jobs
    manage_priority
    
    echo "Demo completed"
}

main "$@"