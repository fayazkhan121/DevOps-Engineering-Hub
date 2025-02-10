#!/bin/bash

# File: 07_system_administration.sh
# Purpose: System administration tasks automation
# Usage: ./07_system_administration.sh
# Note: Requires root privileges for many operations

###########################################
# 1. LOG MANAGEMENT
###########################################
log_management() {
    # Rotate logs
    logrotate_config() {
        cat > /etc/logrotate.d/custom << EOF
/var/log/custom/*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
}
EOF
    }
    
    # Log monitoring
    monitor_logs() {
        tail -f /var/log/syslog | while read line; do
            if [[ $line =~ "ERROR" ]]; then
                echo "[ALERT] Error detected: $line" >> /var/log/alerts.log
            fi
        done
    }
}

###########################################
# 2. BACKUP SCRIPTS
###########################################
backup_system() {
    # Configuration backup
    backup_config() {
        tar -czf /backup/config_$(date +%Y%m%d).tar.gz /etc/
    }
    
    # Database backup
    backup_database() {
        mysqldump -u root -p'${DB_PASSWORD}' --all-databases > \
            /backup/db_$(date +%Y%m%d).sql
    }
    
    # Incremental backup using rsync
    incremental_backup() {
        rsync -avz --link-dest=/backup/last / /backup/current/
        mv /backup/current /backup/last
    }
}

###########################################
# 3. SYSTEM MONITORING
###########################################
system_monitoring() {
    # Resource usage
    check_resources() {
        echo "CPU Usage:"
        top -bn1 | grep "Cpu(s)"
        echo "Memory Usage:"
        free -m
        echo "Disk Usage:"
        df -h
    }
    
    # Process monitoring
    monitor_processes() {
        ps aux --sort=-%cpu | head -n 5
    }
    
    # Network monitoring
    monitor_network() {
        netstat -tuln
        iftop -t -s 5 2>/dev/null
    }
}

###########################################
# 4. USER MANAGEMENT
###########################################
user_management() {
    # Create user with home directory
    create_user() {
        useradd -m -s /bin/bash "$1"
        echo "$1:$2" | chpasswd
    }
    
    # Add user to groups
    add_to_groups() {
        usermod -aG sudo,docker "$1"
    }
    
    # Audit user activities
    audit_users() {
        last | head -n 10
        who
        w
    }
}

###########################################
# 5. SERVICE CONTROL
###########################################
service_management() {
    # Start/Stop services
    manage_service() {
        systemctl "${1}" "${2}"
    }
    
    # Monitor service status
    check_service() {
        systemctl status "${1}"
    }
    
    # Enable/disable on boot
    boot_config() {
        systemctl "${1}" "${2}"
    }
}

###########################################
# 6. SECURITY HARDENING
###########################################
security_hardening() {
    # Firewall configuration
    configure_firewall() {
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw allow http
        ufw allow https
        ufw enable
    }
    
    # SSH hardening
    harden_ssh() {
        cat > /etc/ssh/sshd_config.d/hardening.conf << EOF
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
MaxAuthTries 3
EOF
        systemctl restart sshd
    }
}

###########################################
# 7. PERFORMANCE TUNING
###########################################
performance_tuning() {
    # System limits
    configure_limits() {
        cat > /etc/security/limits.d/custom.conf << EOF
* soft nofile 65535
* hard nofile 65535
EOF
    }
    
    # Kernel parameters
    tune_kernel() {
        cat > /etc/sysctl.d/99-custom.conf << EOF
net.ipv4.tcp_fin_timeout = 15
net.core.somaxconn = 4096
EOF
        sysctl -p
    }
}

###########################################
# 8. DISK MANAGEMENT
###########################################
disk_management() {
    # Partition management
    manage_partitions() {
        fdisk -l
        parted -l
    }
    
    # LVM operations
    lvm_operations() {
        pvdisplay
        vgdisplay
        lvdisplay
    }
    
    # RAID management
    raid_status() {
        cat /proc/mdstat
        mdadm --detail /dev/md0
    }
}

###########################################
# MAIN EXECUTION
###########################################
main() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
    
    log_management
    backup_system
    system_monitoring
    user_management
    service_management
    security_hardening
    performance_tuning
    disk_management
}

main "$@"