---
title: Push notifications
description: >-
    Make a demo app for push notifications
layout: default
---

{% include alert.html %}

![](../push_notification_app1.png)
![](../push_notification_app2.png)

# Project Setup

```sh
flutter create push_notification_demo  --platforms=android,ios
cd push_notification_demo
```

## Firebase Cloud Messaging

Android and iOS each got their own way of doing push notifications.
Android use Firebase Cloud Messaging (FCM) and iOS use Apple Push Notification
(APN).
But it is possible to link FCM to APN, such that can use FCM to send
notifications on both platforms.
I will therefore just use FCM.

[Watch the commercial](https://www.youtube.com/watch?v=sioEY4tWmLI)

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Click "Add project"
3. Type "push-notification-demo" as project name and click "Continue"
4. Turn off "Enable Google Analytics for this project" and click "Create project"

we will need to add some dependencies to the Flutter project.
Then we will install [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
and use it to connect our Flutter project to the Firebase project we just
created.

Open a terminal in your project directory.

```sh
# Install Firebase core plugin
flutter pub add firebase_core firebase_messaging

# FlutterFire CLI depends on Firebase CLI, so install it first
npm install -g firebase-tools

# Login with the Google account you used for Firebase Console.
firebase login

# Install the CLI if not already done so
dart pub global activate flutterfire_cli

# Run the `configure` command, select a Firebase project and platforms
flutterfire configure
```

The last command will give you a menu.
Use arrow keys to navigate and "Enter/Return" to select.
Here is a walkthrough of the options you need.

1. Select "push-notification-demo-xxxxx (push-notification-demo)"
2. Select "android" and "ios"

Change the `main` method in `lib/main.dart` to:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

**Note:** `DefaultFirebaseOptions.currentPlatform` is imported from `lib/firebase_options.dart` and was created by `flutterfire configure`.
It contains an API-key, so you might want to add it to `.gitignore`.

See [FlutterFire Overview](https://firebase.flutter.dev/docs/overview/) for
more.

## iOS

<div class="alert info">
This doesn't work in the in iOS Simulator.
You will need a real iPhone to try it.
</div>

There are some extra steps needed if you want iOS support.

[See instructions](https://firebase.flutter.dev/docs/messaging/apple-integration/)

# Receive messages

## Notification service

To retrieve messages from FCM we will build a service class.

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_demo/notification_controller.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<bool> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void setupCallbacks() async {
    // Handle notifications when the app is in the foreground.
    FirebaseMessaging.onMessage.listen(NotificationController.onMessage);

    // Allow you to do something when a notification have been received while
    // the app is in the background.
    FirebaseMessaging.onBackgroundMessage(
        NotificationController.onBackgroundMessage);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // Handle message if we got one.
    if (initialMessage != null) {
      NotificationController.onMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen(NotificationController.onMessage);
  }

  Stream<String?> get tokenStream async* {
    yield await messaging.getToken();
    yield* messaging.onTokenRefresh;
  }
}
```

Let's break it down.

An app needs to request permission before notifications can be shown.

```dart
Future<bool> requestPermission() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized;
}
```

The parameters for `requestPermission` are for iOS only.
You can find a description [here](https://pub.dev/documentation/firebase_messaging/latest/firebase_messaging/FirebaseMessaging/requestPermission.html).
They all have default values, so you actually don't need to specify them.

Next, we are setting up some callbacks.

```dart
void setupCallbacks() async {
  // Handle notifications when the app is in the foreground.
  FirebaseMessaging.onMessage.listen(NotificationController.onMessage);

  // Allow you to do something when a notification have been received while
  // the app is in the background.
  FirebaseMessaging.onBackgroundMessage(
      NotificationController.onBackgroundMessage);

  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // Handle message if we got one.
  if (initialMessage != null) {
    NotificationController.onMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp
      .listen(NotificationController.onMessage);
}
```

You app can either be in foreground (showing on screen), background or
terminated.

- `onMessage` is a stream that emits events when a notification is received while
the app is on foreground (showing on screen.)
- `onBackgroundMessage` is invoke when the app is in background (not showing on
screen). Don't try to update widgets from here. They don't exist since the app
isn't showing.
- `onMessageOpenedApp` is for when the app was opened by tapping on a
notification. You can update widgets from here.

## Handle messages

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_demo/main.dart';
import 'package:push_notification_demo/notification_screen.dart';

class NotificationController {
  static onMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
    MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => NotificationScreen(message),
      ),
      (route) => route.isFirst,
    );
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }
}
```

[See more](https://firebase.flutter.dev/docs/messaging/usage/)

Complete the rest of the application on your own.
You should:

1. Add a provider for `NotificationService`
2. Call `setupCallbacks()`
3. Add a way to call `requestPermissions()`
4. Implement `NotificationScreen`
5. Show the FCM token from `NotificationService.tokenStream`

## Send test message

Open console.firebase.com.
Find "Messaging" (might be hidden under Engage).
Then click "Create your first campaign".

![](../fcm_test1.png)

Select "Firebase Notification messages".
Then click "Create"

![](../fcm_test2.png)

Fill in "Notification title" and "Notification text".
Click "Send test messages".

![](../fcm_test3.png)

Add the FCM token from your device.
Then click "Test".

Check your phone.
If your app was in the foreground then you should see NavigationScreen.
If you app was in the background then you should see a notification, tap on it
to see NavigationScreen.

# Challenges

## .NET backend

Send a message the the app from a .NET backend.

First you need to add FirebaseAdmin SDK to your .NET project.

```sh
dotnet add package FirebaseAdmin --version 2.4.0
```

Then follow the steps
[here](https://firebase.google.com/docs/admin/setup#initialize-sdk) to
initialized the SDK.

**Note:** you need to initialize it with a private key file.
Do not commit the private key to a repository.

You can use `FirebaseMessaging.GetMessaging` to send a notification.
Remember that you need FCM token from your Flutter app.

## Supabase chat app

Integrate notification into the chat app you made previous week with Supabase.

The video below show much of the process.

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/CiSv9E6ZKVc?si=mVsx8CciGP5jra0G" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

You should configure your webhook on insert to `messages` table.

You can grab [Deno](https://deno.com/) from here.
Deno is basically something that allows running JavaScript/TypeScript server
side.
Similar to Node.js.