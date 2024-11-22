#!/bin/sh
xrandr --output eDP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --scale 0.99x0.99 --output DP-1 --mode 1920x1080 --pos 3840x-1280 --rotate left --scale 2x2 --output DP-2 --off --output DP-3 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off
nitrogen --restore
