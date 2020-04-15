#!/bin/bash

PLASMA_VERSION=$(plasmashell --version | cut -c15,16,17,18)
LOCAL_DIR=~/.local/share/plasma/plasmoids
SYSTEM_DIR=/usr/share/plasma/plasmoids

versions=(5.18.4)

if [ $PLASMA_VERSION != 18.4 ]
then
    echo Unsupported version of plasma.
    echo Currently supported versions of plasma:
    echo ${versions[*]}
    read -r -p "Would you like to run the script nevertheless? (y/N)" response
    if [[ "$response" =~ ^([yY])$ ]]
    then
        rm -rf $LOCAL_DIR/org.kde.plasma.private.systemtray 2> /dev/null
        rm -rf $LOCAL_DIR/org.kde.plasma.systemtray 2> /dev/null
        cp $SYSTEM_DIR/org.kde.plasma.private.systemtray $LOCAL_DIR/
        cp $SYSTEM_DIR/org.kde.plasma.systemtray $LOCAL_DIR/
        sed -i '/import QtQuick.Layouts 1.12/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/ExpandedRepresentation.qml
        sed -i 's/Layout.minimumHeight: units.gridUnit \* 21/Layout.minimumHeight: Screen.desktopAvailableHeight/' $LOCAL_DIR/ExpandedRepresentation.qml
        sed -i '/import QtQuick.Layouts 1.1/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/main.qml
        sed -i 's/visualParent: root//g' $LOCAL_DIR/main.qml
        read -r -p "Would you like for the systemtray to come out from the left or right side fo the screen? (R/l) " response
        if [[ "$response" =~ ^([lL])$ ]]
        then
            sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.LeftEdge/1' $LOCAL_DIR/main.qml
            sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth/' $LOCAL_DIR/main.qml
        else
            sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.RightEdge/1' $LOCAL_DIR/main.qml
            sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth - dialog.width/' $LOCAL_DIR/main.qml
        fi
        echo Systemtray successfully modified, to actually use the edited systemtray, remove the existing widget from your panel and add it again. If that does not work, then log out and log back in.
        echo It seems you\'ve run the script with an unsuported version of plasma, if the new systemtray widget does not work as intended, simply remove the following folders:
        echo $SYSTEM_DIR/org.kde.plasma.private.systemtray
        echo $SYSTEM_DIR/org.kde.plasma.systemtray
else
    rm -rf $LOCAL_DIR/org.kde.plasma.private.systemtray 2> /dev/null
    rm -rf $LOCAL_DIR/org.kde.plasma.systemtray 2> /dev/null
    #cp $SYSTEM_DIR/org.kde.plasma.private.systemtray $LOCAL_DIR/
    #cp $SYSTEM_DIR/org.kde.plasma.systemtray $LOCAL_DIR/
    sed -i '/import QtQuick.Layouts 1.12/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/ExpandedRepresentation.qml
    sed -i 's/Layout.minimumHeight: units.gridUnit \* 21/Layout.minimumHeight: Screen.desktopAvailableHeight/' $LOCAL_DIR/ExpandedRepresentation.qml
    sed -i '/import QtQuick.Layouts 1.1/ s/$/\nimport QtQuick.Window 2.2/' $LOCAL_DIR/main.qml
    sed -i 's/visualParent: root//g' $LOCAL_DIR/main.qml
    read -r -p "Would you like for the systemtray to come out from the left or right side fo the screen? (R/l) " response
    if [[ "$response" =~ ^([lL])$ ]]
    then
        sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.LeftEdge/1' $LOCAL_DIR/main.qml
        sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth/' $LOCAL_DIR/main.qml
    else
        sed -i 's/location: plasmoid.location/location: PlasmaCore.Types.RightEdge/1' $LOCAL_DIR/main.qml
        sed -i '/id: dialog/ s/$/\n        x: Screen.desktopAvailableWidth - dialog.width/' $LOCAL_DIR/main.qml
    fi
    echo Systemtray successfully modified, to actually use the edited systemtray, remove the existing widget from your panel and add it again. If that does not work, then log out and log back in.
fi
