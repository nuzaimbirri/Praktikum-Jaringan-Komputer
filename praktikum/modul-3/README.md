# Modul 3: Network Security dan Troubleshooting

## Tujuan Pembelajaran

Setelah menyelesaikan modul ini, mahasiswa diharapkan dapat:
1. Memahami konsep network security
2. Mengkonfigurasi firewall dan ACL
3. Implementasi NAT/PAT
4. Melakukan network monitoring
5. Troubleshooting masalah jaringan

## Materi

### 1. Network Security Fundamentals

**Prinsip Security (CIA Triad):**
1. **Confidentiality**: Melindungi data dari akses tidak sah
2. **Integrity**: Memastikan data tidak dimodifikasi
3. **Availability**: Memastikan layanan dapat diakses

**Ancaman Jaringan:**
- Malware (virus, worm, trojan)
- DDoS attacks
- Man-in-the-middle attacks
- Phishing
- SQL injection
- Unauthorized access

### 2. Access Control List (ACL)

**Jenis ACL:**

**Standard ACL:**
- Filter berdasarkan source IP
- Nomor: 1-99, 1300-1999

**Extended ACL:**
- Filter berdasarkan source, destination, protocol, port
- Nomor: 100-199, 2000-2699

**ACL Processing:**
1. Top-down processing
2. Implicit deny di akhir
3. Hanya satu ACL per interface per direction

### 3. NAT (Network Address Translation)

**Jenis NAT:**
1. **Static NAT**: 1-to-1 mapping
2. **Dynamic NAT**: Pool of public IPs
3. **PAT (Port Address Translation)**: Many-to-1 with different ports

### 4. Firewall

**Jenis Firewall:**
1. **Packet Filtering**: Layer 3-4
2. **Stateful Inspection**: Track connection state
3. **Application Layer**: Layer 7 inspection

## Latihan Praktikum

### Latihan 1: Standard ACL

**Scenario:**
Block network 192.168.2.0/24 dari mengakses 192.168.1.0/24.

**Konfigurasi:**
```
Router(config)# access-list 10 deny 192.168.2.0 0.0.0.255
Router(config)# access-list 10 permit any

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip access-group 10 in
```

**Verifikasi:**
```
Router# show access-lists
Router# show ip interface gigabitEthernet 0/0
```

### Latihan 2: Extended ACL

**Scenario:**
1. Block HTTP traffic dari 192.168.1.10 ke web server 10.0.0.100
2. Allow semua traffic lainnya

**Konfigurasi:**
```
Router(config)# access-list 100 deny tcp host 192.168.1.10 host 10.0.0.100 eq 80
Router(config)# access-list 100 deny tcp host 192.168.1.10 host 10.0.0.100 eq 443
Router(config)# access-list 100 permit ip any any

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip access-group 100 in
```

**Named ACL:**
```
Router(config)# ip access-list extended BLOCK-WEB
Router(config-ext-nacl)# deny tcp host 192.168.1.10 host 10.0.0.100 eq 80
Router(config-ext-nacl)# deny tcp host 192.168.1.10 host 10.0.0.100 eq 443
Router(config-ext-nacl)# permit ip any any
Router(config-ext-nacl)# exit

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip access-group BLOCK-WEB in
```

### Latihan 3: NAT Configuration

**Static NAT:**
```
Router(config)# ip nat inside source static 192.168.1.10 203.0.113.10

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip nat inside
Router(config-if)# exit

Router(config)# interface gigabitEthernet 0/1
Router(config-if)# ip nat outside
```

**Dynamic NAT:**
```
Router(config)# ip nat pool PUBLIC-POOL 203.0.113.10 203.0.113.20 netmask 255.255.255.0
Router(config)# access-list 1 permit 192.168.1.0 0.0.0.255
Router(config)# ip nat inside source list 1 pool PUBLIC-POOL

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip nat inside
Router(config-if)# exit

Router(config)# interface gigabitEthernet 0/1
Router(config-if)# ip nat outside
```

**PAT (NAT Overload):**
```
Router(config)# access-list 1 permit 192.168.1.0 0.0.0.255
Router(config)# ip nat inside source list 1 interface gigabitEthernet 0/1 overload

Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip nat inside
Router(config-if)# exit

Router(config)# interface gigabitEthernet 0/1
Router(config-if)# ip nat outside
```

**Verifikasi NAT:**
```
Router# show ip nat translations
Router# show ip nat statistics
Router# clear ip nat translation *
```

### Latihan 4: Port Security

**Scenario:**
Batasi MAC address yang bisa terhubung ke switch port.

**Konfigurasi:**
```
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport port-security
Switch(config-if)# switchport port-security maximum 2
Switch(config-if)# switchport port-security mac-address sticky
Switch(config-if)# switchport port-security violation shutdown
```

**Violation Actions:**
- **protect**: drop packets, no notification
- **restrict**: drop packets, send SNMP trap
- **shutdown**: disable port (err-disabled)

**Verifikasi:**
```
Switch# show port-security interface fastEthernet 0/1
Switch# show port-security address
```

**Recovery dari err-disabled:**
```
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# shutdown
Switch(config-if)# no shutdown
```

### Latihan 5: DHCP Snooping

**Konfigurasi:**
```
Switch(config)# ip dhcp snooping
Switch(config)# ip dhcp snooping vlan 10,20,30

# Trust port (port yang terhubung ke DHCP server)
Switch(config)# interface gigabitEthernet 0/1
Switch(config-if)# ip dhcp snooping trust
Switch(config-if)# exit

# Rate limit pada untrusted ports
Switch(config)# interface range fastEthernet 0/1-24
Switch(config-if-range)# ip dhcp snooping limit rate 10
```

