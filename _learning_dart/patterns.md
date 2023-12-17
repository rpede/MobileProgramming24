---
title: Learning Dart
layout: default
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>
<style>iframe {height: 800px;}</style>

# Patterns

Many modern object-oriented programming languages (including Dart) are
increasingly adopting features previously mostly associated with functional
programming paradigm.

You likely already know about lambda expressions (aka anonymous functions).
But another concept known as patterns (or pattern matching) is also being
adopted by many traditional OOP languages like
[C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/functional/pattern-matching),
[Java](https://docs.oracle.com/en/java/javase/21/language/pattern-matching.html)
and of course Dart.

To support pattern matching many languages have added support for a type called
record.
Records are immutable, aggregate types.
In layman terms it means that, they can't change and are types that can combine
values of types.

You can read about these concepts work in Dart from the links below.

- [Records](https://dart.dev/language/records)
- [Patterns](https://dart.dev/language/patterns)

## Challenge

Rewrite the algorithm to determine if someone is allowed to buy alcohol, to a
[switch expression](https://dart.dev/language/branches#switch-expressions).

Here are the rules:

- Beverages with 1.2 percent alcohol or more may not be sold to persons under the age of 16
- When selling beverages with 1.2 to 16.5 percent alcohol, the retailer must verify that the customer are 16 years of age
- Beverages with 16.5 percent alcohol or more may not be sold to persons under the age of 18

```run-dartpad:mode-dart
{% include demo path="codelab/lib/patterns/" %}
```
