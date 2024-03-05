---
title: Photos
description: >-
  A photo/camera with navigation between screens
layout: default
---

![Screenshot](../photos_app_screenshot.png)
![Screenshot](../photos_app_screenshot_ios.png)

# Shortcut

Here is another shortcut you should try to practice.

**Go to declaration**

To see how something in the code is defined.

- Windows: <kbd>Control</kbd> + <kbd>B</kbd> or <kbd>Control</kbd> + <kbd>Left-click</kbd>
- macOS: <kbd>Command</kbd> + <kbd>B</kbd> or <kbd>Command</kbd> +
  <kbd>Click</kbd>

You can also right-click -> "Go To" -> "Declaration or Usages".

# Setup

Create a new project and open it in Android Studio.

```sh
flutter create photos --platform=android,ios,web
```

_Note: We will be using a plugin to access camera that isn't supported on desktop platforms.
Not all plugins for Flutter are supported on all the platforms that Flutter itself supports._

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
To do that, we need to edit `pubspec.yaml` Under `flutter` section you want to
add:

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

We need a couple of more screens, so we have something to navigate between.

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

This is the definition of the menu the drawer will show.
It is a map where the key is the name of the menu item.
Value is the screen to navigate to when a menu item is selected.

The `.new` part gives us a reference to the constructor of the class.
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
[Navigator](https://api.flutter.dev/flutter/widgets/Navigator-class.html).
It is what we use to change to a different screen in our app.

As you can tell, the terminology is similar to that of web
applications.
With words like _route_ and _page_.

By default, a MaterialApp will show the widget that is given by the `home`
parameter.
The Navigator can be used to change the widget being shown.

Navigator is a child widget provided through MaterialApp's `build()` method.
A widgets `BuildContext` can be used to find specific parent widget.
Literally `Navigator.of(context)` finds a `State` object for the
`Navigator` by looking up the tree.

Try, go to the definition of the `of` function you will see
`context.findAncestorStateOfType<NavigatorState>()`.

NavigatorState maintains a stack of widgets.
The top-most is the widget that MaterialApp shows.
The user can pop widgets from the stack with the back-navigation button or
gesture (depending on platform).

In our case we will replace the top-most widget in the navigation stack, instead
of pushing a new widget to the stack for each.
We can replace the top-most widget with the `pushReplacement()` method.

Before we can use the drawer, it needs to be added to the Scaffold on each
screen.
Here is an example:

```dart
import 'package:flutter/material.dart';

import 'app_drawer.dart';

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
We call it a plugin, if it adds platform specific functionality to Flutter.
So, a plugin is what we need to access cameras on a device.

Each packages have their on page on pub.dev.
The page will likely contain important information about how to get started
using the package/plugin.
Example, see [camera - pub.dev](https://pub.dev/packages/camera).

That is the plugin we will be using.

Dependencies in any Dart/Flutter project is defined in the `dependencies`
section of `pubspec.yaml`.
The pubspec.yaml file in a Dart, serves a similar purpose as package.json
in a JavaScript/Node.js.

Take a look at the pubspec.yaml in your project.

We can either add dependencies directly to pubspec.yaml or use the CLI.
Lets add it with the CLI:

```sh
flutter pub add camera
```

Open pubspec.yaml again.
Notice that `camera` got added to pubspec.yaml file.
Since we didn't specify a version, it added the latest.

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

## Camera screen

Replace the content of `lib/camera_screen.dart` with:

```dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'camera_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraDescription? selectedCamera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        drawer: const AppDrawer(),
        body: switch (selectedCamera) {
          null => _buildCameraSelection(),
          _ => CameraWidget(
              camera: selectedCamera!,
              key: ValueKey('camera-${selectedCamera!.name}')),
        });
  }

  Widget _buildCameraSelection() {
    return FutureBuilder(
      future: availableCameras(),
      builder: (context, snapshot) {
        return Center(
          child: Column(
            children: [
              const Text('Select a camera to use:'),
              for (final camera in snapshot.data ?? <CameraDescription>[])
                _buildSelectCameraButton(camera)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectCameraButton(CameraDescription camera) {
    return OutlinedButton.icon(
      onPressed: () => setState(() => selectedCamera = camera),
      icon: switch (camera.lensDirection) {
        CameraLensDirection.front => const Icon(Icons.person),
        CameraLensDirection.back => const Icon(Icons.landscape),
        CameraLensDirection.external => const Icon(Icons.camera_alt),
      },
      label: Text(camera.name),
    );
  }
}
```

Lets break it down.

```dart
CameraDescription? selectedCamera;
```

The class `CameraDescription` holds information about a camera of the device.
Modern phones got multiple cameras, so we need a way to tell which one to use.

```dart
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      drawer: const AppDrawer(),
      body: switch (selectedCamera) {
        null => _buildCameraSelection(),
        _ => CameraWidget(
            camera: selectedCamera!,
            key: ValueKey('camera-${selectedCamera!.name}')),
      });
}
```

If we don't know what camera to use, show a camera selection.
Otherwise, show a camera widget for taking pictures (more on that later).

Your phone likely got multiple cameras.
One for average distance photos, another for wide angle, and maybe even a third
for macro.
The default camera app on your phone will attempt to seamless switch between
cameras depending on the zoom level.
Such fancy camera switching is way beyond the scope of this tutorial.
Instead, we simply list all the cameras and let the user pick the one to use.

```dart
Widget _buildCameraSelection() {
  return FutureBuilder(
    future: availableCameras(),
    builder: (context, snapshot) {
      return Center(
        child: Column(
          children: [
            const Text('Select a camera to use:'),
            for (final camera in snapshot.data ?? <CameraDescription>[])
              _buildSelectCameraButton(camera)
          ],
        ),
      );
    },
  );
}
```

The camera plugin got a function that can be used to query the device for
available cameras.
It returns a
[Future](https://api.dart.dev/stable/3.3.0/dart-async/Future-class.html) which
is similar to a Promise in JavaScript or Task in C#.

We can use a
[FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
to automatically rebuild when the Future completes.
When the Future has completed we can find the value at `snapshot.data`.

Confused? Watch the [FutureBuilder (Widget of the
Week)](https://www.youtube.com/watch?v=zEdw_1B7JHY) video.

To select a camera, we use a button.

```dart
Widget _buildSelectCameraButton(CameraDescription camera) {
  return OutlinedButton.icon(
    onPressed: () => setState(() => selectedCamera = camera),
    icon: switch (camera.lensDirection) {
      CameraLensDirection.front => const Icon(Icons.person),
      CameraLensDirection.back => const Icon(Icons.landscape),
      CameraLensDirection.external => const Icon(Icons.camera_alt),
    },
    label: Text(camera.name),
  );
}
```

The name of the camera is shown as label.
Names will likely just be a number, so an icon makes it look nicer.

Phones have a front facing (selfie) camera and multiple back facing cameras.
It could also have one that is externally connected.
Different icons are used, so the user can quickly tell them apart.

## Camera widget

Add a file `lib/camera_widget.dart` with:

```dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({required this.camera, super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Use the camera given to the widget.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // The future errored, display the error.
          return Center(child: Text(snapshot.error!.toString()));
        }
        if (!_controller.value.isInitialized) {
          // While waiting for initialization, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        } else {
          // When the Future is complete, display the preview.
          return Column(
            children: [
              // Live preview of what the camera is pointing at.
              CameraPreview(_controller),
              // Button for taking pictures.
              _takePictureButton(context),
            ],
          );
        }
      },
    );
  }

  Widget _takePictureButton(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return FloatingActionButton(
      // Provide an onPressed callback.
      onPressed: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and then get the location
          // where the image file is saved.
          final image = await _controller.takePicture();
          // Displaying the path can be useful for debugging.
          messenger.showSnackBar(SnackBar(content: Text(image.path)));
        } catch (e) {
          // If an error occurs, display it with a red background.
          messenger.showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
          );
        }
      },
      child: const Icon(Icons.camera),
    );
  }
}
```

You can try to take photos with the app now.
However, you won't be able to view them yet.

## Gallery screen

To view the photos taken by the app, we need another screen.

But first we need to add a package to help os find the path where the app stores
its files.

```sh
flutter pub add path_provider
```

Add the following to `lib/gallery_screen.dart`.

```dart
import 'dart:io';

