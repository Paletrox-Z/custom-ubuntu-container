#!/bin/bash

# Specify the VNC display number
DISPLAY_NUM=1
GEOMETRY="1920x1080"
DEPTH=24
USER_HOME="/home/nonroot"
PIDFILE="${USER_HOME}/.vnc/$(hostname):${DISPLAY_NUM}.pid"

export USER="nonroot"

# Function to start the VNC server
start_vnc() {
    if ! pgrep -x "dbus-daemon" > /dev/null; then
        dbus-launch --exit-with-session &
    fi
    echo "Starting VNC server on :${DISPLAY_NUM} with geometry ${GEOMETRY} and depth ${DEPTH}"
    vncserver -kill :${DISPLAY_NUM} > /dev/null 2>&1 || true  # Clean up previous instances
    vncserver -depth ${DEPTH} -geometry ${GEOMETRY} :${DISPLAY_NUM}
    echo "Once you are done, please hit Ctrl + C to break and delete the container"
}

# Function to stop the VNC server
stop_vnc() {
    echo "Stopping VNC server on :${DISPLAY_NUM}"
    vncserver -kill :${DISPLAY_NUM}
}

# Trap SIGTERM to stop the VNC server on container exit
trap stop_vnc SIGTERM

# Start the VNC server
start_vnc

# Keep the container running and allow the VNC server to continue
tail -f /dev/null