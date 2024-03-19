#!/bin/bash

# ARCHITECTURE
arch=$(uname -a)

# CPU
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)
cpuv=$(grep processor /proc/cpuinfo | wc -l)
cpup=$(top -bn1 | grep '%^Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1+$3}')

# RAM
total_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')
used_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
percentage_ram=$(free --mega | awk '$1 == "Mem:" {printf(("%.2f"), $3/$2*100)}')

# DISK_FILESYSTEM
total_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{diskt +=$2} END {printf("%.1f"), diskt/1024}')
used_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disku += $3} END {print disku}')
percentage_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used +=$3} {total+=$2} END {printf("%d"), used/total*100}')

# LAST_BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM_CHECK
lvmc=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ];then echo yes; else echo no; fi)

# TCP_CONNECTIONS
tcp=$(ss -ta | grep ESTAB | wc -l)

# USERS_CONNECTED
users=$(users | wc -w)

# IP_ADDRESS
ip=$(hostname -I)

# MEDIA_ACCESS_CONTROL
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO_COMMANDS
sudocmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	architecture: $arch
	physical cpu: $cpuf
	virtual cpu: $cpuv
	memory usage: $used_ram/${total_ram}MB ($percentage_ram%)
	disk usage: $used_disk/${total_disk}Gb ($percentage_disk%)
	cpu load: $cpup
	last boot: $lb
	LVM used: $lvmc
	connections TCP: $tcp ESTABLISHED
	userlog: $users
	network: IP $ip ($mac)
	sudo: $sudocmd cmd"
