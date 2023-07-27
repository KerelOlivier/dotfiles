#!/bin/bash

get-volume(){
    muted=$(pactl list sinks | awk '/RUNNING/{flag=1;next}/Mute:/{if(flag) print $2;flag=0}' | head -n1)
    if [ "$muted" == "yes" ]; then
        echo 0
    else
        pactl list sinks | awk '/RUNNING/{flag=1;next}/Volume:/{if(flag) print $5;flag=0}' | head -n1 | sed 's/.$//'
    fi
    

} 

echo $(get-volume)

# Subscribe to volume events for the main sink in PulseAudio
pactl subscribe | while IFS= read -r line; do
    # Call the function to format and print the line.
    e=$(echo $line | awk '{ print $2,$4}')
    if [ "$e" == "'change' sink" ]; then
        v=$(get-volume)
        echo "$v"
    fi
done
