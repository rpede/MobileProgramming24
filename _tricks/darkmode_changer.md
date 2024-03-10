---
title: Dark-mode changer
layout: default
---

{% include dart_embed %}

Have you ever wanted to add a way to change between light and dark mode in your
application?

Here is a simple way to let users change the brightness of your app.

```run-dartpad:mode-flutter:height-800px
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) => MaterialApp(
        title: 'Charts Examples',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: ThemeChanger(),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final modes = [
      (ThemeMode.system, Icons.invert_colors),
      (ThemeMode.dark, Icons.dark_mode),
      (ThemeMode.light, Icons.light_mode),
    ];
    return DropdownButton(
      value: MyApp.themeNotifier.value,
      items: [
        for (final (mode, icon) in modes)
          DropdownMenuItem(
            value: mode,
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(mode.name),
              ],
            ),
          ),
      ],
      onChanged: (value) {
        MyApp.themeNotifier.value = value as ThemeMode;
      },
    );
  }
}
```

The `ThemeChanger` widget can anywhere in the application.

A
[ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)
is used.
It is a wrapper for a single immutable type, allowing observers to get notified
when the wrapped value is changed.

Those changes are listened to by a
[ValueListenableBuilder](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html)
widget.
It rebuilds using the `builder` function each time the value listened to changes.

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/s-ZG-jS5QHQ?si=mdkhajuuDpvJzVpp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
