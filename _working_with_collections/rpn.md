---
title: Reverse Polish notation
layout: default
---

# Calculating with Reverse Polish notation (RPN)

Watch the video for an introduction to the concepts.

[📺 Reverse Polish Notation and The Stack - Computerphile](https://www.youtube.com/watch?v=7ha78yWRDlE)

Reverse polish notation doesn't have anything to do Flutter.
Here we are just using it to practice some writing Dart.

## Description 

Implement a simple calculator based on Reverse Polish Notation (RPN).
RPN is also known as postfix notation.

We are used to what is called infix notation where the operator is between the
operands.

With postfix notation, the operator follows the operands.

RPN has the advantage of not using parentheses.

## Implementation

Values entered are stored in a stack.
Base your stack on the [List class](https://api.dart.dev/stable/2.19.0/dart-core/List-class.html).
The end of the list, should represent the top of the stack.

Stacks support 3 operations.

| Description | Stack operation | List operation |
|-|-|-|
| Retrieve the top-most element | peek | [last](https://api.dart.dev/stable/2.19.0/dart-core/List/last.html) |
| Remove the top-most element | pop | [removeLast](https://api.dart.dev/stable/2.19.0/dart-core/List/removeLast.html) |
| Add a new element to the top | push | [add](https://api.dart.dev/stable/2.19.0/dart-core/List/add.html) |

An operation (+, -, *, / etc) replaces values in the stack with the result.
You can support more operations if you want.

In additional you will need a operation to push a value to the stack.


Operations should implemented using the [Command
pattern](https://www.geeksforgeeks.org/command-pattern/) or variation thereof.

```dart
abstract class Command {
  void apply(List<num> stack);
}
```

You should implement this class in a sub-classes for each operation.

```dart
class AddCommand implements Command {
  @override
  void apply(List<num> stack) {
    // implementation goes here
  }
}
```

### Optional

Implement undo functionality by adding an `undo` method to command class and
keep a stack (command history) of executed commands.

You can capture the state needed to undo in the command object.

Undo will be a separate stack that you push commands to after they have been
executed on stack of values.

Extend the Command class with an unapply method to undo.

```dart
abstract class Command {
  void apply(List<num> stack);
  void unapply(List<num> stack);
}
```

## Solution

Write your solution in [DartPad](https://dartpad.dev/).

**Important** save your work to a file on your computer afterwards.
As it will help you later in the course.
