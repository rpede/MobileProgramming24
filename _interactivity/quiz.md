---
title: Quiz
description: >-
    Quiz app with some simple state management.
layout: default
---

![Screenshot](../quiz_app_screenshot.png)

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

For simplicity, we are just going to hard-code the quiz.
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

[Check your progress](../quiz_screen0.dart)

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
instance variables".

[Check your progress](../quiz_screen1.dart)

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
After executing the function, it will mark the element as needing to be rebuilt.

You are supposed to wrap your state changes in a call to `setState()`.
Example:

```dart
setState(() {
  _counter = _counter + 1; // or `_counter++`
});
```

# Showing data

## Injecting the quiz

The QuizScreen needs access to the quiz data.
So change the constructor to:

```dart
final Quiz quiz;
const QuizScreen({required this.quiz, super.key});
```

You will see an error in main.dart.
Fix it by importing the data and passing it as parameter to QuizScreen.

At the top:

```dart
import 'quiz_data.dart';
```

Change change:

```dart
home: QuizScreen(quiz: quiz),
```

## Showing current question

At the top of _QuizScreenState add:

```dart
int index = 0;
Quiz get questions => widget.quiz;
```

The `Quiz get questions => ...` is how you can make getters in Dart.

State object can access the widget through the `widget` variable.
This is how it is able to access the quiz on the widget.

Now at the top of the `build()` method, right before `return Scaffold`.
Add:

```dart
final currentQuestion = questions[index];
```

Add another parameter to `_buildQuestion()` method, so it can access the current
question.
Also change, so it displays the text from the parameter.

```dart
Text _buildQuestion(BuildContext context, Question question) {
    return Text(question.text,
        style: Theme.of(context).textTheme.headlineLarge);
}
```

The `_buildOptions()` method also needs to change.
Each question can have a different number of options.
So we need to loop over the options.

```dart
List<Widget> _buildOptions(Question question) {
  return [
    for (final option in question.options)
      if (question.answered != option)
        OutlinedButton(
            onPressed: () => _onOptionPressed(option), child: Text(option))
      else
        FilledButton(
            onPressed: () => _onOptionPressed(option), child: Text(option))
  ];
}
```

Notice, in Dart we can have for-loop and if/else withing the declaration of
a list `[]`.
Pretty cool 😎, right?

Then add a new method to handle the `onPressed` event.

```dart
_onOptionPressed(String answer) {
  setState(() {
    questions[index].answered = answer;
  });
}
```

Now within the `build()` method, pass `currentQuestion` as parameter to
`_buildOptions` and `_buildQuestion`.

```dart
child: _buildQuestion(context, currentQuestion),
//...
children: _buildOptions(currentQuestion)
```

*I think it makes it slightly easier to follow the application flow if you use
parameters in such cases, instead of accessing the properties directly.*

Run the application an click the buttons.

We now have changing UI 🥳.

The call to `setState` results in the UI being rebuilt.
The method is only available within the State object of a StatefulWidget.

[Check your progress](../quiz_screen2.dart)

# Next question

Now we need a button to progress through the questions.
Add:

```dart
Widget? _buildActionButton(Question currentQuestion) {
  if (currentQuestion.answered == null) return null;
  return TextButton(onPressed: _onNextPressed, child: const Text("Next"));
}
```

When the current question has been answered it will return a button allowing the
user to progress.

We also need a method to handle the event:

```dart
_onNextPressed() {
  if (index < questions.length - 1) {
    setState(() {
      index++;
    });
  }
}
```

When the button is pressed, the index gets increased.
It is done within a `setState` so the UI rebuilds.
The first line in `build()` method retrieves the current question from the
index.

Increasing the index beyond the last question will make the app crash.
We therefore wrap it in an if-statement.

Before the button shows up in the UI, it needs to be added to the Scaffold.
Withing `Scaffold` in the `build()` method:

```dart
floatingActionButton: _buildActionButton(currentQuestion)
```

Run the app again!

[Check your progress](../quiz_screen3.dart)

# Show progress

It would be nice if the user could follow their progress.
Add a methods to build progress indicator widgets.

```dart
List<Widget> _buildProgress(int number, int total) {
  return [
    LinearProgressIndicator(value: number / total),
    const SizedBox(height: 8),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [const Text('Question:'), Text('$number of $total')],
      ),
    ),
    const Divider(),
  ];
}
```

It takes a *number* and a *total* as parameters.
Add declaration to the top of `build()`.

```dart
final number = index + 1;
final total = questions.length;
```

Then invoke new method before the other children at the outermost column.

```dart
..._buildProgress(number, total),
```

Your entire `build()` method should look like this:

```dart
Widget build(BuildContext context) {
  final currentQuestion = questions[index];
  final number = index + 1;
  final total = questions.length;
  return Scaffold(
    appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
    body: Column(
      children: [
        ..._buildProgress(number, total),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: _buildQuestion(context, currentQuestion),
        ),
        Expanded(
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildOptions(currentQuestion)),
          ),
        )
      ],
    ),
    floatingActionButton: _buildActionButton(currentQuestion),
  );
}
```

Run the app again to how far you have come 😉.

[Check your progress](../quiz_screen4.dart)

# When done

Nothing really happens when user taps next at the last question.
It would be nice if they could tell whether they got the answers correct.

Change the `_buildActionButton()` to:

```dart
Widget? _buildActionButton(Question currentQuestion) {
  if (done || currentQuestion.answered == null) return null;
  if (index < questions.length - 1) {
    return TextButton(onPressed: _onNextPressed, child: const Text("Next"));
  } else {
    return Builder(
      builder: (context) => TextButton(
          onPressed: () => _onDonePressed(context),
          child: const Text("Done")),
    );
  }
}
```

When user is at the last question, we show a "Done" button instead of "Next".

To keep track we need another property.
So at the very top of `_QuizScreenState`, add:

```dart
bool done = false;
```

Add an event handler for when the "Done" button is pressed.

```dart
_onDonePressed(BuildContext context) {
  setState(() {
    done = true;
  });
  final allCorrect =
      questions.every((element) => element.answered == element.correct);

  showModalBottomSheet(
      context: context,
      builder: (context) => _buildBottomSheet(context, allCorrect));
}
```

It sets a new state for `done`, making the button disappear (see
`_buildActionButton`).
Then it finds out if all questions have been answered correctly.
Passing the information to a method (yet to be defined) for building a bottom
sheet.

[Documentation for showModalBottomSheet
](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)

Also, add a method to build widgets for the bottom sheet.

```dart
Widget _buildBottomSheet(BuildContext context, bool allCorrect) {
  final textTheme = Theme.of(context).textTheme;
  return Container(
    color: allCorrect ? Colors.green : Colors.red,
    width: double.infinity,
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
              allCorrect
                  ? "Hurray 🥳, you are a true expert!"
                  : "😥 you can do better!",
              style: textTheme.headlineSmall),
        ])),
  );
}
```

The container will show a different text and background color depending on if
all answers are correct.

Let's go back to the first question when the bottom sheet is closed.
Change the last half of `_onDonePressed` to:

```dart
final controller = showModalBottomSheet(
    context: context,
    builder: (context) => _buildBottomSheet(context, allCorrect));

controller.whenComplete(() {
  setState(() {
    index = 0;
    done = false;
  });
});
```

Try the app again.

[Check your progress](../quiz_screen.dart)

# Full source

[View on GitHub](https://github.com/rpede/MobileProgramming24/tree/main/_interactivity/quiz)

# Challenge

Upgrade the app to support multiple quizzes.
You probably need a different widget to allow the user to select a quiz.

If you lack creativity to come up with additional quizzes then you can always
ask ChatGTP.