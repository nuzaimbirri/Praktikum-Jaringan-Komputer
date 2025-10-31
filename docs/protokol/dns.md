# DNS (Domain Name System)

## Pendahuluan

DNS adalah sistem penamaan hierarkis yang menerjemahkan nama domain yang mudah diingat (seperti www.google.com) menjadi alamat IP numerik (seperti 142.250.185.78) yang digunakan oleh komputer untuk berkomunikasi.

## Konsep Dasar DNS

### Fungsi DNS
1. **Name Resolution**: Menerjemahkan domain name ke IP address
2. **Reverse Lookup**: Menerjemahkan IP address ke domain name
3. **Mail Routing**: Menentukan mail server untuk domain (MX records)
4. **Service Discovery**: Menemukan layanan dalam network (SRV records)

### Komponen DNS

#### 1. DNS Client (Resolver)
- Aplikasi yang mengirim DNS query
- Biasanya bagian dari operating system
- Cache hasil query untuk meningkatkan performa

#### 2. DNS Server (Name Server)
- Menjawab DNS query dari clients
- Menyimpan DNS records
- Dapat melakukan recursive atau iterative queries

#### 3. DNS Zone
- Administrative boundary dalam DNS namespace
- Berisi DNS records untuk domain tertentu

## Hierarki DNS

```
                  Root (.)
                     |
        +------------+------------+
        |            |            |
      .com         .org         .id
        |            |            |
    +---+---+        |        +---+---+
    |       |        |        |       |
 google  amazon   wikipedia  ac    co
    |                           |
   www                        ui
```

### Root DNS Servers
- 13 logical root name servers (a.root-servers.net through m.root-servers.net)
- Distributed globally menggunakan anycast
- Maintained by berbagai organisasi

### Top-Level Domain (TLD)
1. **Generic TLD (gTLD)**:
   - .com, .org, .net, .edu, .gov
   - .info, .biz, .name

2. **Country Code TLD (ccTLD)**:
   - .id (Indonesia)
   - .us (United States)
   - .uk (United Kingdom)
   - .jp (Japan)

3. **New gTLD**:
   - .tech, .online, .site, .app

## DNS Record Types

### A Record (Address Record)
Maps domain name ke IPv4 address.
```
www.example.com.    IN    A    192.0.2.1
```

### AAAA Record (IPv6 Address Record)
Maps domain name ke IPv6 address.
```
www.example.com.    IN    AAAA    2001:db8::1
```

### CNAME Record (Canonical Name)
Alias dari satu domain ke domain lain.
```
blog.example.com.    IN    CNAME    example.com.
```

### MX Record (Mail Exchange)
Menentukan mail server untuk domain.
```
example.com.    IN    MX    10    mail.example.com.
example.com.    IN    MX    20    mail2.example.com.
```
(Angka menunjukkan priority, semakin kecil semakin prioritas)

### NS Record (Name Server)
Menentukan authoritative name server untuk domain.
```
example.com.    IN    NS    ns1.example.com.
example.com.    IN    NS    ns2.example.com.
```

### PTR Record (Pointer Record)
Untuk reverse DNS lookup (IP ke domain).
```
1.2.0.192.in-addr.arpa.    IN    PTR    www.example.com.
```

### TXT Record (Text Record)
Menyimpan arbitrary text, sering digunakan untuk:
- SPF (Sender Policy Framework)
- DKIM (DomainKeys Identified Mail)
- Domain verification

```
example.com.    IN    TXT    "v=spf1 mx -all"
```

### SOA Record (Start of Authority)
Informasi tentang zone.
```
example.com.    IN    SOA    ns1.example.com. admin.example.com. (
                              2024103101 ; Serial
                              3600       ; Refresh
                              1800       ; Retry
                              604800     ; Expire
                              86400 )    ; Minimum TTL
```

### SRV Record (Service Record)
Menentukan lokasi services.
```
_service._proto.name.    TTL    class    SRV    priority weight port target.
_http._tcp.example.com.  IN     SRV     10      60     80   www.example.com.
```

