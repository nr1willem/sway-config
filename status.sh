#!/bin/bash
date_formatted=$(date "+%A %F %H:%M:%S")

battery_status=$(upower --show-info $(upower --enumerate |\
grep 'BAT') |\
grep -E "percentage" |\
awk '{print $2}')

check_battery=${battery_status%\%}

if [[ $check_battery -le 21 ]]; then
    battery_status+=" LOW BATTERY!"
elif [[ $check_battery -le 40 ]]; then
	 battery_status+=" low battery."	
elif [[ $check_battery -le 60 ]]; then
    battery_status+=" medium battery."
elif [[ $check_battery -le 100 ]]; then
    battery_status+=" high battery."	
fi

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=\%)' | awk '{sum+=$1} END {print sum/NR}')
light=$(light -G)

used_memory=$(free -m -h | grep -i 'Mem:' | awk '{ print $3 }')
total_memory=$(free -m -h | grep -i 'Mem: ' | awk '{ print $2 }')
free_memory=$(free -m -h | grep -i 'Mem: ' | awk '{ print $4 }')

total_disk_space=$(df -H | grep -i '/dev/nvme0n1p7' | awk '{ print $2 }')
used_disk_space=$(df -H | grep -i '/dev/nvme0n1p7' | awk '{ print $3 }')
free_disk_space=$(df -H | grep -i '/dev/nvme0n1p7' | awk '{ print $4 }')

echo ▕ DISK SPACE total:$total_disk_space used:$used_disk_space free: $free_disk_space▕ MEMORY USAGE total: $total_memory used: $used_memory free: $free_memory▕ ${light%.*}% brightness▕ $volume% volume▕ $date_formatted▕ $battery_status▕  
