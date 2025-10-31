# TCP/IP Protocol Suite

## Pendahuluan

TCP/IP (Transmission Control Protocol/Internet Protocol) adalah sekumpulan protokol yang digunakan untuk komunikasi data dalam jaringan komputer, terutama Internet.

## Arsitektur TCP/IP

### 1. Network Access Layer (Link Layer)

**Fungsi:**
- Menangani transmisi data pada media fisik
- Mengatur akses ke media transmisi
- Deteksi dan koreksi error pada level fisik

**Protokol:**
- Ethernet
- Wi-Fi (802.11)
- PPP (Point-to-Point Protocol)
- ARP (Address Resolution Protocol)

**Contoh Implementasi:**
```
Interface: eth0
MAC Address: 00:1A:2B:3C:4D:5E
Type: Ethernet
Speed: 1000 Mbps
```

### 2. Internet Layer

**Fungsi:**
- Routing paket data
- Addressing (IP addressing)
- Fragmentasi dan reassembly paket

**Protokol Utama:**

#### IP (Internet Protocol)
- Connectionless protocol
- Best-effort delivery
- Tidak menjamin pengiriman

**IP Header Format:**
```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version|  IHL  |Type of Service|          Total Length         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Identification        |Flags|      Fragment Offset    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Time to Live |    Protocol   |         Header Checksum       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       Source Address                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Destination Address                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

#### ICMP (Internet Control Message Protocol)
- Digunakan untuk diagnostic dan error reporting
- Contoh: ping, traceroute

**ICMP Message Types:**
- Type 0: Echo Reply
- Type 3: Destination Unreachable
- Type 8: Echo Request
- Type 11: Time Exceeded

### 3. Transport Layer

**Fungsi:**
- Komunikasi end-to-end
- Segmentasi dan reassembly data
- Flow control dan error control

#### TCP (Transmission Control Protocol)

**Karakteristik:**
- Connection-oriented
- Reliable delivery
- Flow control
- Congestion control
- Ordered data transfer

**TCP Header:**
```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                        Sequence Number                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Acknowledgment Number                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Data |           |U|A|P|R|S|F|                               |
| Offset| Reserved  |R|C|S|S|Y|I|            Window             |
|       |           |G|K|H|T|N|N|                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

**TCP Three-Way Handshake:**
```
Client                    Server
  |                          |
  |  SYN (seq=x)             |
  |------------------------->|
  |                          |
  |  SYN-ACK (seq=y, ack=x+1)|
  |<-------------------------|
  |                          |
  |  ACK (ack=y+1)           |
  |------------------------->|
  |                          |
  |  Connection Established  |
```

**TCP Connection Termination:**
```
Client                    Server
  |                          |
  |  FIN                     |
  |------------------------->|
  |                          |
  |  ACK                     |
  |<-------------------------|
  |                          |
  |  FIN                     |
  |<-------------------------|
  |                          |
  |  ACK                     |
  |------------------------->|
  |                          |
```

#### UDP (User Datagram Protocol)

**Karakteristik:**
- Connectionless
- Unreliable (no acknowledgment)
- Faster than TCP
- Minimal overhead

**UDP Header:**
```
 0      7 8     15 16    23 24    31
+--------+--------+--------+--------+
|     Source      |   Destination   |
|      Port       |      Port       |
+--------+--------+--------+--------+
|                 |                 |
|     Length      |    Checksum     |
+--------+--------+--------+--------+
```

**Kapan Menggunakan UDP:**
- Streaming video/audio
- Online gaming
- DNS queries
- VoIP
- Broadcast/multicast

### 4. Application Layer

**Protokol Populer:**

#### HTTP (Hypertext Transfer Protocol)
- Port: 80 (HTTP), 443 (HTTPS)
- Request-response protocol
- Stateless

**HTTP Request:**
```
GET /index.html HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
```

**HTTP Response:**
```
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234

<html>...</html>
```

#### DNS (Domain Name System)
- Port: 53
- Translates domain names to IP addresses

**DNS Query Example:**
```
Query: www.example.com
Response: 93.184.216.34
```

#### FTP (File Transfer Protocol)
- Port: 21 (control), 20 (data)
- File transfer between client and server

#### SMTP (Simple Mail Transfer Protocol)
- Port: 25
- Email transmission

#### SSH (Secure Shell)
- Port: 22
- Secure remote access

## IP Addressing dan Subnetting

### IP Address Classes

**Class A:**
- Range: 1.0.0.0 - 126.255.255.255
- Default Mask: 255.0.0.0 (/8)
- Networks: 126
- Hosts per network: 16,777,214

**Class B:**
- Range: 128.0.0.0 - 191.255.255.255
- Default Mask: 255.255.0.0 (/16)
- Networks: 16,384
- Hosts per network: 65,534

**Class C:**
- Range: 192.0.0.0 - 223.255.255.255
- Default Mask: 255.255.255.0 (/24)
- Networks: 2,097,152
- Hosts per network: 254

### Private IP Addresses

- Class A: 10.0.0.0/8
- Class B: 172.16.0.0/12
- Class C: 192.168.0.0/16

### Subnetting Example

**Network:** 192.168.1.0/24

**Subnetting menjadi 4 subnet:**
- Subnet 1: 192.168.1.0/26 (192.168.1.1-62)
- Subnet 2: 192.168.1.64/26 (192.168.1.65-126)
- Subnet 3: 192.168.1.128/26 (192.168.1.129-190)
- Subnet 4: 192.168.1.192/26 (192.168.1.193-254)

## Routing

### Static Routing

Routing manual yang dikonfigurasi administrator.

**Contoh:**
```
ip route 192.168.2.0 255.255.255.0 10.0.0.1
```

### Dynamic Routing

Protokol routing otomatis:
- **RIP (Routing Information Protocol)**: Distance vector
- **OSPF (Open Shortest Path First)**: Link state
- **BGP (Border Gateway Protocol)**: Path vector

## NAT (Network Address Translation)

Mengubah IP address private ke public untuk akses Internet.

**Jenis NAT:**
1. **Static NAT**: 1-to-1 mapping
2. **Dynamic NAT**: Pool of public IPs
3. **PAT (Port Address Translation)**: Many-to-1 dengan port berbeda

## Troubleshooting Tools

1. **ping**: Test connectivity
   ```bash
   ping 8.8.8.8
   ```

2. **traceroute**: Trace packet path
   ```bash
   traceroute google.com
   ```

3. **netstat**: Network statistics
   ```bash
   netstat -an
   ```

4. **nslookup**: DNS lookup
   ```bash
   nslookup google.com
   ```

5. **tcpdump/Wireshark**: Packet capture

## Best Practices

1. Gunakan subnet yang sesuai dengan kebutuhan
2. Dokumentasikan konfigurasi jaringan
3. Implementasi security (firewall, ACL)
4. Monitor traffic dan performance
5. Backup konfigurasi secara regular

## Referensi

- RFC 791: Internet Protocol
- RFC 793: Transmission Control Protocol
- RFC 768: User Datagram Protocol
- RFC 826: Address Resolution Protocol
- TCP/IP Illustrated Volume 1 - W. Richard Stevens
