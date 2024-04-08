---
title: Local notifications
description: >-
  A simple app implementing local notifications
layout: default
---

![](../local_notification_screenshot1.png)
![](../local_notification_screenshot2.png)
![](../local_notification_screenshot_ios.png)

<iframe src="https://easv.cloud.panopto.eu/Panopto/Pages/Embed.aspx?id=ff4e3c90-951b-4db9-9fc2-b14c0138d334&autoplay=false&offerviewer=true&showtitle=true&showbrand=true&captions=false&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay" aria-label="Panopto Embedded Video Player" aria-description="Local Notifications" ></iframe>

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

[🍎 Configuring iOS for Awesome Notifications](https://pub.dev/packages/awesome_notifications#-configuring-ios-for-awesome-notifications)

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

[Read more](https://pub.dev/packages/awesome_notifications#-notification-channels)

A small side-note.
`AwesomeNotifications` is just a simple wrapper around a platform specific
singleton.
Plugins like this, are some of the rare cases where the [singleton
pattern](https://en.wikipedia.org/wiki/Singleton_pattern) is a good idea.

### Listeners / callbacks

We can register listeners/callbacks for different notification events.
The callbacks either need to be top-level functions or static methods.

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

All callbacks are set to static methods on a NotificationController class.
We will look at the controller a bit later.

### Permissions

Before the app can create notifications it needs permission to do so.

```dart
bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
if (!isAllowed) {
    isAllowed =
        await AwesomeNotifications().requestPermissionToSendNotifications();
}
```

It is good practice to inform the user why the app wants to create notifications
before requesting permission.

The user might deny.
In which case you can't get the permission dialog to show again.
The best you can to is to instruct the user on why it is important and how to
enable it.

[Read more](https://pub.dev/packages/awesome_notifications#-requesting-permissions)

### Create notification

When the plugin is initialized, callbacks are configured and the app got
permission granted, we can create notifications.

```dart
int lastId = 0;

AwesomeNotifications().createNotification(
  content: NotificationContent(
    id: lastId++,
    channelKey: 'basic_channel',
    actionType: ActionType.Default,
    title: title,
    body: body,
    payload: payload,
    color: brandColor,
  ),
);
```

Remember the `channelKey` from the initialization step?
We need to use a channel key that is an exact match when sending notifications.

The `id` should be different for each notification.
It can be used to update an existing notification.

Payload is some data that can be attached to the notification.
Our app can access the data from one of the callbacks.

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

*Add this to your code*

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

## Callbacks

Lets define the callback handlers.

```dart
class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => NotificationScreen(receivedAction),
      ),
      (route) => route.isFirst,
    );
  }
}
```

The `@pragma("vm:entry-point")` is because the callbacks will be invoked from
native code via the plugin.

Did you notice that we had a `navigatorKey` in the `MyApp`?
We use it in the last callback so we can access the `Navigator` so we can change
routes.

A [Key](https://api.flutter.dev/flutter/foundation/Key-class.html) can be used
to refer to a specific widget.
Think of it like the [HTML id
attribute](https://www.w3schools.com/htmL/html_id.asp).

# UI

Let's write the presentation layer.
It is going to be really basic.

## Main

Change the main method to initialize the plugin through our
`NotificationService`.
Then use `Provider` to allow other part of the app to access it.

```dart
void main() async {
  final notification = NotificationService();
  await notification.initialize();
  runApp(Provider<NotificationService>.value(
    value: notification,
    child: const MyApp(),
  ));
}
```

Providing dependencies makes it easy to swap out the implementation for
something else when testing.

## MyApp

Convert `MyApp` to a `StatefulWidget`.
Then add an override for `initState`.

```dart
@override
void initState() {
  super.initState();
  context.read<NotificationService>().setupCallbacks();
}
```

And replace body of `Scaffold` in the build method.

```dart
      home: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: const NotificationForm(),
      ),
```

## Notification form

We got a couple of input fields for values in the notification.
A button to request permission.
And a button to show a notification.

The familiar [provider](https://pub.dev/packages/provider) pattern is used to
access `NotificationService`.


```dart
class NotificationForm extends StatefulWidget {
  const NotificationForm({super.key});

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _payloadController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              context.read<NotificationService>().requestPermission();
            },
            child: Text("Request permission"),
          ),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          spacer,
          TextFormField(
            controller: _bodyController,
            decoration: const InputDecoration(label: Text("Body")),
          ),
          spacer,
          TextFormField(
            controller: _payloadController,
            decoration: const InputDecoration(label: Text("Payload")),
          ),
          spacer,
          ElevatedButton(
            onPressed: () {
              context.read<NotificationService>().show(
                title: _titleController.text,
                body: _bodyController.text,
                payload: {"text": _payloadController.text},
              );
            },
            child: const Text("Show notification"),
          )
        ],
      ),
    );
  }
}

const spacer = SizedBox(height: 8);
```

Here is what it looks like.

![](../notification_form.png)

## NotificationScreen

A simple screen that will show the data that notification callback receives.

```dart
class NotificationScreen extends StatelessWidget {
  const NotificationScreen(this.receivedAction, {super.key});

  final ReceivedAction receivedAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Received notification")),
      body: Column(
        children: [
          const Text("Received action:"),
          Text(receivedAction.toMap().toString()),
        ],
      ),
    );
  }
}
```

### Received action

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

Can you guess what all the fields are?

# Done

That's it.
Try it out.

[Complete code](https://github.com/rpede/awesome_notifications_demo)

The [Awesome Notifications](https://pub.dev/packages/awesome_notifications)
plugin can do a lot more.
Familiarize yourself with the documentation.