## DNS Query Process

### 1. Recursive Query
Client meminta DNS server untuk menyelesaikan query secara lengkap.

```
User PC → Local DNS Server → Root Server → TLD Server → Authoritative Server
       ← Answer ← Answer ← Answer ← Answer
```

### 2. Iterative Query
DNS server memberikan referral ke server lain jika tidak tahu jawabannya.

```
Local DNS → Root: "Tanya TLD server"
Local DNS → TLD: "Tanya Auth server"
Local DNS → Auth: "Ini jawabannya"
```

### Contoh Lengkap DNS Resolution

Query: www.google.com

1. User mengetik www.google.com di browser
2. Browser check local cache
3. OS check local DNS cache
4. Query dikirim ke configured DNS server (ISP DNS)
5. ISP DNS check cache-nya
6. Jika tidak ada, ISP DNS query ke root server
7. Root server return: "Tanya .com TLD server"
8. ISP DNS query ke .com TLD server
9. TLD server return: "Tanya ns1.google.com"
10. ISP DNS query ke ns1.google.com
11. ns1.google.com return: "IP address adalah 142.250.185.78"
12. ISP DNS cache hasilnya dan return ke user
13. Browser connect ke IP address

## DNS Caching

### Time To Live (TTL)
- Menentukan berapa lama record boleh di-cache
- Dalam satuan detik
- Trade-off antara performance dan freshness

### Caching Locations
1. **Browser Cache**: Beberapa detik hingga menit
2. **OS Cache**: Sesuai TTL atau OS setting
3. **Router Cache**: Jika router menjalankan DNS proxy
4. **ISP DNS Cache**: Sesuai TTL dari authoritative server

## Konfigurasi DNS

### DNS Server Configuration (BIND)

**Install BIND:**
```bash
# Debian/Ubuntu
sudo apt-get install bind9 bind9utils bind9-doc

# RedHat/CentOS
sudo yum install bind bind-utils
```

**Basic Configuration (/etc/bind/named.conf.options):**
```
options {
    directory "/var/cache/bind";
    
    // Allow queries from any host
    allow-query { any; };
    
    // Forward queries to upstream DNS
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    
    // Enable DNSSEC
    dnssec-validation auto;
    
    listen-on { any; };
    listen-on-v6 { any; };
};
```

**Zone Configuration (/etc/bind/named.conf.local):**
```
zone "example.com" {
    type master;
    file "/etc/bind/zones/db.example.com";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.1";
};
```

**Forward Zone File (/etc/bind/zones/db.example.com):**
```
$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                              2024103101         ; Serial
                              604800             ; Refresh
                              86400              ; Retry
                              2419200            ; Expire
                              604800 )           ; Negative Cache TTL
;
@       IN      NS      ns1.example.com.
@       IN      NS      ns2.example.com.
@       IN      A       192.168.1.10
ns1     IN      A       192.168.1.10
ns2     IN      A       192.168.1.11
www     IN      A       192.168.1.20
mail    IN      A       192.168.1.30
@       IN      MX      10 mail.example.com.
ftp     IN      CNAME   www.example.com.
```

**Reverse Zone File (/etc/bind/zones/db.192.168.1):**
```
$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                              2024103101         ; Serial
                              604800             ; Refresh
                              86400              ; Retry
                              2419200            ; Expire
                              604800 )           ; Negative Cache TTL
;
@       IN      NS      ns1.example.com.
10      IN      PTR     example.com.
20      IN      PTR     www.example.com.
30      IN      PTR     mail.example.com.
```

### DNS Client Configuration

**Linux (/etc/resolv.conf):**
```
nameserver 8.8.8.8
nameserver 8.8.4.4
search example.com
```

**Windows:**
```
Control Panel → Network → Adapter Properties → IPv4 Properties
Set: Preferred DNS: 8.8.8.8
     Alternate DNS: 8.8.4.4
```

