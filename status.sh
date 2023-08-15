#!/bin/bash
date_formatted=$(date "+%A %F %H:%M:%S")

battery_status=$(upower --show-info $(upower --enumerate |\
grep 'BAT') |\
grep -E "percentage" |\
awk '{print $2}')

check_battery=${battery_status%\%}

if [[ $check_battery -le 21 ]]; then
    battery_status+=" VERY LOW BATTERY!"
elif [[ $check_battery -le 40 ]]; then
	 battery_status+=" low battery."	
elif [[ $check_battery -le 60 ]]; then
    battery_status+=" medium battery."
elif [[ $check_battery -le 100 ]]; then
    battery_status+=" high battery."	
fi

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=\%)' | awk '{sum+=$1} END {print sum/NR}')
name=$(whoami)
light=$(light -G)

not_rounded_memory_usage=$(free -m -h | grep -i 'Mem:' | awk '{usage=($3/$2)*100} END {print usage}')
memory_usage=$(printf "%.2f" $not_rounded_memory_usage)

total_disk_space=$(df -H | grep -i '/dev/nvme0n1p7' | awk '{ print $2 }')
used_disk_space=$(df -H | grep -i '/dev/nvme0n1p7' | awk '{ print $3 }')

echo  ▕ total:$total_disk_space used:$used_disk_space▕ $memory_usage% memory usage▕ ${light%.*}% brightness▕ $volume% volume▕ $date_formatted▕ $battery_status▕  
