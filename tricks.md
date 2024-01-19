---
title: Flutter Tricks
description: >-
    This page contains various tricks that doesn't fit anywhere else.
---

# Web deploy

Deploy Flutter app for web using Firebase hosting.

## [📺 Video](https://easv.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=5e55e1da-b61c-44de-b344-b0fc010fe900)

# TV

Making Flutter apps for Android TV and Google TV.

## [📺 Video](https://easv.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=ecc75711-7dae-41e3-a37e-b0fc0155565f)

*Based on [How to create TV app using Flutter](https://mobikul.com/tv-app-using-flutter/)*

## Code snippets

To make select key work on Chromecast with Google TV you need to wrap you App widget like this:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp( /* ... */ ),
    );
  }
}
```

Then change your `android/app/src/main/AndroidManifest.xml` to include:

```xml
<manifest ...>
    <uses-feature android:name="android.software.leanback" android:required="false" />
    <uses-feature android:name="android.hardware.touchscreen" android:required="false" />

    <application
        ...
        android:banner="@drawable/banner"
        ...
    >
        <activity ...>
            <intent-filter>
                ...
                <category android:name="android.intent.category.LEANBACK_LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

Where banner is a 320x180px PNG located at `android/app/src/main/res/drawable/banner.png`.