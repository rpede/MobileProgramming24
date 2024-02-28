---
title: Testing
layout: default
---

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/oCyXsHC-lQ4?si=IhtJxa2huUzW3yyE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

---

{% include dart_embed %}

# Introduction

> "When a bug is found in your code, it means you have made a mistake. If your
test doesn't find the bug, it means you have made two mistakes."

*- Rasmus*

I presume that you already know the basics of what unit and integration tests
are.
So let's get right into testing in Dart and Flutter.

# Unit testing

## Explanation

We place our unit-tests in `test/` folder.
Each file have a `main` method, in which we write the tests.

To write a test we use the
[test](https://pub.dev/documentation/test/latest/test/test.html) function.
First parameter is a description of the test.
Second parameters is a function that executes the test.

We can groups tests with the [group](https://pub.dev/documentation/test/latest/test/group.html) function.

We can state what we expect the outcome of the test to be using
[expect](https://pub.dev/documentation/matcher/latest/expect/expect.html)
function.
First parameter is the value we want to assert something about.
Second is what we expect the value to match.

*Other languages/frameworks sometimes use the word "assert" (or variantS
*thereof) instead of "expect"*

Read more:

- [An introduction to widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [An introduction to integration testing](https://docs.flutter.dev/cookbook/testing/integration/introduction)

## Example

```run-dartpad:run-false:width-100%:height-800px
import 'package:test/test.dart';

void main() {
  group('PushCommand', () {
    test('Pushes a value to the stack', () {
      final stack = [1, 2];
      PushCommand(3).apply(stack);
      expect(stack, [1, 2, 3]);
    });
  });

  group('AddCommand', () {
    test('Remove the top two numbers and push the result', () {
      final stack = [1, 2];
      AddCommand().apply(stack);
      expect(stack, [3]);
    });

    test('Nothing if there are less than two numbers', () {
      final stack = [1];
      final copy = [...stack];
      AddCommand().apply(stack);
      expect(stack, copy);
    });
  });
}

// Abstract Command class
abstract class Command {
  void apply(List<num> stack);
  void unapply(List<num> stack);
}

class PushCommand implements Command {
  final num value;

  PushCommand(this.value);

  @override
  void apply(List<num> stack) {
    stack.add(value);
  }

  @override
  void unapply(List<num> stack) {
    stack.removeLast();
  }
}

// Avoid duplicating logic for each operation
abstract class OperatorCommand implements Command {
  late num operand1;
  late num operand2;

  num operate(num operand1, num operand2);

  @override
  void apply(List<num> stack) {
    if (stack.length >= 2) {
      operand2 = stack.removeLast();
      operand1 = stack.removeLast();
      stack.add(operate(operand1, operand2));
    }
  }

  @override
  void unapply(List<num> stack) {
    stack.removeLast();
    stack.addAll([operand1, operand2]);
  }
}

class AddCommand extends OperatorCommand {
  @override
  num operate(num operand1, num operand2) => operand1 + operand2;
}
```

*Ignore the warnings.*

# Integration testing

Integrations tests can look very similar to widget tests.
Here is a comparison table to help set them apart.

| Description                           | Widget       | Integration                   |
| ------------------------------------- | ------------ | ----------------------------- |
| What gets tested                      | widget       | the whole app                 |
| Folder with tests                     | test/        | integration_test/             |
| Command to execute                    | flutter test | flutter test integration_test |
| Can you see the UI being rendered?    | no           | yes                           |
| Execution speed                       | fast         | slow                          |

Integration tests should call
`IntegrationTestWidgetsFlutterBinding.ensureInitialized()` before executing any
tests.

Let's look at an example.
First we need an app to test.

```run-dartpad:run-false:mode-flutter:width-100%:height-800px
import 'package:flutter/material.dart';

void main() {
  runApp(MyCalculatorApp());
}

class MyCalculatorApp extends StatefulWidget {
  const MyCalculatorApp({super.key});

  @override
  State<MyCalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<MyCalculatorApp> {
  var value = "";

  _appendDigit(String digit) {
    setState(() {
      value += digit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(key: Key("Display"), value),
            for (final digit in "123".characters)
              OutlinedButton(
                key: Key(digit),
                child: Text(digit),
                onPressed: () => _appendDigit(digit),
              ),
          ],
        ),
      ),
    );
  }
}
```

I can't make it execute integration tests embedded in a web page.
But here is some code to test it.
You can try it in Android Studio.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Enter a number', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyCalculatorApp());

    // Find widget by key and cast to `Text`
    final text =
        find.byKey(const Key("Display")).evaluate().single.widget as Text;
    // `text.data` is the string that is displayed by the text widget
    expect(text.data, equals(''));

    // Convert the number we want to enter to a string.
    // Then loop over the digits.
    for (final digit in '123'.characters) {
      // Find the corresponding button for a digit and tap it.
      await tester.tap(find.byKey(Key(digit)));
      // Trigger update
      await tester.pump();
    }

    // We now expect a widget with the text "123"
    expect(find.text("123"), findsOneWidget);
  });
}
```

Q: Why is a [Key](https://api.flutter.dev/flutter/foundation/Key-class.html)
being used to find widgets?

A: Because after tapping "1" button, there will be two widgets with the text "1".
So we need some other way to find the correct.

**Notice** that Key in test have to match a Key in the app.

## Helpers

The test look above looks a bit complicated.

We can clean up the test code, making it way easier to read, by introducing some
helpers in the form of extension methods.

You can read about how extension methods work
[here](https://dart.dev/language/extension-methods).

The parameter `tester` we have in our `testWidgets` functions are of type
[WidgetTester](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html).
We can add our own test specific convenience methods as extensions to the type.

```dart
extension TesterExtensions on WidgetTester {
  Future<void> enterDigits(String digits) async {
    for (var digit in digits.characters) {
      await tapByKey(Key(digit));
    }
  }

  Future<void> tapByKey(Key key) async {
    await tap(find.byKey(key));
    await pump();
  }
}
```

When we call `find.text("123")` we are invoking `.text()` method on an object of
type
[CommonFinders](https://api.flutter.dev/flutter/flutter_test/CommonFinders-class.html).
We can also add som extensions methods to it:

```dart
extension FinderExtensions on CommonFinders {
  String? displayText() {
    final text = byKey(const Key("Display")).evaluate().single.widget as Text;
    return text.data;
  }
}
```

Now the test can be rewritten as:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Enter a number', (tester) async {
    await tester.pumpWidget(const MyCalculatorApp());

    expect(find.displayText(), equals(''));
    await tester.enterDigits('123');
    expect(find.displayText(), equals('123'));
  });
}
```

Much better!
Don't you think?