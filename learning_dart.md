---
title: Learning Dart
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Iterables

Challenges crafted to help you familiarize yourself with iterables Dart.
Can you solve them without writing any loops?

Hint:
  - [Iterables](https://dart.dev/codelabs/iterables)
  - [Collection library](https://pub.dev/documentation/collection/latest/collection/collection-library.html)

## Age group definition

| Age | Category |
|-|-|
| < 18 | adults |
| < 18 | minors |
| < 13 | kids |
| > 13, < 18 | youngsters |

## Data

```dart
const List<Person> people = [
  (id: 1, name: "Guillaume Strasse", language: "Danish", age: 41),
  (id: 2, name: "Anestassia Echallie", language: "English", age: 47),
  (id: 3, name: "Laura Ringsell", language: "Swedish", age: 14),
  (id: 4, name: "Huey Ragsdall", language: "Latvian", age: 78),
  (id: 5, name: "Winny Pouton", language: "Danish", age: 72),
  (id: 6, name: "Franzen Fahy", language: "Swedish", age: 86),
  (id: 7, name: "Killie Spatoni", language: "English", age: 16),
  (id: 8, name: "Damaris Grebner", language: "Swedish", age: 39),
  (id: 9, name: "Haleigh Rheubottom", language: "Georgian", age: 99),
  (id: 10, name: "Anabel Bariball", language: "English", age: 13),
  (id: 11, name: "Lettie Toon", language: "Danish", age: 55),
  (id: 12, name: "Ginger Alsopp", language: "Danish", age: 75),
  (id: 13, name: "Lee Gazey", language: "English", age: 30),
  (id: 14, name: "Timotheus Gosnall", language: "English", age: 82),
  (id: 15, name: "Elsworth Huntly", language: "Korean", age: 9)
];
```

## Code

```run-dartpad:mode-dart
{% include exercise path="codelabs/learning_dart/lib/iterables/" %}
```

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
