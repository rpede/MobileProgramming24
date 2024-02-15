---
title: Photos
description: >-
    A photo/camera with navigation between screens
layout: default
---

# Shortcut

Here is another shortcut you should try to practice.

**Go to declaration**

To see how something in the code is defined.

- Windows: <kbd>Control</kbd> + <kbd>B</kbd>  or <kbd>Control</kbd> + <kbd>Left-click</kbd>
- macOS: <kbd>Command</kbd> + <kbd>B</kbd> or <kbd>Command</kbd> +
<kbd>Click</kbd>

You can also right-click -> "Go To" -> "Declaration or Usages".

# Setup

Create a new project and open it in Android Studio.

```sh
flutter create photos --platform=android,ios,web
```

*Note: We will be using a plugin to access camera that isn't supported on desktop platforms.
Not all plugins for Flutter are supported on all the platforms that Flutter itself supports.*

# Home screen

Replace `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
```

Add a new file `lib/home_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:photos/app_drawer.dart';

const appTitle = 'Photos';
const appDescription =
    "This is a small app I wrote for my Mobile Programming class."
    "It demonstrates how to navigate between screens and use camera.";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(appTitle, style: textTheme.headlineLarge),
              const Divider(),
              const Spacer(),
              Text(appDescription, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
```

# Adding an image

The screen looks a bit bland.
Let's fix that by adding a nice image to HomeScreen.

## Finding an image

Find an image you want to use.
I got mine from [Lexica](https://lexica.art/).
But you can use whatever image you like.
Just be sure to save it to `images/camera.jpg` (within the project).

## Bundle assets

Asset files can be bundled into the application.
To do that we need to edit `pubspec.yaml`
Under `flutter` section you want to add:

```yml
  assets:
    - images/camera.jpg
```

Pay attention to whitespace.
You can look at the comments for example.

The section should look like this (without the comments).

```yml
flutter:
  uses-material-design: true

  assets:
    - images/camera.jpg
```

## Display it

To show the image, add the following to the build method in HomeScreen.
Between Divider and Spacer.

```dart
Image.asset('images/camera.jpg')
```

Run the app and marvel at your creation 🤩.

# Navigation

We need a couple of more screens so we have something to navigate between.

## More screens

Add a file `lib/camera_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Camera")));
  }
}
```

Add a file `lib/gallery_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Gallery")));
  }
}
```

## What are the options

Now that we have a couple of screens to play around with.
We need a way to navigate between them.

Commonly apps either uses tabs or a drawer for navigation.

**Drawer**

<div style="display: flex;">
    <div style="flex: 50%;">
        <p>Closed</p>
        <img alt="Picture showing a closed drawer" src="../drawer_closed_example.png">
    </div>
    <div style="flex: 50%;">
        <p>Opened</p>
        <img alt="Picture showing a opened drawer" src="../drawer_opened_example.png">
    </div>
</div>

**Tabs**

![Picture showing example of tabs](../tabs_example.png)

Using tabs would take up precious screen estate.
We would rather use every cm of the screen for all the beautiful pictures users
are going to take with the app.
Therefore, let's go with the drawer option.

You can read more about
[drawers](https://docs.flutter.dev/cookbook/design/drawer) and
[tabs](https://docs.flutter.dev/cookbook/design/tabs) in the official Flutter
docs.

## Implementing a drawer

Add a file `lib/app_drawer.dart` with:

```dart
import 'package:flutter/material.dart';

import 'camera_screen.dart';
import 'gallery_screen.dart';
import 'home_screen.dart';

const menu = {
  'Home': HomeScreen.new,
  'Camera': CameraScreen.new,
  'Gallery': GalleryScreen.new,
};

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  _onMenuTap(BuildContext context, Widget Function({Key? key}) constructor) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => constructor.call()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.greenAccent, Colors.blue],
              ),
            ),
            child: Text('Photos', style: textTheme.titleLarge),
          ),
          for (final entry in menu.entries)
            ListTile(
              title: Text(entry.key),
              onTap: () => _onMenuTap(context, entry.value),
            ),
        ],
      ),
    );
  }
}
```

That's a mouthful.
Let's break it down.

## Defining the menu

```dart
const menu = {
  'Home': HomeScreen.new,
  'Camera': CameraScreen.new,
  'Gallery': GalleryScreen.new,
};
```

Is the definition of the menu the drawer will show.
It is a map where the key is the name of the menu item.
Value is the screen to navigate to when item has been selected.

The `.new` part gives us a reference to the primary constructor.
By invoking it we will get an instance of the class.

## Show a different page/screen

```dart
_onMenuTap(BuildContext context, Widget Function({Key? key}) constructor) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => constructor.call()),
  );
}
```

The `Widget Function({Key? key})` is a function that optionally takes a key as
parameter and returns a widget.
So basically the signature of a widget constructor.
The constructor can be invoked with `ctor.call()` thereby returning the widget.

[MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
provides a
[Navigator](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
which is what we use to change to a different screen in our app.

As you can tell, the terminology is similar to what we will find in a web
application.
With words like *route* and *page*.

By default a MaterialApp will show the widget that is given by the `home`
parameter.
The Navigator can be used to change the widget being shown.

Navigator is a child widget provided through MaterialApp's `build()` method.
A widgets `BuildContext` can be used to find specific parent widget.
Literally `Navigator.of(context)` finds an ancestor `State` object for the
`Navigator`.
If you go to the definition of the `of` function you will see
`context.findAncestorStateOfType<NavigatorState>()`.

NavigatorState maintains a stack of widgets.
The top of the stack is the widget that MaterialApp shows.
The use can pop widgets from the stack with the back-navigation button or
gesture (depending on platform).

In our case we will replace the top-most widget in the navigation stack, instead
of pushing a new widget to the stack for each navigation with the drawer.
We can replace it with the `pushReplacement()` method.

Before we can use the drawer, it needs to be added to the Scaffold on each
screen.
Here is an example:

```dart
import 'package:flutter/material.dart';
import 'package:photos/app_drawer.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      drawer: const AppDrawer(), // <-- like this
    );
  }
}
```

Go ahead and do the same with the other screens.

Try it out! Navigate 🧭 around the different screens.

# Camera action

## Install plugin

Packages for Dart and Flutter can be found at [pub.dev](https://pub.dev/).
We call it a plugin if it adds platform specific functionality to Flutter.
Which is exactly what we need to use the cameras in your phone.

Packages each have their on page on pub.dev.
The page will likely contain important information about how to get started
using the package/plugin.
Example, see [camera page](https://pub.dev/packages/camera).

That is the plugin we will be using.

Dependencies in any Dart/Flutter project is defined in the `dependencies`
section of `pubspec.yaml`.
A pubspec.yaml file in a Dart project serves a similar purpose as package.json
in a JavaScript/Node.js project.

We can either add dependencies directly to pubspec.yaml or use the CLI.
Lets add it with the CLI:

```sh
flutter pub add camera
```

Notice that `camera` got added to pubspec.yaml file.
Since we didn't specify a version it added the latest.

If you want to run the app on a iPhone then you will need to add the following
to `ios/Runner/Info.plist`.

```xml
<key>NSCameraUsageDescription</key>
<string>Take photos with the app</string>
<key>NSMicrophoneUsageDescription</key>
<string>Take photos with the app</string>
```

For Android, you need to edit `android/app/build.gradle`.

Find:

```gradle
minSdkVersion flutter.minSdkVersion
```

Change it to:

```gradle
minSdkVersion 21
```