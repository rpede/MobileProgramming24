---
title: Widgets
description: >-
  This is an introduction to widgets in Flutter.
layout: default
---

<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Widgets

In Flutter the entire UI is built from widgets.
A widget serves a similar purpose es a component in Angular (React or Vue).

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-340px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

The entry point for Flutter is a call to the [runApp function](https://api.flutter.dev/flutter/widgets/runApp.html).
It takes a tree widgets and puts them on the screen.

This what the widget tree from the example above looks like:

{% include_relative simple_app.drawio.svg %}

The [Center widget](https://api.flutter.dev/flutter/widgets/Center-class.html)
simply places its content in the center of the available space.
The [Text widget](https://api.flutter.dev/flutter/widgets/Text-class.html) renders some text.

`TextDirection.ltr` tells the `Text` widget to layout its text from left-to-right (ltr).

## Android & iOS

The root for most Flutter apps is either going to be [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html) or [CupertinoApp](https://api.flutter.dev/flutter/cupertino/CupertinoApp-class.html).
They both set up defaults for theming, text direction, navigation among other things.
You will learn about navigation at a later point in time.
The difference between the two apps is that`MaterialApp` is for the [Material design](https://m3.material.io/) language which is the standard on Android.
And `CupertinoApp` is for [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) design language, which is default for iOS.

Since the design language is quite different between Material (android) and Cupertino (iOS).
Each therefore has their own set of widgets.

- [Material (Android)](https://docs.flutter.dev/ui/widgets/material)
- [Cupertino (iOS)](https://docs.flutter.dev/ui/widgets/cupertino)
- [All widgets](https://docs.flutter.dev/reference/widgets)

### Cupertino demo

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60
import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    CupertinoApp(
      title: 'Flutter Demo',
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text("Flutter Cupertino Demo")),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Showcase some widgets:'),
              CupertinoButton.filled(child: const Text("Button"), onPressed: () {}),
              CupertinoSwitch(value: true, onChanged: (_) {}),
              CupertinoSlider(value: 0.5, onChanged: (_) {}),
            ],
          ),
        ),
      ),
    ),
  );
}
```

### Android demo

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("Flutter Cupertino Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Showcasing some widgets:'),
              FilledButton(child: const Text("Button"), onPressed: () {}),
              Switch(value: true, onChanged: (_) {}),
              Slider(value: 0.5, onChanged: (_) {}),
            ],
          ),
        ),
      ),
    ),
  );
}
```

Some of the widgets that have a direct equivalent on both iOS and Android.
For those you can use a variant that automatically adapts.
See [here](https://docs.flutter.dev/platform-integration/platform-adaptations#widgets-with-adaptive-constructors) for more.

The rest of the exercises will mostly focus on Android style widgets, since it
would be a lot of extra work to provide all examples twice.
However, you are welcome to experiment with both styles.

## Widget trees

Back to widget trees.
Here is the widget tree for the Material demo above.

{% include_relative material_demo.drawio.svg %}

A couple of things to note.
[Scaffold](https://api.flutter.dev/flutter/material/Scaffold-class.html) is
used to create the basic layout for a page (or screen) in your app.
`Scaffold` can have a multiple child widgets for different commonly used layout elements.
They include:

- [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html)
- [BottomAppBar](https://api.flutter.dev/flutter/material/BottomAppBar-class.html)
- [FloatingActionButton](https://api.flutter.dev/flutter/material/FloatingActionButton-class.html)
- [Drawer](https://api.flutter.dev/flutter/material/Drawer-class.html)

Open the links to see examples of what they look like.

Some widgets have multiple child widgets.
In the case of `Scaffold` can have distinct child widgets serving different purposes.
Other widgets like `Column` have a list (array) of children that are all treated the same.