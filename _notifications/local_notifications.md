---
title: Local notifications
description: >-
  A simple app implementing local notifications
layout: default
---

![](../local_notification_screenshot1.png)
![](../local_notification_screenshot2.png)

We will be using the
[awesome_notifications](https://pub.dev/packages/awesome_notifications) plugin.
It only supports iOS and Android (no web).

# Project setup

```sh
flutter create awesome_notifications_demo --platforms=ios,android
cd awesome_notifications_demo
flutter pub add awesome_notifications_core:^0.9.3 awesome_notifications:any
```

## Android

Following changes are shown with diff syntax.
Red lines starting with `-` should be removed.
Green lines starting with `+` should be added.
Lines starting with `@@` are just indication of lines numbers and should not be
included.

Make the following changes to `android/app/build.gradle`.

```diff
@@ -24,7 +24,7 @@ if (flutterVersionName == null) {

 android {
     namespace "com.example.awesome_notifications_demo"
-    compileSdk flutter.compileSdkVersion
+    compileSdkVersion 34
     ndkVersion flutter.ndkVersion

     compileOptions {
@@ -45,8 +45,8 @@ android {
         applicationId "com.example.awesome_notifications_demo"
         // You can update the following values to match your application needs.
         // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
-        minSdkVersion flutter.minSdkVersion
-        targetSdkVersion flutter.targetSdkVersion
+        minSdkVersion 21
+        targetSdkVersion 34
         versionCode flutterVersionCode.toInteger()
         versionName flutterVersionName
     }

```

Add permissions to `android/app/src/main/AndroidManifest.xml`.

```diff
@@ -1,4 +1,6 @@
 <manifest xmlns:android="http://schemas.android.com/apk/res/android">
+    <uses-permission android:name="android.permission.VIBRATE"/>
+    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
     <application
         android:label="awesome_notifications_demo"
         android:name="${applicationName}"

```

You also need an icon for notifications on Android.
We can just copy `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` to
`android/app/src/main/res/drawable/app_icon.png`.

## iOS

TODO

# Starting point

## Theming

We are going to use colors a couple of different places.
To keep it consistent we will start by defining some constants for it.

`lib/theme.dart`

```dart
import 'package:flutter/material.dart';

const brandColor = Colors.deepPurple;

final theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: brandColor, brightness: Brightness.light));

final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: brandColor, brightness: Brightness.dark));
```

## Scaffold

Replace the counter demo app with our own scaffold using color scheme defined
above.

```dart
import 'package:flutter/material.dart';

import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  final title = 'Local Notifications Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: title,
      color: brandColor,
      theme: theme,
      darkTheme: theme,
      home: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Text("TODO"),
      ),
    );
  }
}
```

Nothing fancy.
Moving on.

# Notification

## The plugin

Here is a quick overview of the parts on the plugin API we will be using.

*Just for illustration. Don't add it to your app (yet).*

### Initialization

The plugin needs to be initialized before `runApp` is called.

```dart
AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
  'resource://drawable/app_icon',
  [
    NotificationChannel(
      channelGroupKey: 'basic_channel_group',
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: brandColor,
    )
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: 'basic_channel_group',
      channelGroupName: 'Basic group',
    )
  ],
  debug: true,
);
```

The first parameter is an icon to use for notifications on Android.
It is the file you copied in the setup step for Android.

Next we have some channel stuff.
Apps can show notifications for different reasons.
Channels allows the user to customize which notifications they receive from the
app.

![](../notification_permission_channel.png)

The `channelKey` is important.
When creating a notification we use the same value to indicate what channel the
notification belongs to.
It is a good idea to make it a constant.

### Listeners / callbacks

We can register listeners/callbacks for different notification events.

```dart
AwesomeNotifications().setListeners(
  onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  onNotificationCreatedMethod:
      NotificationController.onNotificationCreatedMethod,
  onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayedMethod,
  onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceivedMethod,
);
```

## Build abstraction

It is often a good idea to wrap your external dependencies in an abstraction.
There are multiple reasons for this.

1. It can encapsulate some of the complexity of the package behind an interface
that expose just what you need in your application.
2. It simplifies migration should a new version of the package come out with API
changes.
3. It makes it easier to switch the dependency out for something else (like
[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)).

Awesome Notifications plugin got a fairly simple interface already.
But we are still going to hide it in an abstraction for the above mentioned
reasons.

```dart
class NotificationService {
  /// Invoke before `runApp`
  Future<bool> initialize() {
    return AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: brandColor,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        )
      ],
      debug: true,
    );
  }

  /// Register callbacks for the notification.
  Future<bool> setupCallbacks() async {
    // Only after at least the action method is set, the notification events are delivered
    final success = await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    return success;
  }

/// Request permission from OS to show notifications, if it isn't allowed already
  Future<bool> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  int _lastId = 0;

  /// Create a notification
  show({String? title, String? body, Map<String, String?>? payload}) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _lastId++,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }
}
```

# Received action

Here is an exempt of what data we can find in `ReceivedAction`.
It is formatted as JSON for easy reading.

The result of `jsonEncode(receivedAction.toMap())`.

```json
{
  "id": 1,
  "channelKey": "basic_channel",
  "title": "test",
  "body": "test",
  "payload": { "text": "test" },
  "actionType": "Default",
  "createdSource": "Local",
  "createdLifeCycle": "Foreground",
  "displayedLifeCycle": "Foreground",
  "createdDate": "2024-03-27 20:39:29",
  "displayedDate": "2024-03-27 20:39:29",
  "actionDate": "2024-03-27 20:39:32",
  "actionLifeCycle": "Background",
}
```
