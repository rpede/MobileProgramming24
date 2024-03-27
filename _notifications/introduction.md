---
title: Introduction to notifications
description: >-
    How notifications work
layout: default
---

Notifications are those small messages you see overlay on your screen when your
alarm goes of, you get a text etc.

They can be delivered in two ways.

## Local notifications

Local notifications is where the app on your phone sends a notification to the
operating system it is running on.
This is how the alarm works.

This is pretty simple.
The app just needs to say to the OS "show this notification" and if notification
permissions is enabled for the app, the OS will show the it.

When making a cross platform app that shows local notifications you will have to deal with the platform differences.
We can mostly avoid writing platform specific code in Flutter, because Flutter
can render widgets equally on all supported platforms.
Notifications however can't rendered by Flutter.
They are rendered by the OS.
So we need to tell the OS to show notifications.

Each platform got its own notification API.
There are differences in how notifications work and what features they support.
In addition, your app needs permission to even show notifications.
This also works differently depending on the OS.

# Push notifications

The other way is push notifications.
This is where a services is pushing a notification to a specific device.
A service can't just contact a device directly.
The IP address of a device changes all the time, especially for mobile devices.
And the device will almost always be behind a NAT (network address translation).

For push notifications to work, it requires that the device subscribe to a
broker, through which the service can deliver the notifications.

{% include_relative push_notification.drawio.svg %}

Having each app subscribe to a different broker for each service is not very
efficient.
It would require that each app be running in the background maintaining a
connection a broker, which would drain battery.

Therefore, a device got one background process subscribing to one broker, which
all apps/services on the device use to deliver notifications.
This background process is part of the platform and the broker is specific to
the vendor.

- **iOS** Apple Push Notification (APN)
- **Android** Firebase Cloud Messaging (FCM)