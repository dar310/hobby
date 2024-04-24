#!/bin/bash
clear
ctr=1
prev=0
cur=0
while : ; do
    #change the directory of your /sys/class/power_supply/"your battery directory"
    status="$(cat /sys/class/power_supply/BAT1/status)"
    #checking if the battery is charging or not
    if [[ $status = 'Discharging' ]]; then
        #storing the power rate by multiplying voltage and current without the use of power_now file
        cur=$(cat /sys/class/power_supply/BAT1/current_now /sys/class/power_supply/BAT1/voltage_now | xargs | awk '{print $1*$2/1e12}')
        #storing the previous power rate and adding the current power rate
        prev=$(echo "$cur + $prev" |bc -l)
        echo "Battery Discharge rate: $cur W"    
        #storing the average power rate
        ave=$(echo "scale=2; $prev/$ctr" |bc -l)
        echo "Avg. Discharge Rate: $ave W"   
        let "ctr++"
        echo "Press Ctrl+C to stop"
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
