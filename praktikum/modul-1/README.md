# Modul 1: Dasar-Dasar Jaringan dan IP Addressing

## Tujuan Pembelajaran

Setelah menyelesaikan modul ini, mahasiswa diharapkan dapat:
1. Memahami konsep dasar jaringan komputer
2. Mengerti model OSI dan TCP/IP
3. Melakukan konfigurasi IP address pada komputer
4. Melakukan subnetting dasar
5. Menggunakan tools network diagnostic dasar

## Materi

### 1. Pengenalan Jaringan Komputer

**Teori:**
- Definisi jaringan komputer
- Komponen jaringan (hardware dan software)
- Jenis-jenis jaringan (LAN, MAN, WAN)
- Topologi jaringan

**Praktik:**
- Identifikasi komponen jaringan di lab
- Mengenal berbagai jenis kabel jaringan

### 2. Model OSI dan TCP/IP

**Teori:**
- 7 Layer model OSI
- 4 Layer model TCP/IP
- Fungsi setiap layer
- Proses enkapsulasi dan dekapsulasi data

**Praktik:**
- Analisis paket data menggunakan Wireshark
- Identifikasi header setiap layer

### 3. IP Addressing

**Teori:**
- Format IPv4 address
- Kelas IP address (A, B, C, D, E)
- Private vs Public IP
- Subnet mask
- Network ID dan Host ID

**Praktik:**
- Mengidentifikasi kelas IP address
- Menentukan network ID dan broadcast address
- Konfigurasi IP address pada Windows/Linux

## Latihan Praktikum

### Latihan 1: Konfigurasi IP Address di Windows

**Langkah-langkah:**

1. Buka Control Panel → Network and Sharing Center
2. Click "Change adapter settings"
3. Klik kanan pada adapter → Properties
4. Pilih "Internet Protocol Version 4 (TCP/IPv4)" → Properties
5. Pilih "Use the following IP address"
6. Masukkan konfigurasi:
   ```
   IP Address: 192.168.1.10
   Subnet Mask: 255.255.255.0
   Default Gateway: 192.168.1.1
   Preferred DNS: 8.8.8.8
   Alternate DNS: 8.8.4.4
   ```
7. Klik OK

**Verifikasi:**
```cmd
ipconfig /all
```

### Latihan 2: Konfigurasi IP Address di Linux

**Langkah-langkah:**

1. Lihat interface yang tersedia:
   ```bash
   ip addr show
   # atau
   ifconfig -a
   ```

2. Konfigurasi IP (temporary):
   ```bash
   sudo ip addr add 192.168.1.20/24 dev eth0
   sudo ip link set eth0 up
   sudo ip route add default via 192.168.1.1
   ```

3. Konfigurasi IP (permanent) - Edit file konfigurasi:
   
   **Ubuntu/Debian (netplan):**
   ```bash
   sudo nano /etc/netplan/01-netcfg.yaml
   ```
   
   ```yaml
   network:
     version: 2
     ethernets:
       eth0:
         addresses:
           - 192.168.1.20/24
         gateway4: 192.168.1.1
         nameservers:
           addresses: [8.8.8.8, 8.8.4.4]
   ```
   
   Apply:
   ```bash
   sudo netplan apply
   ```

**Verifikasi:**
```bash
ip addr show
ip route show
```

### Latihan 3: Subnetting

**Soal:**
Diberikan network 192.168.10.0/24, bagi menjadi 4 subnet dengan jumlah host yang sama.

**Penyelesaian:**

1. **Hitung subnet mask baru:**
   - Original: /24 (255.255.255.0)
   - Butuh 4 subnet: 2^2 = 4
   - Subnet mask baru: /26 (255.255.255.192)

2. **Hitung range setiap subnet:**

   **Subnet 1:**
   - Network: 192.168.10.0/26
   - Host range: 192.168.10.1 - 192.168.10.62
   - Broadcast: 192.168.10.63

   **Subnet 2:**
   - Network: 192.168.10.64/26
   - Host range: 192.168.10.65 - 192.168.10.126
   - Broadcast: 192.168.10.127

   **Subnet 3:**
   - Network: 192.168.10.128/26
   - Host range: 192.168.10.129 - 192.168.10.190
   - Broadcast: 192.168.10.191

   **Subnet 4:**
   - Network: 192.168.10.192/26
   - Host range: 192.168.10.193 - 192.168.10.254
   - Broadcast: 192.168.10.255

### Latihan 4: Network Diagnostic Tools

**1. PING - Test Connectivity**

```bash
# Ping ke gateway
ping 192.168.1.1

# Ping ke DNS server
ping 8.8.8.8

# Ping dengan jumlah paket tertentu
ping -c 4 google.com

# Ping dengan interval tertentu (Windows)
ping -t google.com
```

**2. TRACEROUTE - Trace Route**

```bash
# Linux
traceroute google.com

# Windows
tracert google.com
```

**3. NSLOOKUP - DNS Lookup**

```bash
# Query DNS
nslookup google.com

# Query DNS server tertentu
nslookup google.com 8.8.8.8
```

**4. NETSTAT - Network Statistics**

```bash
# Lihat koneksi aktif
netstat -an

# Lihat routing table
netstat -r

# Lihat statistik per protokol
netstat -s
```

**5. ARP - Address Resolution Protocol**

```bash
# Lihat ARP cache
arp -a

# Hapus ARP cache
sudo arp -d *
```

## Tugas Praktikum

### Tugas 1: Subnetting

Diberikan network 172.16.0.0/16, buat design subnet untuk:
- Subnet A: 1000 host
- Subnet B: 500 host
- Subnet C: 250 host
- Subnet D: 100 host

Tentukan untuk setiap subnet:
1. Subnet mask yang tepat
2. Network address
3. Host range
4. Broadcast address

### Tugas 2: Troubleshooting Konektivitas

Scenario: Komputer tidak bisa terhubung ke internet.

Lakukan troubleshooting dengan langkah:
1. Cek konfigurasi IP address
2. Ping ke gateway
3. Ping ke DNS server
4. Ping ke public IP (8.8.8.8)
5. Nslookup ke domain
6. Traceroute ke domain

Dokumentasikan hasil setiap langkah dan tentukan dimana masalahnya.

### Tugas 3: Network Analysis

Gunakan Wireshark untuk capture traffic selama:
1. Browsing web
2. Download file
3. Ping ke server

Analisis:
- Protokol yang digunakan
- Source dan destination IP
- Port yang digunakan
- Sequence of packets

## Kriteria Penilaian

1. **Konfigurasi (30%)**
   - Ketepatan konfigurasi IP
   - Konfigurasi dapat berfungsi dengan baik

2. **Subnetting (30%)**
   - Perhitungan subnet benar
   - Alokasi IP efisien

3. **Troubleshooting (20%)**
   - Metode troubleshooting sistematis
   - Identifikasi masalah tepat

4. **Dokumentasi (20%)**
   - Laporan lengkap dan rapi
   - Screenshot sebagai bukti
   - Analisis yang baik

## Referensi

1. Computer Networking: A Top-Down Approach - Kurose & Ross
2. CCNA Routing and Switching Study Guide
3. TCP/IP Guide - Charles M. Kozierok
4. IPv4 Subnetting Made Easy - Paul Browning

## Tips Sukses

1. Pahami konsep sebelum praktik
2. Catat setiap langkah yang dilakukan
3. Jika error, baca pesan error dengan teliti
4. Gunakan dokumentasi dan RFC sebagai referensi
5. Praktikkan berulang-ulang hingga mahir

---

**Selamat Belajar!** 🎓
