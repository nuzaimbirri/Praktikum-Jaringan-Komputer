#!/bin/bash

###############################################################################
# Network Connectivity Test Script
# Purpose: Test network connectivity to various hosts and services
# Usage: ./connectivity-test.sh
###############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="connectivity-test-$(date +%Y%m%d-%H%M%S).log"

# Function to print with color
print_status() {
    local status=$1
    local message=$2
    
    if [ "$status" == "OK" ]; then
        echo -e "${GREEN}[OK]${NC} $message" | tee -a "$LOG_FILE"
    elif [ "$status" == "FAIL" ]; then
        echo -e "${RED}[FAIL]${NC} $message" | tee -a "$LOG_FILE"
    else
        echo -e "${YELLOW}[INFO]${NC} $message" | tee -a "$LOG_FILE"
    fi
}

# Function to test ping
test_ping() {
    local host=$1
    local description=$2
    
    echo -e "\n${YELLOW}Testing connectivity to $description ($host)...${NC}"
    
    if ping -c 4 -W 2 "$host" > /dev/null 2>&1; then
        print_status "OK" "Ping to $description ($host) successful"
        return 0
    else
        print_status "FAIL" "Ping to $description ($host) failed"
        return 1
    fi
}

# Function to test port
test_port() {
    local host=$1
    local port=$2
    local service=$3
    
    echo -e "\n${YELLOW}Testing $service on $host:$port...${NC}"
    
    if timeout 5 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
        print_status "OK" "$service on $host:$port is accessible"
        return 0
    else
        print_status "FAIL" "$service on $host:$port is not accessible"
        return 1
    fi
}

# Function to test DNS
test_dns() {
    local domain=$1
    
    echo -e "\n${YELLOW}Testing DNS resolution for $domain...${NC}"
    
    if command -v dig &> /dev/null; then
        local ip=$(dig +short "$domain" | head -n1)
        if [ -n "$ip" ]; then
            print_status "OK" "DNS resolution for $domain successful (IP: $ip)"
            return 0
        fi
    elif nslookup "$domain" > /dev/null 2>&1; then
        local ip=$(nslookup "$domain" | grep -A1 "Name:" | grep "Address:" | awk '{print $2}')
        print_status "OK" "DNS resolution for $domain successful (IP: $ip)"
        return 0
    fi
    
    print_status "FAIL" "DNS resolution for $domain failed"
    return 1
}

# Function to get network info
get_network_info() {
    echo -e "\n${YELLOW}=== Network Information ===${NC}" | tee -a "$LOG_FILE"
    
    echo -e "\n--- IP Configuration ---" | tee -a "$LOG_FILE"
    if command -v ip &> /dev/null; then
        ip addr show | tee -a "$LOG_FILE"
    else
        ifconfig | tee -a "$LOG_FILE"
    fi
    
    echo -e "\n--- Routing Table ---" | tee -a "$LOG_FILE"
    if command -v ip &> /dev/null; then
        ip route show | tee -a "$LOG_FILE"
    else
        route -n | tee -a "$LOG_FILE"
    fi
    
    echo -e "\n--- DNS Configuration ---" | tee -a "$LOG_FILE"
    cat /etc/resolv.conf | tee -a "$LOG_FILE"
}

# Main test execution
main() {
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Network Connectivity Test Script            ║${NC}"
    echo -e "${GREEN}║   $(date)                      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    
    echo -e "\nLog file: $LOG_FILE\n"
    
    # Get network information
    get_network_info
    
    # Test local gateway
    echo -e "\n${YELLOW}=== Testing Local Gateway ===${NC}"
    gateway=$(ip route | grep default | awk '{print $3}' | head -n1)
    if [ -n "$gateway" ]; then
        test_ping "$gateway" "Default Gateway"
    else
        print_status "FAIL" "No default gateway found"
    fi
    
    # Test local DNS
    echo -e "\n${YELLOW}=== Testing DNS Servers ===${NC}"
    test_ping "8.8.8.8" "Google DNS"
    test_ping "1.1.1.1" "Cloudflare DNS"
    
    # Test DNS resolution
    echo -e "\n${YELLOW}=== Testing DNS Resolution ===${NC}"
    test_dns "google.com"
    test_dns "github.com"
    test_dns "cloudflare.com"
    
    # Test external connectivity
    echo -e "\n${YELLOW}=== Testing External Connectivity ===${NC}"
    test_ping "google.com" "Google"
    test_ping "github.com" "GitHub"
    
    # Test common services
    echo -e "\n${YELLOW}=== Testing Common Services ===${NC}"
    test_port "google.com" 80 "HTTP"
    test_port "google.com" 443 "HTTPS"
    test_port "8.8.8.8" 53 "DNS"
    
    # Test local network hosts (customize as needed)
    echo -e "\n${YELLOW}=== Testing Local Network Hosts ===${NC}"
    # Add your local hosts here
    # test_ping "192.168.1.1" "Local Server"
    # test_port "192.168.1.100" 22 "SSH Server"
    
    # Summary
    echo -e "\n${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Test Summary                                 ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo -e "\nTest completed. Check $LOG_FILE for details."
    
    # Traceroute to a public host (optional)
    echo -e "\n${YELLOW}=== Traceroute to google.com ===${NC}"
    echo "This may take a moment..."
    traceroute -m 15 google.com | tee -a "$LOG_FILE"
    
    echo -e "\n${GREEN}Test completed successfully!${NC}"
}

# Check if running as root for some commands
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Warning: Some tests may require root privileges${NC}"
fi

# Run main function
main

exit 0
