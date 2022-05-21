# SysTrayModder

Script to make the Plasma system tray behave like a sidebar.

Hasn't been tested against all versions of Plasma, use at your own risk.

## What does this script do?

Copies your preexisting system tray widget that comes bundled with Plasma, and edits it so that the height of the tray takes up the entire available vertical space, and makes it so that the tray pops out from either side of the screen.

## Why copy the bundled tray, and not fork the system tray widget?

Forking the system means having to keep up development with upstream to guarantee comparability and system security, which in and of itself isn't a bad thing, but that takes a lot of man-hours, and I don't want the responsibility. With this script, it is up to the user to run the script every time there is an update to the system tray widget.

## How do I make it do its magic?

Run patcher.sh to see usage.

1. `git clone https://github.com/opekope2/SysTrayModder.git`
2. `cd SysTrayModder`
3. `./patcher.sh`

## What does it look like in the end?

![Preview](preview.gif)