**Verifikasi:**
```
Switch# show ip dhcp snooping
Switch# show ip dhcp snooping binding
```

## Network Troubleshooting

### Metodologi Troubleshooting

**OSI Model Approach:**
1. **Bottom-Up**: Physical → Data Link → Network → ...
2. **Top-Down**: Application → Presentation → Session → ...
3. **Divide and Conquer**: Start from middle layer

### Troubleshooting Commands

**Layer 1 (Physical):**
```
# Check interface status
show interfaces
show controllers
show cable diagnostics tdr interface gi0/0

# Linux
ethtool eth0
```

**Layer 2 (Data Link):**
```
# Switch commands
show mac address-table
show spanning-tree
show cdp neighbors

# ARP issues
show arp
clear arp-cache
```

**Layer 3 (Network):**
```
# Router commands
show ip route
show ip interface brief
ping <ip>
traceroute <ip>

# Linux
ip route show
ip addr show
ping -c 4 <ip>
traceroute <ip>
```

**Layer 4 (Transport):**
```
# Check ports
netstat -an
netstat -tupln  # Linux

# Test specific port
telnet <ip> <port>
```

**Layer 7 (Application):**
```
# DNS
nslookup <domain>
dig <domain>

# HTTP
curl -I http://example.com
wget http://example.com
```

### Common Issues dan Solutions

**1. No Connectivity**
```
Problem: PC tidak bisa ping gateway

Troubleshooting:
1. Check kabel dan LED link
2. Verify IP configuration
   - ipconfig /all (Windows)
   - ip addr show (Linux)
3. Check subnet mask
4. Verify gateway dalam same subnet
5. Check interface status di router
```

**2. DNS Issues**
```
Problem: Bisa ping IP tapi tidak bisa resolve domain

Troubleshooting:
1. Check DNS server configuration
   - ipconfig /all
2. Test DNS resolution
   - nslookup google.com
3. Try different DNS server (8.8.8.8)
4. Check firewall rules untuk DNS (port 53)
```

**3. Slow Network**
```
Problem: Network lambat

Troubleshooting:
1. Check bandwidth utilization
   - show interface statistics
2. Look for errors/collisions
   - show interface
3. Check for broadcast storm
   - show interface | include broadcast
4. Verify duplex settings
   - show interface status
```

**4. VLAN Issues**
```
Problem: Tidak bisa komunikasi antar VLAN

Troubleshooting:
1. Verify VLAN configuration
   - show vlan brief
2. Check trunk configuration
   - show interfaces trunk
3. Verify router-on-a-stick config
4. Check sub-interface encapsulation
```

### Packet Capture dengan Wireshark

**Capture Filters:**
```
# Capture hanya traffic dari/ke host tertentu
host 192.168.1.10

# Capture hanya HTTP
port 80

# Capture traffic antara dua host
host 192.168.1.10 and host 192.168.1.20
```

**Display Filters:**
```
# Filter by protocol
tcp
udp
icmp
dns
http

# Filter by IP
ip.addr == 192.168.1.10
ip.src == 192.168.1.10
ip.dst == 192.168.1.20

# Filter by port
tcp.port == 80
tcp.dstport == 443
```

## Tugas Praktikum

### Tugas 1: Security Implementation

**Scenario:**
Implementasikan security untuk network perusahaan.

**Requirements:**
1. Konfigurasi ACL untuk:
   - Block internal network dari mengakses management VLAN
   - Allow hanya HTTP/HTTPS ke internet
   - Block social media sites

2. Implementasi NAT:
   - PAT untuk semua internal users
   - Static NAT untuk web server

3. Port Security:
   - Maximum 2 MAC per port
   - Sticky MAC learning
   - Shutdown violation

### Tugas 2: Network Monitoring

**Scenario:**
Setup monitoring untuk network.

**Requirements:**
1. Capture dan analisis traffic untuk:
   - Web browsing
   - Email
   - File transfer

2. Identifikasi:
   - Top talkers
   - Protocol distribution
   - Potential security issues

3. Dokumentasi:
   - Screenshot Wireshark captures
   - Analisis traffic patterns

### Tugas 3: Troubleshooting Exercise

**Scenario:**
Diberikan network dengan beberapa masalah.

**Requirements:**
1. Identifikasi semua masalah
2. Dokumentasi troubleshooting process
3. Implement solutions
4. Verify connectivity end-to-end

## Security Best Practices

1. **Access Control:**
   - Implement ACLs
   - Use strong authentication
   - Principle of least privilege

2. **Network Segmentation:**
   - Separate VLANs per department
   - Isolate critical systems
   - DMZ untuk public servers

3. **Monitoring:**
   - Enable logging
   - Monitor unusual traffic
   - Regular security audits

4. **Updates:**
   - Keep systems patched
   - Update firmware regularly
   - Review security advisories

5. **Documentation:**
   - Document network topology
   - Maintain configuration backups
   - Change management process

## Kriteria Penilaian

1. **Security Configuration (35%)**
   - ACL implementation
   - NAT configuration
   - Port security

2. **Troubleshooting (30%)**
   - Problem identification
   - Systematic approach
   - Correct solutions

3. **Monitoring & Analysis (20%)**
   - Packet capture
   - Traffic analysis
   - Security assessment

4. **Documentation (15%)**
   - Complete report
   - Clear diagrams
   - Test results

## Referensi

1. Network Security Essentials - William Stallings
2. Cisco ASA: All-in-One Firewall
3. Wireshark Network Analysis - Laura Chappell
4. CCNA Security Study Guide

---

**Stay Secure!** 🔒
