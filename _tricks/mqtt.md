---
title: MQTT
description: >-
    Example of controlling a IoT device over MQTT v3
layout: default
---

{% include alert.html %}

<div class="alert warning">
<b>Supports: MQTT v3(3.1 and 3.1.1)</b>
<br>
Doesn't work with MQTT v5
</div>

 <video width="100%" controls>
  <source src="../mqtt_light_demo.webm" type="video/webm">
</video> 

# Project

## [Link](https://github.com/rpede/MiniProjectSolution/)

There are 3 projects in the repository.

**iot_light**

Simulates a IoT "smart" light that can be turned on an off.
It prints an ASCII art representation of the light each time its power state
changes.

Program exits when you hit <kdb>Enter</kdb>.

**light_controller**

Is a Flutter app that can control (send on/off commands to) the IoT light.
It also displays an indication of the power status using emojis.

- 🤔 = Unknown (haven't seen status for the light yet)
- 💡 = Lights on
- 🌃 = Light off

*Emojis might look different depending on the font*

**light_protocol**

Contains protocol code shared between **iot_light** and **light_controller**.

# Getting started

The setup requires that you run broker, iot_light and light_controller at the
same time.

## MQTT broker

First you need a MQTT broker.
If you want to try the Flutter app in a web-browser then you need a broker that
supports MQTT over WebSocket.

I have only tested with [Mosquitto](https://mosquitto.org/) as broker.
Repository contains a configuration file for it.

```sh
mosquitto -c mosquitto.conf
```

## IoT Light

If you use a different broker you need to adjust server, port and credentials in
`iot_light/bin/iot_light.dart`.

```sh
cd iot_light
dart run
```

## Light controller

Works on Chrome and Android.
Additional work might be needed for iOS.

If you use a different broker then you will need to adjust server, port and
credentials in `light_controller/lib/main.dart`.

### Browser

Running the app in a browser requires a broker that supports MQTT over
WebSocket.

```sh
cd light_controller
flutter run -d chrome
```

### Android

The Android emulator got its own IP stack.
So, `localhost` inside the emulator won't be the same as your host OS (mac,
win).
Connecting to `10.0.2.2` will allow it to connect to a broker on your host OS.
[See more](https://developer.android.com/studio/run/emulator-networking.html).

Start the Android emulator (or connect a real device), then do:

```sh
cd light_controller
flutter run
```

# How it works

## Protocol

With MQTT, you can publish and subscribe to topics.
It doesn't care about how messages are structured.
This project uses JSON to structure messages.

The controller sends commands to the Light on one topic.
IoT light responds to commands with a status on another topic.

{% include_relative mqtt_light_protocol.drawio.svg %}

The messages are defined
[here](https://github.com/rpede/flutter_mqtt/blob/main/light_protocol/lib/src/messages.dart)
and the protocol is defined
[here](https://github.com/rpede/flutter_mqtt/blob/main/light_protocol/lib/src/protocol.dart).

