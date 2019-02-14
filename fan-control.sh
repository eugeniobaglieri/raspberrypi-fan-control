#!/bin/bash

# debug flag:
# 0 - debug disabled
# 1 - debug enabled
DEBUG=1

# gpio command pin
device_gpio_pin=7 (pin 7 = BCM4)

# device references
device_temperature=/etc/armbianmonitor/datasources/soctemp
device_gpio=/usr/local/bin/gpio

# update interval (seconds)
interval=10

# temperature limit (millidegrees)
high_temperature_limit=46000

# fan commands
setup_gpio_pin="$device_gpio mode $device_gpio_pin out"
enable_fan_command="$device_gpio write $device_gpio_pin 1"
disable_fan_command="$device_gpio write $device_gpio_pin 0"

while [ : ]
do
    eval $setup_gpio_pin
    temperature=$(cat $device_temperature)
    fan_status=""
    if [ $temperature -gt $high_temperature_limit ]; then
        fan_status="ON"                                  
        eval $enable_fan_command                                                  
    else
        fan_status="OFF"
        eval $disable_fan_command                                                      
    fi

    if [ $DEBUG -eq 1 ]; then
        lineToLog="FAN-$fan_status-$temperature $(date)"
        echo $lineToLog >> logfan.txt
    fi

    sleep $interval
done
