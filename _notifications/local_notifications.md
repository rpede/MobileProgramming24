---
title: Local notifications
description: >-
    A simple app implementing local notifications
layout: default
---

# Project setup

```sh
flutter create local_notifications_demo --platforms=ios,android
cd local_notifications_demo
```

We will be using the
[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
plugin.

It gives you a unified API for notification features that are the same on all
platforms.
While also allowing you to access the functionality that a specific to a
platform.

Add it to you project.

```sh
flutter pub add flutter_local_notifications
```

Then you need to do some platform specific configuration.
This can be a bit tricky, so best to refer to the documentation for the plugin.

- [Android](https://pub.dev/packages/flutter_local_notifications#-android-setup)

## Android

Make the following changes to `android/app/build.gradle`.

```diff
@@ -24,10 +24,11 @@ if (flutterVersionName == null) {
 
 android {
     namespace "com.example.local_notifications_demo"
-    compileSdk flutter.compileSdkVersion
+    compileSdk 34
     ndkVersion flutter.ndkVersion
 
     compileOptions {
+        coreLibraryDesugaringEnabled true
         sourceCompatibility JavaVersion.VERSION_1_8
         targetCompatibility JavaVersion.VERSION_1_8
     }
@@ -41,12 +42,13 @@ android {
     }
 
     defaultConfig {
+        multiDexEnabled true
         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
         applicationId "com.example.local_notifications_demo"
         // You can update the following values to match your application needs.
         // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
         minSdkVersion flutter.minSdkVersion
-        targetSdkVersion flutter.targetSdkVersion
+        targetSdkVersion 33 
         versionCode flutterVersionCode.toInteger()
         versionName flutterVersionName
     }
@@ -64,4 +66,8 @@ flutter {
     source '../..'
 }
 
-dependencies {}
+dependencies {
+    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.2'
+    implementation 'androidx.window:window:1.0.0'
+    implementation 'androidx.window:window-java:1.0.0'
+}
```

You also need an icon for notifications on Android.
We can just copy `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` to
`android/app/src/main/res/drawable/app_icon.png`.

## iOS

[Read here](https://pub.dev/packages/flutter_local_notifications#-ios-setup).

*I wanted to write instructions for iOS.
But the iPhone wouldn't verify my app for a good couple of hours.*

---
