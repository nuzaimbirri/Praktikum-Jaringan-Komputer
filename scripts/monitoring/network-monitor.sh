#!/bin/bash

###############################################################################
# Network Monitoring Script
# Purpose: Monitor network interfaces, bandwidth, and connections
# Usage: ./network-monitor.sh [interval_seconds]
###############################################################################

# Default monitoring interval (seconds)
INTERVAL=${1:-5}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to clear screen
clear_screen() {
    clear
}

# Function to print header
print_header() {
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Network Monitoring Dashboard                        ║${NC}"
    printf "${GREEN}║           %-51s║${NC}\n" "$datetime"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to display interface statistics
show_interface_stats() {
    echo -e "${YELLOW}=== Network Interfaces ===${NC}"
    echo ""
    
    if command -v ip &> /dev/null; then
        ip -s link show | grep -E "^[0-9]|RX:|TX:" | head -20
    else
        ifconfig | grep -E "^[a-z]|RX |TX "
    fi
    
    echo ""
}

# Function to display bandwidth usage
show_bandwidth() {
    echo -e "${YELLOW}=== Bandwidth Usage ===${NC}"
    echo ""
    
    if command -v vnstat &> /dev/null; then
        vnstat -l 1
    else
        echo "vnstat not installed. Install with: sudo apt-get install vnstat"
        echo ""
        echo "Current network statistics:"
        if command -v ip &> /dev/null; then
            ip -s link show | grep -E "^[0-9]|RX:|TX:"
        else
            cat /proc/net/dev | grep -v "lo:" | grep ":" | awk '{print $1, "RX:", $2, "bytes, TX:", $10, "bytes"}'
        fi
    fi
    
    echo ""
}

# Function to display active connections
show_connections() {
    echo -e "${YELLOW}=== Active Network Connections ===${NC}"
    echo ""
    
    if command -v ss &> /dev/null; then
        echo "TCP Connections:"
        ss -tn | head -10
        echo ""
        echo "UDP Connections:"
        ss -un | head -10
    else
        echo "TCP Connections:"
        netstat -tn | head -10
        echo ""
        echo "UDP Connections:"
        netstat -un | head -10
    fi
    
    echo ""
}

# Function to display listening ports
show_listening_ports() {
    echo -e "${YELLOW}=== Listening Ports ===${NC}"
    echo ""
    
    if command -v ss &> /dev/null; then
        ss -tuln | grep LISTEN | head -15
    else
        netstat -tuln | grep LISTEN | head -15
    fi
    
    echo ""
}

# Function to display connection statistics
show_connection_stats() {
    echo -e "${YELLOW}=== Connection Statistics ===${NC}"
    echo ""
    
    if command -v ss &> /dev/null; then
        echo "TCP States:"
        ss -tan | awk '{print $1}' | sort | uniq -c | sort -rn
    else
        echo "TCP States:"
        netstat -tan | awk '{print $6}' | sort | uniq -c | sort -rn
    fi
    
    echo ""
}

# Function to display routing table
show_routing_table() {
    echo -e "${YELLOW}=== Routing Table ===${NC}"
    echo ""
    
    if command -v ip &> /dev/null; then
        ip route show
    else
        route -n
    fi
    
    echo ""
}

# Function to display ARP table
show_arp_table() {
    echo -e "${YELLOW}=== ARP Table ===${NC}"
    echo ""
    
    if command -v ip &> /dev/null; then
        ip neigh show | head -10
    else
        arp -n | head -10
    fi
    
    echo ""
}

# Function to display DNS servers
show_dns_servers() {
    echo -e "${YELLOW}=== DNS Servers ===${NC}"
    echo ""
    
    if [ -f /etc/resolv.conf ]; then
        grep nameserver /etc/resolv.conf
    fi
    
    echo ""
}

# Function to display top bandwidth consumers
show_top_connections() {
    echo -e "${YELLOW}=== Top Network Connections by PID ===${NC}"
    echo ""
    
    if command -v nethogs &> /dev/null; then
        timeout 3 nethogs -t -d 1 2>/dev/null | head -20
    else
        echo "nethogs not installed. Install with: sudo apt-get install nethogs"
        echo ""
        if command -v lsof &> /dev/null; then
            echo "Open network connections:"
            lsof -i -n | head -15
        fi
    fi
    
    echo ""
}

# Function to perform continuous monitoring
continuous_monitor() {
    while true; do
        clear_screen
        print_header
        show_interface_stats
        show_connection_stats
        show_connections
        show_listening_ports
        
        echo -e "${BLUE}Press Ctrl+C to exit. Refreshing every ${INTERVAL} seconds...${NC}"
        sleep "$INTERVAL"
    done
}

# Function to show comprehensive report
show_full_report() {
    clear_screen
    print_header
    show_interface_stats
    show_bandwidth
    show_connections
    show_listening_ports
    show_connection_stats
    show_routing_table
    show_arp_table
    show_dns_servers
    show_top_connections
}

# Function to save report to file
save_report() {
    local filename="network-report-$(date +%Y%m%d-%H%M%S).txt"
    
    echo "Generating network report..."
    
    {
        echo "Network Monitoring Report"
        echo "Generated: $(date)"
        echo "=========================================="
        echo ""
        
        show_interface_stats
        show_bandwidth
        show_connections
        show_listening_ports
        show_connection_stats
        show_routing_table
        show_arp_table
        show_dns_servers
        
    } > "$filename"
    
    echo "Report saved to: $filename"
}

# Function to display menu
show_menu() {
    clear_screen
    print_header
    
    echo "Select monitoring mode:"
    echo ""
    echo "  1) Continuous monitoring (refresh every ${INTERVAL}s)"
    echo "  2) One-time full report"
    echo "  3) Save report to file"
    echo "  4) Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            continuous_monitor
            ;;
        2)
            show_full_report
            echo ""
            read -p "Press Enter to return to menu..."
            show_menu
            ;;
        3)
            save_report
            echo ""
            read -p "Press Enter to return to menu..."
            show_menu
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            show_menu
            ;;
    esac
}

# Function to check required commands
check_requirements() {
    local missing_cmds=()
    
    for cmd in ip ss grep awk; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_cmds+=("$cmd")
        fi
    done
    
    if [ ${#missing_cmds[@]} -gt 0 ]; then
        echo -e "${RED}Warning: The following commands are missing:${NC}"
        printf '%s\n' "${missing_cmds[@]}"
        echo ""
        echo "Some features may not work properly."
        echo ""
        read -p "Press Enter to continue anyway..."
    fi
}

# Main execution
main() {
    # Check if running with required privileges
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${YELLOW}Warning: Running without root privileges.${NC}"
        echo "Some features may require sudo."
        echo ""
        sleep 2
    fi
    
    # Check requirements
    check_requirements
    
    # If no arguments, show menu
    if [ $# -eq 0 ]; then
        show_menu
    else
        # Direct continuous monitoring with custom interval
        continuous_monitor
    fi
}

# Trap Ctrl+C
trap 'echo -e "\n${GREEN}Monitoring stopped.${NC}"; exit 0' INT

# Run main function
main "$@"
