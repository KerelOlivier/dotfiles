#!/bin/bash
workspace(){
    local open=($((i3-msg -t get_workspaces | jq -r '.|sort_by(.num)|.[].num')|tr -d \'\"))
    local focussed=($((i3-msg -t get_workspaces | jq -r '.|sort_by(.num)|.[].visible')|tr -d \'\"))

    local states=(         )
    
    for ((i=0; i<${#open[@]}; i++)); do
        local f=${focussed[$i]}
        
        if ($f -eq true); then
            states[open[$i]-1]=
        else
            states[open[$i]-1]=
        fi
        
    done
    #print the states in a single line
    echo ${states[@]}

    #create

}

workspace
i3-msg -t subscribe -m '["workspace"]' | while read -r _; do
    workspace
done
