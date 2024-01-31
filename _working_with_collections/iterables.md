---
title: Learning Dart
layout: default
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Iterables

## Introduction

Iterable collections are important building blocks for many applications.
Almost all applications deals with collections of things in some way.
It is therefore a huge payoff in being able to work efficiently with collections.

The [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html) class
(base class for collections) has many convince methods, that once you learn
them, allow you to write code much faster than when using loops.

### Example usage

Run the code an observe the result.
You can play around with it if you want.

```run-dartpad:mode-dart
import "package:collection/collection.dart";

const movies = [
  (title: "Alien", year: 1979),
  (title: "Let the Right One In", year: 2008),
  (title: "Aliens", year: 1986),
  (title: "Jaws", year: 1975),
  (title: "The Silence of the Lambs", year: 1991),
];

void main() {
  print("\n[Newer than 1990]");
  print(movies.where((m) => m.year > 1990));
  
  print("\n[Decades movies where released in]");
  print(movies.map((m) => "${m.year - (m.year % 10)}s"));
  
  print('\n[Group by first letter of title]');
  print(groupBy(movies, (m) => m.title[0]));
}
```

### Language comparison  

These kinds of operations exists in many programming languages, though naming might be different.

| Description | Dart | C# | JavaScript | 
|-|-|-|-|
| Filter (keep) elements that match the predicate | [where](https://api.dart.dev/stable/dart-core/Iterable/where.html) | [Where](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.where) | [filter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter) |
| Map (convert) each element to another type | [map](https://api.dart.dev/stable/dart-core/Iterable/map.html) | [Select](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.select) | [map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) | 
| Flatten nested collections | [expand](https://api.dart.dev/stable/dart-core/Iterable/expand.html) | [SelectMany](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.selectmany) | [flatMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flatMap) | 
| Group elements by a common value | [groupBy](https://pub.dev/documentation/collection/latest/collection/groupBy.html) | [GroupBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupby) | [Object.groupBy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/groupBy) |

## Exercise

Implement each function so that the test pass.

Can you solve them without writing any loops?

Help:
  - [Iterables](https://dart.dev/codelabs/iterables)
  - [Collection library](https://pub.dev/documentation/collection/latest/collection/collection-library.html)

### Data

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

### Age groups

| Age | Category |
|-|-|
| < 18 | adults |
| < 18 | minors |
| < 13 | kids |
| > 13, < 18 | youngsters |

### Code

```run-dartpad:mode-dart
{% include exercise path="codelab/lib/iterables/" %}
```
