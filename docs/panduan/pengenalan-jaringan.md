# Pengenalan Jaringan Komputer

## Definisi Jaringan Komputer

Jaringan komputer adalah kumpulan dua atau lebih komputer yang saling terhubung untuk berbagi sumber daya dan informasi.

## Komponen Jaringan

### 1. Hardware
- **Komputer/Host**: Perangkat yang terhubung ke jaringan
- **Network Interface Card (NIC)**: Kartu jaringan untuk menghubungkan komputer ke jaringan
- **Switch**: Perangkat untuk menghubungkan beberapa komputer dalam satu jaringan
- **Router**: Perangkat untuk menghubungkan antar jaringan
- **Kabel**: Media transmisi data (UTP, Fiber Optic, Coaxial)
- **Access Point**: Perangkat untuk jaringan wireless

### 2. Software
- **Sistem Operasi Jaringan**: Windows Server, Linux, dll
- **Protokol Jaringan**: TCP/IP, HTTP, FTP, dll
- **Aplikasi Jaringan**: Email, Web Browser, dll

## Model Referensi Jaringan

### Model OSI (Open Systems Interconnection)

Model OSI terdiri dari 7 layer:

1. **Physical Layer**: Transmisi bit mentah melalui media fisik
2. **Data Link Layer**: Transfer data antar node yang berdekatan
3. **Network Layer**: Routing dan forwarding paket
4. **Transport Layer**: Transfer data end-to-end
5. **Session Layer**: Mengelola sesi komunikasi
6. **Presentation Layer**: Format dan enkripsi data
7. **Application Layer**: Interface ke aplikasi pengguna

### Model TCP/IP

Model TCP/IP terdiri dari 4 layer:

1. **Network Access Layer**: Setara Physical + Data Link Layer OSI
2. **Internet Layer**: Setara Network Layer OSI
3. **Transport Layer**: Setara Transport Layer OSI
4. **Application Layer**: Setara Session + Presentation + Application Layer OSI

## Jenis-Jenis Jaringan

### Berdasarkan Area Geografis

1. **LAN (Local Area Network)**
   - Jaringan dalam area terbatas (gedung, kampus)
   - Kecepatan tinggi
   - Contoh: Jaringan kantor, lab komputer

2. **MAN (Metropolitan Area Network)**
   - Jaringan dalam satu kota
   - Menghubungkan beberapa LAN
   - Contoh: Jaringan antar cabang bank dalam satu kota

3. **WAN (Wide Area Network)**
   - Jaringan dalam area geografis luas
   - Menghubungkan antar kota/negara
   - Contoh: Internet

### Berdasarkan Topologi

1. **Bus**: Semua node terhubung ke satu kabel utama
2. **Star**: Semua node terhubung ke hub/switch pusat
3. **Ring**: Node terhubung membentuk lingkaran
4. **Mesh**: Setiap node terhubung ke semua node lain
5. **Tree**: Kombinasi topologi star dan bus

## IP Addressing

### IPv4
- Format: 32 bit (4 oktet)
- Contoh: 192.168.1.1
- Kelas A: 0.0.0.0 - 127.255.255.255
- Kelas B: 128.0.0.0 - 191.255.255.255
- Kelas C: 192.0.0.0 - 223.255.255.255

### IPv6
- Format: 128 bit
- Contoh: 2001:0db8:85a3:0000:0000:8a2e:0370:7334

## Subnet Mask

Subnet mask digunakan untuk memisahkan network ID dan host ID.

Contoh:
- IP Address: 192.168.1.10
- Subnet Mask: 255.255.255.0 (/24)
- Network ID: 192.168.1.0
- Broadcast: 192.168.1.255
- Host Range: 192.168.1.1 - 192.168.1.254

## Protokol Jaringan Utama

1. **TCP (Transmission Control Protocol)**: Connection-oriented, reliable
2. **UDP (User Datagram Protocol)**: Connectionless, faster
3. **IP (Internet Protocol)**: Routing dan addressing
4. **ICMP (Internet Control Message Protocol)**: Diagnostic (ping, traceroute)
5. **ARP (Address Resolution Protocol)**: Mapping IP ke MAC address

## Port Numbers

- **Well-known ports** (0-1023):
  - HTTP: 80
  - HTTPS: 443
  - FTP: 21
  - SSH: 22
  - Telnet: 23
  - DNS: 53
  - SMTP: 25
  - POP3: 110

## Kesimpulan

Memahami dasar-dasar jaringan komputer sangat penting untuk dapat mengimplementasikan dan mengelola infrastruktur jaringan yang efisien dan aman.

## Referensi

- RFC 791 - Internet Protocol
- RFC 793 - Transmission Control Protocol
- Computer Networking: A Top-Down Approach
