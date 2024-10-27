#!/bin/sh

arc=$(uname -a | awk '{print $1, $2, $3, $4, $5, $7, $8, $9, $10, $11}')
cpu=$(nproc --all)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
fram=$(free --mega | grep Mem | awk '{printf "%s/%sMB (%.2f%%)\n",$3,$2,$3*100/$2}')
uram=$(df --total -h | grep total | awk ' {printf("%d/%dGb (%.2f%%)\n", $3, $2, $3 / $2)}')
pram=$(top -bn1 | grep '%Cpu(s)' | awk '{printf("%.2f%%\n", $2 + $4)}')
fdisk=$(who -b | awk '{print $3, $4}')
udisk=$(lsblk | grep lvm | awk '{if ($1) {print "yes"; exit;} else {print "no"} }')
pdisk=$(cat /proc/net/sockstat | grep TCP | awk ' {print $3}' | tr '\n' ' ' && echo "ESTABLISHED")
cpul=$(who | awk '{print $1}' | sort -u | wc -l)
ip=$(hostname -I | tr '\n' ' ' && ip link | awk '/link\/ether/ {print "(" $2 ")"}')
sudo=$(echo -n $(journalctl -q _COMM=sudo | grep -c COMMAND) && echo " cmd")

# Concatenate all variables into a single message
message="#Architecture: $arc
#CPU physical: $cpu
#vCPU: $vcpu
#Memory Usage: $fram
#Disk Usage: $uram
#CPU Load: $pram
Last boot: $fdisk
#LVM use: $udisk
#Connections TCP: $pdisk
#User log: $cpul
#Network: IP $ip
#Sudo : $sudo"

# Use wall to broadcast the concatenated message
printf "%s" "$message" | wall
