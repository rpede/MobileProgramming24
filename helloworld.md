---
title: "Testing Pages with DartPad"
---

<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

These are not the droids you are using for.

```run-dartpad:mode-dart:run-true
main() => print("Hello, World!");
```

```run-dartpad:mode-flutter:run-true
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Text("Hello World"),
      ),
    );
  }
}
```
