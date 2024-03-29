---
title: Push notifications
description: >-
    Make a demo app for push notifications
layout: default
---

Here we will expand the [local notifications demo](local-notifications) app with support for push notifications.

We are going to use an extension to Awesome Notifications to add push
notification support backed by FCM (Firebase Cloud Messaging).

[Awesome Notifications FCM](https://pub.dev/packages/awesome_notifications_fcm)

You will need a Apple developer account to make it work on iPhone, which is a
yearly fee of 99 USD.
So let's just ignore iOS and focus on Android.

# Installing plugin extension

We need to add some dependencies:

```sh
flutter pub add awesome_notifications_fcm firebase_core firebase_crashlytics
```

Then update `android/settings.gradle`:

```diff
@@ -21,6 +21,8 @@ plugins {
     id "dev.flutter.flutter-plugin-loader" version "1.0.0"
     id "com.android.application" version "7.3.0" apply false
     id "org.jetbrains.kotlin.android" version "1.7.10" apply false
+
+    id "com.google.gms.google-services" version "4.4.1" apply false
 }
 
 include ":app"
```

# Firebase Cloud Messaging

Go to [Firebase Console](https://console.firebase.google.com/) and create a project.

![](../fcm_create_project1.png)

![](../fcm_create_project2.png)