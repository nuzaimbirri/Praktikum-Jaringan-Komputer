# Network Troubleshooting Guide

## Metodologi Troubleshooting

### Pendekatan Sistematis

1. **Identifikasi Masalah**
   - Kumpulkan informasi tentang gejala
   - Tentukan scope masalah (satu user, satu subnet, atau seluruh network)
   - Dokumentasikan timeline masalah

2. **Tentukan Teori Probable Cause**
   - Gunakan model OSI sebagai framework
   - Pertimbangkan perubahan recent
   - Review logs dan monitoring data

3. **Test Teori**
   - Isolasi masalah
   - Test dengan tools yang sesuai
   - Verifikasi hasil

4. **Buat Action Plan**
   - Tentukan langkah perbaikan
   - Identifikasi potential impact
   - Siapkan rollback plan

5. **Implement Solution**
   - Execute action plan
   - Monitor hasilnya
   - Dokumentasi perubahan

6. **Verify Full Functionality**
   - Test end-to-end connectivity
   - Verifikasi dengan user
   - Monitor untuk masalah lanjutan

7. **Document**
   - Catat root cause
   - Dokumentasi solution
   - Update knowledge base

## Troubleshooting Model OSI

### Layer 1 - Physical Layer

**Gejala:**
- No link light pada interface
- Intermittent connectivity
- Cable test failed

**Check:**
```bash
# Check interface status
show interfaces status
show interfaces GigabitEthernet 0/0

# Check cable (Cisco)
test cable-diagnostics tdr interface gi0/0
show cable-diagnostics tdr interface gi0/0

# Linux - check link status
ip link show
ethtool eth0
```

**Common Issues:**
- Kabel putus atau rusak
- Wrong cable type (straight vs crossover)
- Port disabled
- SFP module tidak kompatibel
- EMI (Electromagnetic Interference)

**Solutions:**
- Replace kabel
- Check kabel crimping
- Enable port: `no shutdown`
- Test dengan cable tester
- Check speed/duplex settings

### Layer 2 - Data Link Layer

**Gejala:**
- Devices tidak bisa communicate dalam same subnet
- MAC address table tidak complete
- Broadcast storm
- VLAN miscommunication

**Check:**
```bash
# Show MAC address table
show mac address-table
show mac address-table interface gi0/1
show mac address-table vlan 10

# Check VLAN configuration
show vlan brief
show interfaces trunk

# Check spanning-tree
show spanning-tree
show spanning-tree vlan 10

# Check interface errors
show interfaces counters errors
```

**Common Issues:**
- VLAN mismatch
- Trunk misconfiguration
- Spanning-tree loop
- MAC address table overflow
- Duplex mismatch

**Solutions:**
```bash
# Fix VLAN assignment
interface FastEthernet 0/1
 switchport access vlan 10

# Fix trunk configuration
interface GigabitEthernet 0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30

# Enable portfast (access ports only)
interface FastEthernet 0/1
 spanning-tree portfast

# Fix duplex mismatch
interface GigabitEthernet 0/1
 duplex full
 speed 1000
```

### Layer 3 - Network Layer

**Gejala:**
- Can't ping remote network
- Routing loops
- Packet loss
- Can ping by IP but not by name

**Check:**
```bash
# Check IP configuration
show ip interface brief
ip addr show
ifconfig

# Check routing table
show ip route
ip route show
route -n

# Test connectivity
ping <ip-address>
ping -c 4 <ip-address>  # Linux

# Trace route
traceroute <ip-address>
tracert <ip-address>  # Windows

# Check ARP
show arp
ip neigh show
arp -a
```

**Common Issues:**
- Wrong IP configuration
- Subnet mask error
- Missing or wrong default gateway
- Routing loop
- Missing route
- TTL exceeded

**Solutions:**
```bash
# Configure correct IP (Cisco)
interface GigabitEthernet 0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown

# Add static route
ip route 192.168.2.0 255.255.255.0 10.0.0.2

# Set default route
ip route 0.0.0.0 0.0.0.0 10.0.0.1

# Linux - set IP
sudo ip addr add 192.168.1.10/24 dev eth0
sudo ip route add default via 192.168.1.1
```

### Layer 4 - Transport Layer

**Gejala:**
- Application timeout
- Connection refused
- Port not listening
- High latency