import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  void _onPhotoTap(BuildContext context, File file) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PhotoScreen(file: file),
    ));
  }

  Future<List<FileSystemEntity>> _listPhotos() async {
    late String imagePath;
    if (Platform.isIOS) {
      final documentsDir = await getApplicationDocumentsDirectory();
      imagePath = [documentsDir.path, 'camera', 'pictures'].join('/');
    } else {
      // Assume Android
      final cacheDir = await getApplicationCacheDirectory();
      imagePath = cacheDir.path;
    }
    return Directory(imagePath).list().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _listPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final files = (snapshot.data ?? []).map((entry) => File(entry.path));
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: [
              for (final file in files)
                GestureDetector(
                  onTap: () => _onPhotoTap(context, file),
                  child: Hero(
                    tag: file.path,
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
```

Let's break it down.

The location where images are stored (by default) depends on the platform.
So here we are setting `imagePath` to the right path.

```dart
String imagePath;
if (Platform.isIOS) {
  final documentsDir = await getApplicationDocumentsDirectory();
  imagePath = [documentsDir.path, 'camera', 'pictures'].join('/');
} else {
  // Assume Android
  final cacheDir = await getApplicationCacheDirectory();
  imagePath = cacheDir.path;
}
```

The functions `getApplicationDocumentsDirectory` and
`getApplicationCacheDirectory` both comes from the
[path_provider](https://pub.dev/packages/path_provider) package.

The pictures taken can be accessed as files from our `imageDir` variable.

```dart
Directory(imageDir).list().toList()
```

It returns a Future that list the filesystem entries in the given directory.

We use a FutureBuilder to automatically update when the future completes.
Inside FutureBuilder, we have:

```dart
if (snapshot.connectionState != ConnectionState.done) {
  return const Center(child: CircularProgressIndicator());
}
```

The state of the Future can be retrieved with `snapshot.connectionState`.
A
[CircularProgressIndicator](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html)
is shown unless the state is done.

```dart
final files = (snapshot.data ?? []).map((entry) => File(entry.path));
```

It maps filesystem entries to File objects.

```dart
GridView.count(
  crossAxisCount: 3,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
  children: [
    for (final file in files)
      GestureDetector(
        onTap: () => _onPhotoTap(context, file),
        child: Hero(
          tag: file.path,
          child: Image.file(file, fit: BoxFit.cover),
        ),
      ),
  ],
)
```

Shows a grid with an image for each file.
When tapping on an image...

```dart
_onPhotoTap(BuildContext context, File file) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => PhotoScreen(file: file),
  ));
}
```

We navigate to a new screen, where the image/photo is shown in a larger size.
The new route is pushed to the navigation stack this time, because it makes
sense that the user can get back after viewing the photo.

## Photo screen

Add `lib/photo_screen.dart` with:

```dart
import 'dart:io';

import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final File file;

  const PhotoScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file.path.split('/').last)),
      body: Hero(tag: file.path, child: Image.file(file)),
    );
  }
}
```

Notice the Hero widget.
It makes an animated transition of its child across widget tree builds.
The `tag` value is used to match the Hero across rebuilds.

Visit the documentation to learn more about [Hero
animations](https://docs.flutter.dev/ui/animations/hero-animations).

That's all 🎊.
You have now coded your own photo app from scratch 📷.

# Challenges

## Spring cleaning

Get rid of those embarrassing photo mistakes, by adding functionality to delete
files.

## iOS-style

Change the application to look-n-feel more like an iOS app.

Replace the material widgets with
[Cupertino (iOS-style) widgets](https://docs.flutter.dev/ui/widgets/cupertino).

Are there alternatives to Drawer that are more iOS-like, for navigation?

## Filters

Add customizable color filters to PhotoScreen using
[ImageFiltered class](https://api.flutter.dev/flutter/widgets/ColorFiltered-class.html).

Throw in some social media, then brag to all your friends and family about
how you created the next Instagram 😉 😉.
