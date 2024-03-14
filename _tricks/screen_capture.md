---
title: Screen capture
description: >
    Document various ways of capturing screenshots or screen recordings of your
    apps.
layout: default
---

# Screenshot window

## macOS

1. <kbd>Shift</kbd> + <kbd>Command</kbd> + <kbd>4</kbd> then <kbd>Space</kbd>
2. Click on the window you want to screenshot

## Windows

1. <kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>
2. Click on the window you want to screenshot

# Screen record

## macOS

1. <kbd>Shift</kbd> + <kbd>Command</kbd> + <kbd>5</kbd>
2. Select "Record Selected Portion".

![](../mac_screen_record.png)

## Windows

1. Focus window you want to record
2. <kbd>Windows</kbd> + <kbd>G</kbd>
3. <kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd>

# Mirror

## iPhone

Connect your phone with lighting cable.
Open "QuickTime Player", then "File" -> "New Movie Recording".

![](../mac_mirror_iphone1.png)

Select your iPhone as Screen source.

![](../mac_mirror_iphone2.png)

## Android

You can use [scrcpy](https://github.com/Genymobile/scrcpy) to mirror your phones
screen.
(Works on all platforms).

Connect your phone with cable.
Make sure USB Debugging is enabled.

### macOS

Terminal:

```sh
brew install scrcpy
echo 'export PATH="/Users/rasmus/Library/Android/sdk/platform-tools:$PATH"' >> .zshrc
source .zshrc
scrcpy
```

### Windows

1. [Download scrcpy zip](https://github.com/Genymobile/scrcpy/blob/master/doc/windows.md)
2. Extract All...
3. Right-click inside the folder with the extracted files, then "Open in Terminal"
4. Type `scrcpy.exe`