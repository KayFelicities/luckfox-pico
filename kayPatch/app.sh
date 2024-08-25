#!/bin/bash

# force remove S21appinit
if [ -e /etc/init.d/S21appinit ]; then
    rm -f /etc/init.d/S21appinit && reboot
fi

APP_DIR=/userdata/apps
MODULE_DIR=/userdata/modules

# modules
insmod $MODULE_DIR/soft_uart.ko


# start apps
chmod +x $APP_DIR/lcd && $APP_DIR/lcd >/dev/null &
chmod +x $APP_DIR/reader && $APP_DIR/reader >/dev/null &


# daemon
hookQuit() {
    echo "app quit"
    kill $(pidof watchdog)
    exit 0
}
trap 'hookQuit' INT QUIT TERM

# wait
while true; do
    sleep 1
done
