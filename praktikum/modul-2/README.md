# Modul 2: Routing dan Switching

## Tujuan Pembelajaran

Setelah menyelesaikan modul ini, mahasiswa diharapkan dapat:
1. Memahami konsep routing dan switching
2. Melakukan konfigurasi router dan switch
3. Mengimplementasikan static routing
4. Memahami dynamic routing protocol (RIP, OSPF)
5. Mengkonfigurasi VLAN

## Materi

### 1. Dasar Routing

**Teori:**
- Perbedaan routing dan switching
- Routing table
- Metric dan administrative distance
- Next hop dan exit interface
- Default route

**Konsep Routing:**
```
Network A (192.168.1.0/24)
         |
      [Router A]
         |
   Internet/WAN
         |
      [Router B]
         |
Network B (192.168.2.0/24)
```

### 2. Static Routing

**Karakteristik:**
- Dikonfigurasi manual oleh administrator
- Tidak ada overhead protocol
- Cocok untuk jaringan kecil
- Tidak adaptif terhadap perubahan topology

**Konfigurasi Static Route:**

**Cisco Router:**
```
Router(config)# ip route 192.168.2.0 255.255.255.0 10.0.0.2
Router(config)# ip route 0.0.0.0 0.0.0.0 10.0.0.1  # Default route
```

**Linux:**
```bash
# Tambah static route
sudo ip route add 192.168.2.0/24 via 10.0.0.2

# Default route
sudo ip route add default via 10.0.0.1

# Lihat routing table
ip route show
```

### 3. Dynamic Routing

#### RIP (Routing Information Protocol)

**Karakteristik:**
- Distance vector protocol
- Metric: hop count
- Maximum hop: 15
- Update setiap 30 detik
- Cocok untuk jaringan kecil

**Konfigurasi RIP:**
```
Router(config)# router rip
Router(config-router)# version 2
Router(config-router)# network 192.168.1.0
Router(config-router)# network 10.0.0.0
Router(config-router)# no auto-summary
```

#### OSPF (Open Shortest Path First)

**Karakteristik:**
- Link state protocol
- Metric: cost (based on bandwidth)
- Scalable untuk jaringan besar
- Fast convergence
- Area-based design

**Konfigurasi OSPF:**
```
Router(config)# router ospf 1
Router(config-router)# network 192.168.1.0 0.0.0.255 area 0
Router(config-router)# network 10.0.0.0 0.0.0.255 area 0
```

### 4. Switching dan VLAN

**Virtual LAN (VLAN):**
- Segmentasi logis network
- Meningkatkan security
- Mengurangi broadcast domain
- Flexible management

**Jenis VLAN:**
1. **Data VLAN**: untuk user data
2. **Voice VLAN**: untuk VoIP
3. **Management VLAN**: untuk management
4. **Native VLAN**: untagged traffic

## Latihan Praktikum

### Latihan 1: Konfigurasi Static Routing

**Topologi:**
```
[PC1] ---- [Router A] ---- [Router B] ---- [PC2]
192.168.1.10  .1    .2  .1    .2  .1   192.168.2.10
  Network A      10.0.0.0/30      Network B
```

**Konfigurasi Router A:**
```
Router-A> enable
Router-A# configure terminal
Router-A(config)# interface gigabitEthernet 0/0
Router-A(config-if)# ip address 192.168.1.1 255.255.255.0
Router-A(config-if)# no shutdown
Router-A(config-if)# exit

Router-A(config)# interface gigabitEthernet 0/1
Router-A(config-if)# ip address 10.0.0.1 255.255.255.252
Router-A(config-if)# no shutdown
Router-A(config-if)# exit

Router-A(config)# ip route 192.168.2.0 255.255.255.0 10.0.0.2
Router-A(config)# exit
Router-A# write memory
```

**Konfigurasi Router B:**
```
Router-B> enable
Router-B# configure terminal
Router-B(config)# interface gigabitEthernet 0/0
Router-B(config-if)# ip address 10.0.0.2 255.255.255.252
Router-B(config-if)# no shutdown
Router-B(config-if)# exit

Router-B(config)# interface gigabitEthernet 0/1
Router-B(config-if)# ip address 192.168.2.1 255.255.255.0
Router-B(config-if)# no shutdown
Router-B(config-if)# exit

Router-B(config)# ip route 192.168.1.0 255.255.255.0 10.0.0.1
Router-B(config)# exit
Router-B# write memory
```

**Verifikasi:**
```
Router-A# show ip route
Router-A# show ip interface brief
Router-A# ping 192.168.2.1
```

### Latihan 2: Konfigurasi VLAN

**Scenario:**
Membuat 3 VLAN:
- VLAN 10: Sales (192.168.10.0/24)
- VLAN 20: IT (192.168.20.0/24)
- VLAN 30: Management (192.168.30.0/24)

