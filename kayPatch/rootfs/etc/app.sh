#!/bin/bash

FACTORY_DIR=/userdata/factory
SHARE_DIR=/userdata/share
APP_DIR=/userdata/apps
MODULE_DIR=/userdata/modules

# first boot
if [ -e /etc/init.d/S21appinit ]; then
    [ -d $FACTORY_DIR/plan ] && cp -a $FACTORY_DIR/plan/ $SHARE_DIR/
    rm -f /etc/init.d/S21appinit && reboot
fi

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
