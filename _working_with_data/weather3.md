---
title: Weather
description: Part 2 - Location
layout: default
---

# Introduction

Here we will address a major flaw that our weather app have had up until now.
That is that the location is hardcoded.

# Location service

It would be pretty nice if the app just knew where you are located and shows
weather information based on that.

The answer is of cause to use the devices location service.

## Plugin

There are two popular plugins that allows you to take advantage of the mobiles
location service.

- [location](https://pub.dev/packages/location)
- [geolocator](https://pub.dev/packages/geolocator)

**Geolocator** got most likes but the setup seems a bit more complicated than the
**location** plugin.
So we are going with **location**.

Add the package:

```sh
flutter pub add location
```

## Permissions

### Android

For Android, edit `android/app/src/main/AndroidManifest.xml` so it contains:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Location permissions-->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

    <!-- Network permissions-->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

You should already have the network permissions from previously.
Stating network permissions is only really necessary when building a release
APK (Android Package).

You also need to update the minimum SDK version, as is common for many plugins.
Edit `android/app/build.gradle` to include:

```gradle
android {
    // ...
    defaultConfig {
      minSdk 21
      // ...
    }
}
```

I was getting this error:

```
┌─ Flutter Fix ──────────────────────────────────────────────────────────────────────────────┐
│ [!] Your project requires a newer version of the Kotlin Gradle plugin.                     │
│ Find the latest version on https://kotlinlang.org/docs/releases.html#release-details, then │
│ update                                                                                     │
│ /home/owrflow/work/CoursePreparation/MobileProgramming/code/weather2/android/build.gradle: │
│ ext.kotlin_version = '<latest-version>'                                                    │
└────────────────────────────────────────────────────────────────────────────────────────────┘
Error: Gradle task assembleDebug failed with exit code 1
```

Which I fixed by changing `android/settings.gradle`.

```gradle
-    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
+    id "org.jetbrains.kotlin.android" version "1.9.23" apply false
```

Found a solution here [Required Kotlin
version](https://docs.flutter.dev/release/breaking-changes/kotlin-version).

### iOS

For iPhones, add the following lines to `ios/Runner/Info.plist`, inside the
plist->dict tag:

```plist
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Give accurate weather info based on you current location.</string>
```

If you click "Open iOS/macOS module in Xcode" then the Runner/Info file should look like this:

![Location permission in Xcode](../ios_location_permission.png)

*Note: for iOS you have to give a description of why your app needs permission.
They will likely reject it in the App Store if they don't find the reason to be
valid.*

### Inside the app

If you had trouble with the above, you might want to check the [docs for
location](https://docs.page/Lyokone/flutterlocation/getting-started).