**Check:**
```bash
# Check open ports
netstat -tuln
ss -tuln
show control-plane host open-ports

# Check connections
netstat -an
ss -tan

# Test specific port
telnet <ip> <port>
nc -zv <ip> <port>  # netcat

# Check firewall
show ip access-lists
iptables -L -n  # Linux
```

**Common Issues:**
- Port blocked by firewall
- Service not running
- ACL blocking traffic
- NAT configuration error

**Solutions:**
```bash
# Cisco ACL - permit traffic
access-list 100 permit tcp any host 192.168.1.10 eq 80
interface GigabitEthernet 0/0
 ip access-group 100 in

# Linux firewall
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo ufw allow 80/tcp

# Start service
sudo systemctl start nginx
sudo service apache2 start
```

### Layer 5-7 - Application Layer

**Gejala:**
- Application-specific errors
- DNS resolution failed
- HTTP errors (404, 503)
- Authentication failed

**Check:**
```bash
# DNS resolution
nslookup google.com
dig google.com
host google.com

# HTTP testing
curl -I http://example.com
wget --spider http://example.com

# Check DNS configuration
cat /etc/resolv.conf
ipconfig /all  # Windows

# Application logs
tail -f /var/log/apache2/error.log
tail -f /var/log/nginx/error.log
```

**Common Issues:**
- DNS server unreachable
- DNS misconfiguration
- Web server misconfiguration
- Certificate errors
- Authentication issues

**Solutions:**
```bash
# Fix DNS (Linux)
sudo nano /etc/resolv.conf
# Add: nameserver 8.8.8.8

# Windows DNS
ipconfig /flushdns

# Test with different DNS
nslookup google.com 8.8.8.8
```

## Common Network Problems

### Problem 1: No Internet Connectivity

**Systematic Approach:**

```bash
# Step 1: Check local IP configuration
ipconfig /all  # Windows
ip addr show   # Linux

# Step 2: Ping default gateway
ping 192.168.1.1

# Step 3: Ping external IP (bypass DNS)
ping 8.8.8.8

# Step 4: Test DNS
nslookup google.com

# Step 5: Traceroute
tracert google.com  # Windows
traceroute google.com  # Linux
```

**Diagnosis:**
- ✅ Gateway ping OK, ❌ External ping FAIL → Router/ISP issue
- ✅ External IP OK, ❌ DNS FAIL → DNS configuration issue
- ❌ Gateway ping FAIL → Local network issue

### Problem 2: Slow Network Performance

**Diagnostic Steps:**

```bash
# Check interface errors
show interfaces
show interfaces counters errors

# Check bandwidth utilization
show interfaces statistics

# Check for broadcast storms
show interfaces | include broadcast

# Test throughput
iperf -s  # Server
iperf -c <server-ip>  # Client

# Check latency
ping -c 100 <destination>

# Check packet loss
ping -c 100 -i 0.2 <destination>
```

**Common Causes:**
- Duplex mismatch
- High bandwidth utilization
- Broadcast storms
- Network congestion
- MTU mismatch
- QoS misconfiguration

### Problem 3: Intermittent Connectivity

**Diagnostic Steps:**

```bash
# Continuous ping test
ping -t <destination>  # Windows
ping <destination>  # Linux (Ctrl+C to stop)

# Monitor interface
show interfaces | include drops|errors|collisions

# Check spanning-tree for flapping
show spanning-tree inconsistentports

# Monitor logs
show logging
terminal monitor
```

**Common Causes:**
- Loose cable connection
- Faulty hardware
- Spanning-tree reconvergence
- Wireless interference
- Power issues

### Problem 4: VLAN Communication Issues

**Diagnostic Steps:**

```bash
# Verify VLAN existence
show vlan brief

# Check port VLAN assignment
show interfaces switchport

# Check trunk configuration
show interfaces trunk

# Verify routing between VLANs
show ip route

# Test inter-VLAN routing
ping <ip-in-different-vlan>
```

**Common Causes:**
- VLAN not created
- Port not assigned to correct VLAN
- Trunk not allowing VLAN
- Missing inter-VLAN routing
- ACL blocking traffic

### Problem 5: DHCP Issues

**Diagnostic Steps:**

```bash
# Check DHCP server status
show ip dhcp binding
show ip dhcp pool

# Release/renew IP
ipconfig /release  # Windows
ipconfig /renew
sudo dhclient -r  # Linux
sudo dhclient

# Check DHCP snooping
show ip dhcp snooping
show ip dhcp snooping binding

# Test DHCP manually
sudo dhcping -s <dhcp-server-ip>
```

