#!/usr/bin/env bash

# settings
KEEP_FOR=1800     # seconds
DELAY=300
CYCLE=0

while true; do

    DATE=`date +%h-%d\(%H:%M:%S\)`    

    if [[ "$CYCLE" -ge 2101 ]]; then
            CYCLE=0
    fi

    PING=$(echo "$(ping -c3 google.com| grep "received")")
    RECEIVED=$(echo $PING | awk '{printf $1}')

    if [[ "${RECEIVED}" = "" ]]; then
        PING=$(echo "$(ping -c3 ya.ru | grep "received")")
        RECEIVED=$(echo $PING | awk '{printf $1}')
    fi 

    if [[ "${RECEIVED}" -ge 3 ]]; then
        CYCLE=0
        sleep $DELAY
    else 
        sleep $DELAY
        CYCLE="$(($CYCLE + $DELAY))"
        if [[ "$CYCLE" -ge "$KEEP_FOR" ]]; then
            printf "REBOOT \n"
            sudo reboot
        fi    
    fi    

    let "MIN = $CYCLE / 60"
    printf "$DATE: received: $RECEIVED, net delay for $MIN min \n" 

done