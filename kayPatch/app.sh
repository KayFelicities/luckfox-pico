#!/bin/bash

# force remove S21appinit
if [ -e /etc/init.d/S21appinit ]; then
    rm -f /etc/init.d/S21appinit && reboot
fi

APP_DIR=/userdata/apps
MODULE_DIR=/userdata/modules

# modules
insmod $MODULE_DIR/soft_uart.ko

# watchdog
checkApps() {
    if ! pidof $1 >/dev/null; then
        chmod +x $APP_DIR/$1 && $APP_DIR/$1 >/dev/null &
    fi
}

# daemon
hookQuit() {
    echo "app quit"
    kill $(pidof watchdog)
    exit 0
}
trap 'hookQuit' INT QUIT TERM

# wait
while true; do
    checkApps lcd
    checkApps reader
    sleep 5
done
