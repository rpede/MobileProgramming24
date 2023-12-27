---
title: Layouts
description: >-
  This is an introduction to layouts in Flutter.
layout: default
---

<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# What are layout widgets

Some widgets in Flutter don't show anything on the screen on their own.
They are there to control the layout of other widgets.

You have seen a couple of these already like `Center` and `Column`.
However there are many more.

Layout widgets can be divided into two categories, those that have just a single
child widget, and those that have multiple.

This exercise will show some of the layout widgets that are most commonly used.
You can find a full list of layout widgets [here](https://docs.flutter.dev/ui/widgets/layout).

## Center

You have already seen the
[Center](https://api.flutter.dev/flutter/widgets/Center-class.html) widget.
It simply puts its child in the center of the available space.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hello World"),
        ),
      ),
    ),
  );
}
```

## Container

The [Container](https://api.flutter.dev/flutter/widgets/Container-class.html)
widget wraps just a single child.
It provides a number of ways to alter the appearance of the child.
Including margin, padding, decoration, color, shape and size.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/c1xLMaTUWCY?si=0Zujj3ITjVgaZJOD"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

Here is an example you can play around with:

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-800px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(10),
          width: 150,
          height: 75,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue,
                Colors.lightGreen,
              ],
              begin: Alignment(0, 0),
              end: Alignment(0.5, 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(5, 5),
              )
            ],
          ),
          child: const Text("Hello World"),
        ),
      ),
    ),
  );
}
```

You can also set the alignment of the child:

```dart
Container(
    alignment: Alignment.bottomCenter,
    child: const Text("Hello World"),
)
```

But then height and width will be ignored.

## SizedBox

Often you need to just be able to set the size of something.
For that a [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html)
is probably a better fit.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/EHPu_DzRfqA?si=w9r24QkuTtLKWlfR"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 75,
          width: double.infinity,
          child: Container(color: Colors.teal),
        ),
      ),
    ),
  );
}
```

## ConstrainedBox

Maybe you want to set a minimum or maximum size instead.
For that there is [ConstrainedBox](https://api.flutter.dev/flutter/widgets/ConstrainedBox-class.html).

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/o2KveVr7adg?si=SOcvP5TSNke_K8a8"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.amber, Colors.pink])),
          ),
        ),
      ),
    ),
  );
}
```

Note: Drag the border between code and rendered app to change its size.

## Rows and columns
