#!/bin/bash

## Variables
LOCAL_DIR=~/.local/share/plasma/plasmoids
SYSTEM_DIR=/usr/share/plasma/plasmoids
versions=(5.18.4 5.18.5)

## Functions
PLASMA_VERSION=$(plasmashell --version | cut -c13,14,15,16,17,18)
MOD_TRAY () {
    #remove existing(if exists) user-modded systemtray.
    rm -rf $LOCAL_DIR/org.kde.plasma.private.systemtray 2> /dev/null
    rm -rf $LOCAL_DIR/org.kde.plasma.private.systemtray 2> /dev/null
    #copy system systemtray to user dir.
    cp -r $SYSTEM_DIR/org.kde.plasma.private.systemtray $LOCAL_DIR/
    cp -r $SYSTEM_DIR/org.kde.plasma.systemtray $LOCAL_DIR/
    #general modifications to tray that are required for both left and right configurations.
    sed -i '/import QtQuick.Layouts 1.12/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/ExpandedRepresentation.qml
    sed -i 's/Layout.minimumHeight: units.gridUnit \* 21/Layout.minimumHeight: Screen.desktopAvailableHeight/' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/ExpandedRepresentation.qml
    sed -i '/import QtQuick.Layouts 1.1/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
    sed -i 's/visualParent: root//g' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
    sed -i 's/up-arrow/left-arrow/g' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/ExpanderArrow.qml
    sed -i 's/down-arrow/right-arrow/g' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/ExpanderArrow.qml
    #left/roght logic.
    read -r -p "Would you like for the systemtray to come out from the left or right side fo the screen? (R/l) " response
    if [[ "$response" =~ ^([lL])$ ]]
    then #left.
        sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.LeftEdge/1' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
        sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth/' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
    else #right.
        sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.RightEdge/1' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
        sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth - dialog.width/' $LOCAL_DIR/org.kde.plasma.private.systemtray/contents/ui/main.qml
    fi
    #restart bar if requested.
    read -r -p "Systemtray successfully modified, to actually use the edited systemtray, your panel/bar/dock needs to be restarted, would you like to do that now? (Y/n)" response
    if [[ "$response" =~ ^([nN])$ ]]
    then
        :
    else
        read -r -p "Do you use the default plasma panel(D), or latte-dock(l)? (D/l)" response
        if [[ "$response" =~ ^([lL])$ ]]
        then
            latte-dock -r &
        else
            plasmashell --replace &
        fi
    fi
}

## Script logic
if [[ ! ${versions[@]} =~ $PLASMA_VERSION ]]
then
    echo Unsupported version of plasma.
    echo Currently supported versions of plasma:
    echo ${versions[*]}
    read -r -p "Would you like to run the script nevertheless? (y/N)" response
    if [[ "$response" =~ ^([yY])$ ]]
    then
        MOD_TRAY
        echo It seems you\'ve run the script with an unsuported version of plasma, if the new systemtray widget does not work as intended, simply remove the following folders:
        echo $SYSTEM_DIR/org.kde.plasma.private.systemtray
        echo $SYSTEM_DIR/org.kde.plasma.systemtray
    else
        exit
    fi
else
    MOD_TRAY
fi
