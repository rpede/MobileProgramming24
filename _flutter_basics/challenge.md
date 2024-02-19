---
title: Flutter basics challenge
layout: default
---

{% include dart_embed %}

Can you match the screenshot?

![Screenshot](../widget_challenge.png)

```run-dartpad:mode-flutter:run-false:width-100%:height-800px:split-60
{$ begin main.dart $}
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar
        //body: GridView with styled containers in different colors
        //floatingActionButton
        //bottomNavigationBar: Row of IconButton
      ),
    ),
  );
}
{$ end main.dart $}
{$ begin solution.dart $}
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("My Awesome App"), actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ]),
        body: GridView.count(
            padding: const EdgeInsets.all(5),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lime,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.local_library)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
            ],
          ),
        ),
      ),
    ),
  );
}
{$ end solution.dart $}
```

Hint: [list of icons](https://fonts.google.com/icons?selected=Material+Icons&icon.platform=flutter)