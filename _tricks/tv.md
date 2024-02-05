---
title: Port to TV
layout: default
---

Here are instructions on how to port you Flutter application to Android TV and Google TV.

<iframe src="https://easv.cloud.panopto.eu/Panopto/Pages/Embed.aspx?id=ecc75711-7dae-41e3-a37e-b0fc0155565f&autoplay=false&offerviewer=true&showtitle=true&showbrand=true&captions=false&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay" aria-label="Panopto Embedded Video Player"></iframe>

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