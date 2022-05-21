#!/bin/bash

LOCAL_DIR=~/.local/share/plasma/plasmoids
SYSTEM_DIR=/usr/share/plasma/plasmoids

prepare_local_dir () {
    mkdir -p $LOCAL_DIR

    rm -rf $LOCAL_DIR/$1.systemtray 2> /dev/null
    rm -rf $LOCAL_DIR/$1.private.systemtray 2> /dev/null

    cp -r $SYSTEM_DIR/$1.systemtray $LOCAL_DIR/
    cp -r $SYSTEM_DIR/$1.private.systemtray $LOCAL_DIR/

    cd $LOCAL_DIR
}

process_reload () {
    if [ "$1" == "--reload-plasma" ]; then
        plasmashell --replace &
    elif [ "$1" == "--reload-latte" ]; then
        latte-dock -r &
    fi
}

usage () {
    echo -e "Usage:\t$script <plasma|nitrux> <left|right> [--reload-plasma] [--reload-latte]"
    exit
}

script=$(basename $0)
tray=$1
side=$2
patches=$PWD

if ! [ "$side" == "left" ] && ! [ "$side" == "right" ]; then
    usage
fi

if [ "$tray" == "plasma" ]; then
    prepare_local_dir org.kde.plasma
elif [ "$tray" == "nitrux" ]; then
    prepare_local_dir org.nx
else
    usage
fi

patch -ruN -p0 -d . < $patches/$tray-$side.patch

process_reload $3
process_reload $4
