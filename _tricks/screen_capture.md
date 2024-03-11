---
title: Screen capture
description: >
    Document various ways of capturing screenshots or screen recordings of your
    apps.
layout: default
---

# Screenshot window

## macOS

<kbd>Shift</kbd> + <kbd>Command</kbd> + <kbd>4</kbd> then <kbd>Space</kdb>

## Windows

# Screen record

## macOS

<kbd>Shift</kbd> + <kbd>Command</kbd> + <kbd>5</kbd>

Then select "Record Selected Portion".

![](../mac_screen_record.png)

## Windows

# Mirror

## iPhone

Connect your phone with lighting cable.
Open "QuickTime Player", then "File" -> "New Movie Recording".

![](../mac_mirror_iphone1.png)

Select your iPhone as Screen source.

![](../mac_mirror_iphone2.png)

## Android

You can use [scrcpy](https://github.com/Genymobile/scrcpy) to mirror your phones
scree.
(Works on all platforms).

Connect your phone with cable.

### macOS

```sh
brew install scrcpy
echo 'export PATH="/Users/rasmus/Library/Android/sdk/platform-tools:$PATH"' >> .zshrc
source .zshrc
scrcpy
```
