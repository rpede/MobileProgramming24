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

# Unit tests

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