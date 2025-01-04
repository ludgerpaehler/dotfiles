#!/bin/sh

# Terminate already running instances
killall -q polybar

# Wait for the processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar(s)
#MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

#MONITORS=$MONITORS polybar top &
#MONITORS=$MONITORS polybar bottom;

polybar base &

echo "Bars launched..."

