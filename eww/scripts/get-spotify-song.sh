#!/bin/bash

SP_DEST="org.mpris.MediaPlayer2.spotify"
SP_PATH="/org/mpris/MediaPlayer2"
SP_MEMB="org.mpris.MediaPlayer2.Player"

isRunning(){
    local status="$(qdbus|grep -i MediaPlayer2.spotify)"
    # return if spotify is not running
    if [ -z "${status}" ]; then
        false
    else
        true
    fi
}
icon(){
    local status="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:'PlaybackStatus'| grep -i -o playing)" 
    if [ -n "${status}" ]; then
        echo "󰐊"
    else
        echo "󰏤"
    fi
}
title(){
    if isRunning ; then
        local title="$(metadata |grep title|cut -c 7-)"
        echo $(icon) $title
    fi
    
}
metadata(){

    dbus-send                                                        \
    --print-reply                                  `# We need the reply.`       \
    --dest=$SP_DEST                                                             \
    $SP_PATH                                                                    \
    org.freedesktop.DBus.Properties.Get                                         \
    string:"$SP_MEMB" string:'Metadata'                                         \
    | grep -Ev "^method"                           `# Ignore the first line.`   \
    | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' `# Filter interesting files.`\
    | sed -E '2~2 a|'                              `# Mark odd fields.`         \
    | tr -d '\n'                                   `# Remove all newlines.`     \
    | sed -E 's/\|/\n/g'                           `# Restore newlines.`        \
    | sed -E 's/(xesam:)|(mpris:)//'               `# Remove ns prefixes.`      \
    | sed -E 's/^"//'                              `# Strip leading...`         \
    | sed -E 's/"$//'                              `# ...and trailing quotes.`  \
    | sed -E 's/"+/|/'                             `# Regard "" as seperator.`  \
    | sed -E 's/ +/ /g'                            `# Merge consecutive spaces.`
}
title
