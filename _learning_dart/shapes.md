---
title: Learning Dart
layout: default
---

# Shapes

This tutorial is aimed at teaching you the basics of OOP in Dart.

We will look at different variations on how to specify parameters in constructor, methods and inheritance.
You will also learn a bit about how dart deals with nullability.

## Nullability

We can declare a class with positional parameters like this:

```dart
class Point {
  num? x;
  num? y;

  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
```

Notice the the questionary after num?
It means the fields are is nullable.

If we remove the assignment `this.x = x` then after the class has been
instantiated the value of `x` would be null.

Dart forces us to check for null each time we try to do something with the value
a nullable variable.
This is called [sound null safety](https://dart.dev/null-safety) and it is there
to protects us from null reference exceptions.

However a point is not really a point unless it has both a *x* and *y* coordinate.

Lets fix it by rewriting the class such that the instance fields are no longer nullable.

```dart
class Point {
  num x;
  num y;

  Point(num x, num y)
      : this.x = x,
        this.y = y;
}
```

What happened? The constructor looks all weird now!

Notice the curly brackets are gone. Instead we have a comma separated list of assignments.
This is called a [initializer list](https://dart.dev/language/constructors#initializer-list).

If we want the variables to be non-nullable then we can no longer make the assignments in a code block (within curly brackets).
That is because within a block you have the ability to make conditional assignments.

Here is a silly example of conditional assignment.

```dart
class Point {
  num? x;
  num? y;

  Point(num x, num y) {
    if (x > y) {
        this.x = x;
        this.y = y;
    }
  }
}
```

With an initializer list you are always going to assign a value.
Therefore in order to make the instance-variables non-nullable we have to use an initialization list for the assignments.

## Immutability

If we don't want the values of *x* and *y* to change then we can declare them as final.

```dart
class Point {
  final num x;
  final num y;

  Point(num x, num y)
      : this.x = x,
        this.y = y;
}
```

Assigning parameters directly to instance fields is very common.
So they made a nice shorthand for us.

```dart
class Point {
  final num x;
  final num y;

  const Point(num this.x, num this.y);
}
```

Notice I've also added the `const` keyword in-front of the constructor.
I'm allowed to do that because all of the instance variables are `final`.
A object that can't change is said to be immutable.

An immutable class allows us to instantiate it as a compile-time constant.

```dart
const Point origin = Point(0, 0);
```

Here, `origin` is created when the code compiles, not when the application runs.
It simplifies how *x* and *y* are accessed, thereby making it more efficient.

## Named parameters

Previously we have used positional parameters.
That means we have to pass values for parameters in the same order they are defined.

Named parameters makes the meaning of the parameter more explicit.
This style is preferred when there is no logical order for the parameters.

Named parameters are wrapped in curly brackets.

```dart
class Line {
  Point? a;
  Point? b;
  Line({this.a, this.b});
}
```

In example with a line from point *a* to point *b*, named parameters to imply that direction matters for the line.

Notice that the instance variables are nullable again.
That is because named parameters are optional by default.
We can make them required by using the `required` keyword.

```dart
class Line {
  Point a;
  Point b;
  Line({required this.a, required this.b});
}
```

## Methods

Defining methods are pretty straight forward.

```dart
class Line {
  Point a;
  Point b;
  Line({required this.a, required this.b});

  double calculateLength() {
    return math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));
  }
}
```

Arrow syntax can be used for one-liners, which saves us from typing `return`.

```dart
class Line {
  Point a;
  Point b;
  Line({required this.a, required this.b});

  double calculateLength() => math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));
}
```

You might have noticed that there is no public or private keyword anywhere.
That is because everything in Dart is public by default.
To make something private you just prefix it with a `_` underscore.

```dart
class Nonsense {
    String _foo = "bar";
}
```

It is a common convention in other languages (like C# and TypeScript) to prefix private instance-variables with an underscore.
In Dart this convention is enforced by the compiler, so there is no need for a private keyword.

The same is true for methods.

```dart
class Nonsense {
  String _secretGreeting(String name) {
    return "Pssst, hello " + name;
  }
}
```

Putting the keyword `static` in front of method behaves as expected.

```dart
class Greeter {
  static String greeting(String name) {
    return "Hello " + name;
  }
}

Greeter.greeting("bob");
```

Maybe you have heard of extension methods?
They can be used to extend an existing class from somewhere else.

```dart
extension PointExtensions on Point {
  Line to(Point other) {
    return Line(a: this, b: other);
  }
}

final Point origin = Point(0, 0);
final Line normal = origin.to(Point(0, 1));
```

You likely won't be writing that many extension methods yourself.
However they are super useful people writing libraries, so they can extend
existing types.