**Konfigurasi Switch:**

**1. Buat VLAN:**
```
Switch(config)# vlan 10
Switch(config-vlan)# name Sales
Switch(config-vlan)# exit

Switch(config)# vlan 20
Switch(config-vlan)# name IT
Switch(config-vlan)# exit

Switch(config)# vlan 30
Switch(config-vlan)# name Management
Switch(config-vlan)# exit
```

**2. Assign Port ke VLAN:**
```
# Port untuk VLAN 10 (Sales)
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit

# Port untuk VLAN 20 (IT)
Switch(config)# interface fastEthernet 0/2
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 20
Switch(config-if)# exit

# Port untuk VLAN 30 (Management)
Switch(config)# interface fastEthernet 0/3
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 30
Switch(config-if)# exit
```

**3. Konfigurasi Trunk Port:**
```
Switch(config)# interface gigabitEthernet 0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
Switch(config-if)# exit
```

**Verifikasi:**
```
Switch# show vlan brief
Switch# show interfaces trunk
Switch# show vlan id 10
```

### Latihan 3: Inter-VLAN Routing (Router-on-a-Stick)

**Topologi:**
```
[PC-VLAN10] ---|
[PC-VLAN20] ---| [Switch] === [Router]
[PC-VLAN30] ---|
```

**Konfigurasi Router (Sub-interface):**
```
Router(config)# interface gigabitEthernet 0/0
Router(config-if)# no shutdown
Router(config-if)# exit

Router(config)# interface gigabitEthernet 0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

Router(config)# interface gigabitEthernet 0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit

Router(config)# interface gigabitEthernet 0/0.30
Router(config-subif)# encapsulation dot1Q 30
Router(config-subif)# ip address 192.168.30.1 255.255.255.0
Router(config-subif)# exit
```

### Latihan 4: RIP Dynamic Routing

**Topologi:**
```
[Network A] --- [Router A] --- [Router B] --- [Network B]
192.168.1.0/24              10.0.0.0/30              192.168.2.0/24
                    |
                [Router C]
                    |
              [Network C]
             192.168.3.0/24
```

**Konfigurasi RIP pada Router A:**
```
Router-A(config)# router rip
Router-A(config-router)# version 2
Router-A(config-router)# network 192.168.1.0
Router-A(config-router)# network 10.0.0.0
Router-A(config-router)# no auto-summary
```

**Konfigurasi serupa pada Router B dan C**

**Verifikasi:**
```
Router# show ip rip database
Router# show ip route rip
Router# debug ip rip
```

## Tugas Praktikum

### Tugas 1: Design dan Implementasi Network

**Scenario:**
Sebuah perusahaan memiliki 3 departemen:
- Finance: 50 host
- HR: 30 host
- IT: 20 host

**Requirements:**
1. Design subnet untuk setiap departemen
2. Implementasikan VLAN
3. Konfigurasi inter-VLAN routing
4. Test konektivitas antar departemen

### Tugas 2: Multi-Router Network

**Scenario:**
Buat topologi dengan 4 router yang saling terhubung.

**Requirements:**
1. Implementasikan static routing
2. Implementasikan RIP
3. Bandingkan performa dan konvergensi
4. Dokumentasikan routing table

### Tugas 3: VLAN dan Security

**Scenario:**
Implementasikan VLAN dengan security features.

**Requirements:**
1. Buat 4 VLAN
2. Implementasikan port security
3. Konfigurasi VLAN ACL
4. Test isolasi antar VLAN

## Troubleshooting Commands

```
# Router
show ip route
show ip interface brief
show running-config
ping <ip-address>
traceroute <ip-address>

# Switch
show vlan brief
show mac address-table
show interfaces status
show interfaces trunk
show spanning-tree

# RIP
show ip protocols
show ip rip database
debug ip rip

# OSPF
show ip ospf neighbor
show ip ospf database
show ip ospf interface
```

## Kriteria Penilaian

1. **Konfigurasi (40%)**
   - Routing configuration
   - VLAN configuration
   - Syntax benar

2. **Functionality (30%)**
   - Network berfungsi dengan baik
   - Konektivitas end-to-end

3. **Troubleshooting (15%)**
   - Kemampuan diagnose masalah
   - Solusi yang tepat

4. **Dokumentasi (15%)**
   - Diagram topologi
   - Tabel IP addressing
   - Hasil testing

## Referensi

1. CCNA Routing and Switching Complete Study Guide
2. Cisco Networking Academy CCNA Curriculum
3. Routing TCP/IP Volume 1 - Jeff Doyle
4. OSPF: Anatomy of an Internet Routing Protocol

---

**Good Luck!** 🚀
