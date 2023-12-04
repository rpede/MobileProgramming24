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

```run-dartpad:mode-dart:run-true
{$ begin main.dart $}
class Acronym {
  static String abbreviate({required String text}) {
    // TODO your implementation here
  }
}
{$ end main.dart $}
{$ begin solution.dart $}
class Acronym {
  static String abbreviate({required String text}) {
    return toTitleCase(text).replaceAll(RegExp(r"[^A-Z]"), '');
  }

  static String toTitleCase(String text) {
    return text
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .toString();
  }
}
{$ end solution.dart $}
{$ begin test.dart $}
class TestCase {
  String text;
  String abbr;
  String msg;
  TestCase(this.text, {required this.abbr, required this.msg});
}

void main() {
  final testCases = [
    TestCase("Joint Photographic Experts Group",
        abbr: "JPEG", msg: "Abbreviates text with title case"),
    TestCase("Secure by Design",
        abbr: "SBD", msg: "Abbreviates text with lower case"),
    TestCase("HyperText Transfer Protocol Secure",
        abbr: "HTTPS", msg: "Abbreviates text with mixed case"),
    TestCase("Last in. First out", abbr: "LIFO", msg: "Ignores punctuation"),
    TestCase("You only live once 👶💣🪦", abbr: "YOLO", msg: "Ignores emojis")
  ];
  final failures = testCases.where(
      (testCase) => Acronym.abbreviate(text: testCase.text) != testCase.abbr);
  if (failures.isNotEmpty) {
    _result(false, [...failures.map((e) => e.msg)]);
  } else {
    _result(true, ["Hurray, you did it 🥳"]);
  }
}
{$ end test.dart $}
```