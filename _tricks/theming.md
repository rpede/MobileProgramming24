---
title: Theming
description: Customize how your app looks
layout: default
---

{% include dart_embed %}

# Color scheme

The simplest way to give your app a custom look is by making a color scheme from
a brand color.

See [Use themes to share colors and font styles](https://docs.flutter.dev/cookbook/design/themes)

```run-dartpad:theme-light:mode-flutter:run-true:width-100%:height-400px
import 'package:flutter/material.dart';

const brandColor = Colors.pink;

final theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: brandColor, brightness: Brightness.light));

final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: brandColor, brightness: Brightness.dark));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: brandColor,
      theme: theme,
      darkTheme: darkTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text("Theme demo")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Hello World"),
              ElevatedButton(onPressed: () {}, child: Text("ElevatedButton")),
              FilledButton(onPressed: () {}, child: Text("FilledButton")),
              OutlinedButton(onPressed: () {}, child: Text("OutlinedButton")),
              Switch(value: true, onChanged: (value) {}),
            ],
          ),
        ),
      ),
    );
  }
}
```

[Use themes to share colors and font
styles](https://docs.flutter.dev/cookbook/design/themes)

# Material Theme Builder

You can also use [Material Theme
Builder](https://m3.material.io/theme-builder#/custom) if you want something a
bit more fancy.

Pick your custom colors and hit "Export" -> "Flutter (Dart)" in top right
corner.

# Font

Use a custom font can really help set your app apart.

You can find a huge selection on [Google Fonts](https://fonts.google.com/).
Then follow the instructions on how to [Use a custom font](https://docs.flutter.dev/cookbook/design/fonts).

# Launch Icon

Tired of seeing the Flutter logo on your home screen for every app you make?

Flutter use different versions of the icon for different devices.
You can use the [Flutter Launcher
Icons](https://pub.dev/packages/flutter_launcher_icons) package to help change
the icon for all device types.

Just do

```sh
flutter pub add dev:flutter_launcher_icons
```

Then add the following to `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  remove_alpha_ios: true
  image_path: "icon.png"
```

Here are a couple of free sites you can use to quickly generate a custom icon:

- [Iconlab](https://appiconlab.com)
- [Canva icon maker](https://www.canva.com/create/icons/)
- [Doericon](https://doericon.com/)
- [IconKitchen](https://icon.kitchen)

*Let me know if you find other good sites.*