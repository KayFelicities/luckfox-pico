#!/bin/bash

FACTORY_DIR=/factory
SHARE_DIR=/userdata/share
APP_DIR=/userdata/apps
MODULE_DIR=/userdata/modules

# factory copy
if [ ! -d $APP_DIR ]; then
    cp -a $FACTORY_DIR/* /
fi

# modules
insmod $MODULE_DIR/uartIR.ko

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
