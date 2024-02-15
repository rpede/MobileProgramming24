---
title: Photos
description: >-
    A photo/camera with navigation between screens
layout: default
---

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

  _onMenuTap(BuildContext context, Widget Function({Key? key}) ctor) {
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => ctor.call()),
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

