
#arch
arch=$(uname -a)
#cpu
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l) #physical cores
cpuv=$(grep processor /proc/cpuinfo | wc -l) #virtual cores
#ram
used_ram=$(free --mega | awk '$1 == "Mem:" {print $3}') #used memory
total_ram=$(free --mega | awk '$1 == "Mem:" {print $2}') #total memory
percentage_ram=$(free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}') #percentage of used memory
#disk filesystem
udisk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use +=$3} END {print memory_use}')
tdisk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result +=$2} END {printf("%.1fGB\n"), memory_result/1024}')
pdisk=$(df -m | grep "/dev/" | frep -v "/boot" | awk '{use +=$3} [total +=$2] END {printf("(%d%%)\n"), use/total*100}')
#cpu percentage
pcpu=$(vmstat | tail -1| awk '{print $15}')
lboot=$(who -b | awk '$1 == "system" {print $3 " " $4}') #last reboot
lvmc=$(if [ ($lsblk | grep "lvm" | wc -l) -gt 0 ];then echo yes; else echo no; fi) #check if lvm is active
tcp=$(ss -ta | grep ESTAB | wc -l) #tcp connections(from terminal)
users=$(users | wc -w) #number of users
ip=$(hostname -I) #host address
mac=$(ip link | grep "link/ether" | awk '{print$2}') #media access control
sudocmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l) #nr commands executed with sudo

wall "  architecture: $arch
        cpu physical: $cpuf
        cpu virtual: $cpuv
        memory usage: $used_ram/${total_ram}MB ($percentage_ram%)
        disk usage: $udisk/${tdisk} ($pdisk%)
        cpu load:
        last boot: $lboot
        LVM use: $lvmc
        connections TCP: $tcp ESTABLISHED
        userlog: $users
        network: IP $ip ($mac)
        sudo: $sudocmd cmd"
