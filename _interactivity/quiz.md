---
title: Quiz
description: >-
    Quiz app with some simple state management.
layout: default
---

# Shortcut

You will be able to write code so much faster, if you learn a couple of
shortcuts.
Practice the following.

**Reformat code**

- Windows: <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>
- Linux: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>
- macOS: <kbd>Option</kbd> + <kbd>Command</kbd> + <kbd>L</kbd>

# Project setup

Lets try to create a project from CLI this time.
Open a terminal in the folder with your Flutter projects.
Create a new project with:

```sh
flutter create quiz --platforms=android
cd quiz
```

*Note: you can adjust the platforms as you please.*

Valid platforms:

- android
- ios
- web
- macos
- windows
- linux

You can later add new platforms by recreating the project.
From within the project folder, run:

```sh
flutter create . --platforms=android,web
```

# Data

## Class for data

Before we get started writing widgets, let's add some data.

First we need to define some types.
Create the file `lib/quiz_model.dart` and add:

```dart
/// Data class for a question.
class Question {
  /// The question text.
  /// 
  /// Example: What is Dart?
  final String text;
  /// Options that can be chosen from to answer the question.
  /// 
  /// Example: ["Programming language", "Airborne ranged weapon"]
  final List<String> options;
  /// Which of the options is the correct answer.
  final String correct;
  /// Which of the options the user picked as their answer.
  String? answered;

  Question(this.text,
      {required this.options, required this.correct, this.answered});
}

/// A quiz is just a list of questions.
/// 
/// The `typedef` keyword means that `Quiz` becomes an alias for
/// `List<Question>`.
typedef Quiz = List<Question>;
```

Hopefully you are able to tell what the purpose of everything is from the
comments.

*Note: The triple slash `///` means that the comment will be used as
documentation.
You can see it in action if you hover over the name/symbol underneath the
comment.*

## Add some data

For simplicity we are just going to hardcode the quiz.
Working with data from an REST-API will be shown in a future tutorial.

Create a file `lib/quiz_data.dart` and add:

```dart
import 'quiz_model.dart';

final Quiz quiz = [
  Question("What is Flutter?",
    options: [ "Cloud computing platform", "Insect", "UI framework", "Programming language" ],
    correct: "UI framework",),
  Question("What platforms are supported by Flutter?",
    options: [ "Desktop, web and mobile", "Mobile (iOS & Android)", "Only Android", "Web and mobile" ],
    correct: "Desktop, web and mobile"),
  Question("Does Flutter render its UI in a WebView?",
    options: [ "Yes", "No" ],
    correct: 'No',),
  Question(
    "What programming language are Flutter apps primarily written in?",
    options: ["Swift", "Dart", "Java", "TypeScript",],
    correct: 'Dart',),
  Question(
    'What is the widget tree in Flutter?',
    options: ["The hierarchy of UI elements in a Flutter app", "A visual representation of app screens", "A structure used for database storage",],
    correct: 'The hierarchy of UI elements in a Flutter app',),
  Question(
    "What is the purpose of the setState method in Flutter?",
    options: ["To set the state of the entire app", "To update the UI based on changes in the app's state", "To define the initial state of a Flutter widget",],
    correct: "To update the UI based on changes in the app's state",),
  Question(
    "What is the BuildContext used for?",
    options: ["Nothing","Used to define color scheme of the app","Data storage class for managing app state","Provides information about the widget hierarchy",],
    correct: "Provides information about the widget hierarchy",),
];
```

*Note: it will look a lot nicer if you format the file.*

# Basic layout

## Main

Replace your `lib/main.dart` with the following:

```dart
import 'package:flutter/material.dart';

import 'quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

const themeColor = Colors.lightGreen;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: themeColor,
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: themeColor)),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: themeColor, brightness: Brightness.dark)),
      home: QuizScreen(),
    );
  }
}
```

*Note: you can change the colors by changing `themeColor`.*

## Quiz screen

Add file `lib/quiz_screen.dart` with:

```dart
import 'package:flutter/material.dart';

import 'quiz_model.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text("What is Dart?",
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          Expanded(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text("Ranged weapon"),
                ),
                FilledButton(
                  onPressed: () {},
                  child: Text("Programming language"),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
```

Go ahead and run the application to see how it looks.
You can change the color if you like.

# Refactor

The QuizScreen widget is going to grow as you progress through the tutorial.
So let's refactor it a bit.

## Questions

1. Place your cursor on Text widget inside Padding and right click.
2. Then "Refactor->Extract Method..."
3. In "Method name" type "_buildQuestion"

## Options

Place the text cursor on the beginning of the list for the buttons (on the `[`
character).
Extract method.
Name it "_buildOptions".

It might be a good idea to reformat the file.

## StatefulWidget

1. Place the cursor on QuizScreen in the line
`class QuizScreen extends StatelessWidget`
2. <kbd>Ctrl</kbd> + <kbd>.</kbd>, or click 💡
3. Then "Convert to StatefulWidget"

Notice that you now have two classes.

Widgets shouldn't be able to mutate.
Their constructor should be const.
But a StatefulWidget creates a state object that are allowed to mutate.

With "mutate", you should understand "have changing state", or "have non-final
fields".

# Theory

Flutter aims at providing fast rendering (60 fps).
In our apps we tell Flutter how to draw the screen by providing widget trees.
However it wouldn't be efficient to redraw the entire screen from scratch each
frame, just because some small part of the screen is animated (like when you tap
a button).

Flutter got some clever wizardry to solve the problem.
There aren't just one tree of object representing the screen.
There are 3 😯 !.

{% include_relative trees.drawio.svg %}

In short. For each piece of UI, there are 3 trees of objects.

- **Widget** are what we use to tell the framework that we want on the screen.
- **RenderObject** takes care of the painting.
- **Element** sits between and is responsible for updating the RenderObject to a
new configuration.

Recreating all render-objects each frame would be expensive.
The framework therefore makes attempts to reuse them.
If it determines that a render-object should be reused, it update the existing
render-object to match the new widget configuration.
The element is responsible managing this.

You can view [How Flutter renders
Widgets](https://www.youtube.com/watch?v=996ZgFRENMs) to learn more.

But what about the State object?
Well, it can tell the element to update its render-object and provide it new
widget tree to use as configuration.

`setState(() {...})` takes a function as parameter.
After executing the function, it will mark the element as needing to be rebuild.

You are supposed to wrap your state changes in a call to `setState()`.
Example:

```dart
setState(() {
  _counter = _counter + 1; // or `_counter++`
});
```