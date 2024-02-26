---
title: Assignment 1 - RPN Calculator
---

# Introduction

![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/HP-35_Red_Dot.jpg/220px-HP-35_Red_Dot.jpg)

*HP-35, the first pocket calculator from 1972*

[Demo](https://www.hpmuseum.org/simulate/hp35sim/hp35sim.htm)

[📺 How to use a Reverse Polish Notation Calculator](https://www.youtube.com/watch?v=bytfIdoUhD8)

# Part 1 - Logic

## Description 

Implement a simple calculator based on Reverse Polish Notation (RPN).
RPN is also known as postfix notation.

You are likely used to what is called infix notation, where the operator is
between the operands.
With postfix notation the operator follows the operands.
It has the advantage of not requiring parentheses.

**Examples**

- `2 2 + = 4`
    - 2 and 2 are added resulting in 4.
    - infix notation: `2 + 2 = 4`
- `3 4 − 5 + = 4`
    - 4 is subtracted from 3 resulting in -1
    - then 5 is added resulting 4
    - infix notation: `3 - 4 + 5 = 4`
- `3 4 × 5 6 × + = 42`
    - 3 and 4 is multiplied resulting in 12
    - then 5 and 6 is multiplied resulting in 30
    - then 12 and 30 is added resulting in 42
    - infix notation: ` (3 × 4) + (5 × 6) = 42`

## Implementation

Values entered are stored in a stack.

Picture a stack of cards.

- You put a card in the stack by placing it on top of other cards.
- You can remove a card by taking the topmost card.
- You can also peek at the card in the top of the stack.

Base your stack on the [List class](https://api.dart.dev/stable/2.19.0/dart-core/List-class.html).
Where the end of the list represents the top of the stack.

An operation (+, -, *, / etc) replaces the two topmost values in the stack with
the result.
You can support more operations if you want.

In addition you will need an operation to push a value to the stack.
Meaning placing it on the top.

Operations can be implemented using the [Command
pattern](https://www.geeksforgeeks.org/command-pattern/) or variation thereof.

Remember: We use an abstract class in Dart instead of interface as you are used
to from other programming languages.

## Optional

Implement undo functionality by adding an `undo` method to command class and
keep a stack (command history) of executed commands.

# Part 2 - GUI

## Description

Make a GUI for the RPN calculator.

You can use the above image as inspiration if you want to make it retro.
Or base the layout of the existing calculator app on your phone.

Unlike your phone there should be a **enter** button instead of an **equal** button.
You should also have a button to **clear** the entire stack.

Consider placement of button for easy reach.

In the display section of your calculator, you should make two rows.

To ease with debugging, you might want to print the stack each time it changes,
or display it in the GUI.

## Implementation

Flutter+material comes with a couple of different [button widgets](https://docs.flutter.dev/development/ui/widgets/material#Buttons).

- ElevatedButton
- OutlinedButton
- FilledButton
- TextButton
- IconButton

Pick the type of button you like.
They all have a `onPressed` callback that you can use to execute a command.

All state should be held in a `StatefulWidget`.
You can extract parts of the build tree as methods or widgets if you like.
You can pass functions around as parameters that do the operation needed for
`onPressed` on a button.

Remember to call `setState` after updating the stack, or the value in the display.
Otherwise, the widgets won't be rebuilt, and it will look like nothing has changed.

# Part 3

You need to write tests for you calculator.
Unit-tests for the logic in part 1 and integration tests for the UI in part 2.

Tests must be executed from a GitHub Actions pipeline.
The pipeline should also build for web and deploy to GitHub Pages.

[See instructions](https://github.com/rpede/flutter_web_test_deploy/blob/main/README.md)

# Hand-in

Submit a link to the GitHub repository with your solution.
Repository needs to be public!

The assignment can be done in groups.
For groups, each members need to make a submission and the names of all members
must be clearly stated.