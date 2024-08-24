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
$APP_DIR/lcd &
$APP_DIR/reader &


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
