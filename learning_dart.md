---
title: Learning Dart
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Acronym generator

Write an acronym generator.
You give it some text and it will abbreviate it to an acronym.

## Examples

| Text | Abbreviation |
|-|-|
| Joint Photographic Experts Group | JPEG |
| Secure by Design | SBD | Abbreviates text with lower case |
| HyperText Transfer Protocol Secure | HTTPS | Abbreviates text with mixed case |
| Last in. First out | LIFO | Ignores punctuation |
| You only live once 👶💣🪦 | YOLO | Ignores emojis |

## Code

```run-dartpad:mode-dart
{% include exercise path="codelabs/learning_dart/lib/acronym/" %}
```

# FizzBuzz

> Fizz buzz is a group word game for children to teach them about division.
Players take turns to count incrementally, replacing any number divisible by
three with the word "Fizz", and any number divisible by five with the word
"Buzz", and any number divisible by both 3 and 5 with the word "Fizz Buzz".

- [Wikipedia](https://en.wikipedia.org/wiki/Fizz_buzz)

## Example

`1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, Fizz Buzz, 16, 17, Fizz, 19, Buzz, Fizz, 22, 23, Fizz, Buzz, 26, Fizz, 28, 29, Fizz Buzz`

# Code

Implement a fizzbuzz generator using
[streams](https://dart.dev/articles/libraries/creating-streams).

```run-dartpad:mode-dart
{% include exercise path="codelabs/learning_dart/lib/fizzbuzz/" %}
```

# Iterables

Challenges crafted to help you familiarize yourself with iterables Dart.
Can you solve them without writing any loops?

## Age definition

| Age | Category |
|-|-|
| < 18 | adults |
| < 18 | minors |
| < 13 | kids |
| > 13, < 18 | youngsters |

Hint:
  - [Iterables](https://dart.dev/codelabs/iterables)
  - [Collection library](https://pub.dev/documentation/collection/latest/collection/collection-library.html)

You can declare a record type for a person by adding following line to
/lib/people.dart:

```dart
typedef Person = ({int id, String name, String language, int age});
```

## Code

```run-dartpad:mode-dart
{% include exercise path="codelabs/learning_dart/lib/iterables/" %}
```