**Common Causes:**
- DHCP server down
- IP address pool exhausted
- DHCP snooping blocking requests
- Rogue DHCP server
- Relay agent misconfiguration

## Essential Troubleshooting Commands

### Cisco IOS

```bash
# Interface status
show ip interface brief
show interfaces status
show interfaces <interface>

# Routing
show ip route
show ip protocols
show ip route summary

# CDP/LLDP neighbors
show cdp neighbors detail
show lldp neighbors detail

# Logs
show logging
show logging last 50

# Version and hardware
show version
show inventory

# CPU and memory
show processes cpu sorted
show memory statistics

# Enable debug (use with caution)
debug ip icmp
debug ip packet
undebug all  # Disable all debugs
```

### Linux

```bash
# Network configuration
ip addr show
ip link show
ip route show

# Connectivity testing
ping -c 4 <ip>
traceroute <ip>
mtr <ip>  # Better than traceroute

# DNS
nslookup <domain>
dig <domain>
host <domain>

# Ports and connections
ss -tuln  # Listening ports
ss -tan   # All TCP connections
netstat -an

# Packet capture
tcpdump -i eth0
tcpdump -i eth0 host 192.168.1.10
tcpdump -i eth0 port 80

# Network statistics
ip -s link show
netstat -s
ss -s

# Firewall
iptables -L -n -v
ufw status
```

### Windows

```cmd
:: IP configuration
ipconfig /all
ipconfig /release
ipconfig /renew
ipconfig /flushdns

:: Connectivity
ping <ip>
tracert <domain>
pathping <domain>

:: Ports and connections
netstat -an
netstat -b  :: Shows programs

:: DNS
nslookup <domain>

:: Network statistics
netstat -s
netstat -e

:: Route table
route print
route add <network> mask <netmask> <gateway>

:: ARP
arp -a
arp -d  :: Clear ARP cache
```

## Best Practices

### 1. Document Everything
- Keep network diagrams updated
- Document configurations
- Maintain change log
- Keep IP address spreadsheet

### 2. Establish Baseline
- Normal bandwidth utilization
- Typical CPU/memory usage
- Average response times
- Regular connection counts

### 3. Use Monitoring Tools
- SNMP monitoring
- Syslog server
- NetFlow/sFlow
- MRTG/Cacti/Nagios

### 4. Regular Maintenance
- Update firmware/software
- Check hardware health
- Review logs regularly
- Clean up configurations

### 5. Have Backup Plans
- Backup configurations regularly
- Keep spare hardware
- Document recovery procedures
- Test disaster recovery

## Troubleshooting Tools

### Network Scanners
- **nmap**: Port scanning and network discovery
- **Angry IP Scanner**: Simple IP scanner
- **Advanced IP Scanner**: Windows IP scanner

### Packet Analyzers
- **Wireshark**: GUI packet analyzer
- **tcpdump**: Command-line packet capture
- **tshark**: Command-line Wireshark

### Performance Testing
- **iperf/iperf3**: Bandwidth testing
- **hping3**: TCP/IP packet assembler/analyzer
- **netperf**: Network performance benchmark

### DNS Tools
- **dig**: DNS lookup tool
- **nslookup**: Name server lookup
- **dnstracer**: Trace DNS queries

### Web Testing
- **curl**: Transfer data with URLs
- **wget**: Network downloader
- **ab**: Apache HTTP server benchmarking

## Emergency Response Checklist

### Network Down Emergency

- [ ] Check physical layer (lights, cables)
- [ ] Verify power to network devices
- [ ] Check core switches/routers status
- [ ] Review recent changes
- [ ] Check monitoring alerts
- [ ] Test connectivity from multiple points
- [ ] Check with ISP if external issue
- [ ] Implement workaround if possible
- [ ] Communicate with stakeholders
- [ ] Document incident

### Security Incident

- [ ] Isolate affected systems
- [ ] Document everything
- [ ] Preserve evidence
- [ ] Check logs for indicators
- [ ] Scan for malware
- [ ] Change passwords
- [ ] Notify security team/management
- [ ] Apply patches/updates
- [ ] Monitor for reoccurrence
- [ ] Post-incident review

## Referensi

- Cisco Troubleshooting Guide
- CompTIA Network+ Study Guide
- TCP/IP Illustrated
- Wireshark Network Analysis
- RFC 1122: Requirements for Internet Hosts

---

**Remember:** Systematic approach adalah kunci successful troubleshooting!
