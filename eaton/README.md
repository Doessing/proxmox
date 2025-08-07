# Eaton IPP Installation Script for Proxmox

This repository contains an automated installation script to deploy **Eaton Intelligent Power Protector (IPP)** on a Proxmox host without internet access.

---

## Prerequisites

- The Eaton IPP ".deb" package (e.g., "ipp-linux_1.75.183-1_amd64.deb")
- Access to the Proxmox host as **root** (SSH enabled)
- PowerShell on your Windows machine for file transfer (optional), alternative FileZilla, PuttySCP, WinSCP or the like to transfer the files.

---

## Getting Started

### 1. Transfer the Eaton IPP ".deb" file and installation script to Proxmox

Open PowerShell on your Windows machine and run:

```powershell
cd C:\path\to\folder\Eaton-IPP
scp ipp-* root@<Proxmox-IP>:/root/
Example: scp ipp-* root@10.80.2.20:/root/
```
Replace <Proxmox-IP> with the IP address of your Proxmox host.

### 2. Connect to your Proxmox host
```
ssh root@<Proxmox-IP>
```

### 3. Run the installation script
``` 
chmod +x /root/ipp-install.sh
./ipp-install.sh
``` 
