#!/bin/bash
clear
ctr=1
prev=0
cur=0
while : ; do
    status="$(cat /sys/class/power_supply/BAT1/status)"
    if [[ $status = 'Discharging' ]]; then
        cur=$(cat /sys/class/power_supply/BAT1/current_now /sys/class/power_supply/BAT1/voltage_now | xargs | awk '{print $1*$2/1e12}')
        prev=$(echo "$cur + $prev" |bc -l)
        echo "Battery Discharge rate: $cur W"    
        ave=$(echo "scale=2; $prev/$ctr" |bc -l)
        echo "Avg. Discharge Rate: $ave W"   
        let "ctr++"
        echo "Press Ctrl+C to force stop"
        sleep 0.25
        clear
    else
        echo "Device is Charging, use this to measure battery discharge rate"
        echo "Press Ctrl+C to quit immediately or wait 3 seconds"
        sleep 2
        echo "Quitting"
        sleep 1
        break
    fi
done
#break