## DNS Tools dan Commands

### nslookup
```bash
# Simple query
nslookup www.google.com

# Query specific DNS server
nslookup www.google.com 8.8.8.8

# Query specific record type
nslookup -type=MX google.com

# Interactive mode
nslookup
> server 8.8.8.8
> set type=A
> www.google.com
```

### dig (Domain Information Groper)
```bash
# Simple query
dig www.google.com

# Query specific record type
dig google.com MX
dig google.com AAAA
dig google.com TXT

# Query specific DNS server
dig @8.8.8.8 www.google.com

# Reverse lookup
dig -x 8.8.8.8

# Trace DNS resolution path
dig +trace www.google.com

# Short output
dig +short www.google.com

# Show only answer section
dig +noall +answer www.google.com
```

### host
```bash
# Simple query
host www.google.com

# Reverse lookup
host 8.8.8.8

# Query specific record type
host -t MX google.com
host -t NS google.com
```

## DNS Security

### Common DNS Attacks

1. **DNS Spoofing/Cache Poisoning**
   - Attacker memasukkan fake DNS records ke cache
   - Mitigation: DNSSEC, secure DNS servers

2. **DNS Amplification DDoS**
   - Menggunakan open DNS resolvers untuk amplify attack
   - Mitigation: Disable open recursion, rate limiting

3. **DNS Tunneling**
   - Menggunakan DNS queries untuk exfiltrate data
   - Mitigation: Monitor unusual DNS traffic patterns

### DNSSEC (DNS Security Extensions)

**Purpose:**
- Memastikan authenticity dan integrity DNS responses
- Mencegah cache poisoning

**How it works:**
- DNS records di-sign dengan cryptographic signatures
- Clients verify signatures menggunakan chain of trust

**DNSSEC Records:**
- RRSIG: Signature untuk record set
- DNSKEY: Public key
- DS: Delegation Signer
- NSEC/NSEC3: Authenticated denial of existence

### Best Practices

1. **Use DNSSEC**: Enable untuk domains Anda
2. **Secure DNS Servers**: 
   - Update regularly
   - Disable recursion untuk public-facing servers
   - Rate limiting
3. **Use DoH/DoT**:
   - DNS over HTTPS (DoH)
   - DNS over TLS (DoT)
4. **Monitor DNS Traffic**:
   - Unusual query patterns
   - High volume queries
5. **Regular Audits**: Review DNS configurations

## Troubleshooting DNS

### Common Issues

**1. Name Not Resolving**
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup google.com

# Try different DNS server
nslookup google.com 8.8.8.8

# Check if DNS port is reachable
telnet 8.8.8.8 53
```

**2. Slow DNS Resolution**
```bash
# Time DNS query
time dig www.google.com

# Check which DNS server is responding
dig +trace www.google.com
```

**3. Wrong DNS Records**
```bash
# Clear DNS cache (Linux)
sudo systemd-resolve --flush-caches
# or
sudo /etc/init.d/nscd restart

# Clear DNS cache (Windows)
ipconfig /flushdns
```

## Public DNS Servers

### Popular Options

1. **Google Public DNS**
   - IPv4: 8.8.8.8, 8.8.4.4
   - IPv6: 2001:4860:4860::8888, 2001:4860:4860::8844

2. **Cloudflare DNS**
   - IPv4: 1.1.1.1, 1.0.0.1
   - IPv6: 2606:4700:4700::1111, 2606:4700:4700::1001

3. **OpenDNS**
   - IPv4: 208.67.222.222, 208.67.220.220

4. **Quad9**
   - IPv4: 9.9.9.9, 149.112.112.112

## Referensi

- RFC 1034: Domain Names - Concepts and Facilities
- RFC 1035: Domain Names - Implementation and Specification
- RFC 4033-4035: DNS Security Extensions (DNSSEC)
- RFC 8484: DNS Queries over HTTPS (DoH)
- RFC 7858: DNS over TLS (DoT)
