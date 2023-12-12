---
title: Learning Dart
layout: default
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
{% include exercise path="codelab/lib/acronym/" %}
```
