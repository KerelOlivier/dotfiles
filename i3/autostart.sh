#!/bin/bash
picom --experimental-backends &
nitrogen --restore &

eww daemon
eww open topbar

#SP monitor setup
#xrandr --output HDMI-A-0 --above eDP &
