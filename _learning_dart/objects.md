---
title: Learning Dart
layout: default
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Objects in Dart

This tutorial is aimed at teaching you the basics of OOP in Dart.

We will look at how to specify constructors, methods and inheritance.
You will also learn a bit about how Dart deals with nullability.

Let's jump right into it.

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

Notice the question mark after num?
It means the field is nullable.

If we remove the assignment `this.x = x` then after the class has been
instantiated, the value of `x` would be null.

Dart forces us to check for null each time we try to do something with the value
of a nullable variable.
This is called [sound null safety](https://dart.dev/null-safety), and it's there
to protect us from null reference exceptions.

The Point class doesn't accurately represent a point, unless it has a value for
both a *x* and *y*.

Let's fix it by rewriting the class, such that the instance fields are no longer
nullable.

```dart
class Point {
  num x;
  num y;

  Point(num x, num y)
      : this.x = x,
        this.y = y;
}
```

Notice the curly brackets are gone. Instead, we have a comma separated list of
assignments.
This is called an [initializer list](https://dart.dev/language/constructors#initializer-list).

If we want the variables to be non-nullable, then we can no longer make the
assignments in a code block (within curly brackets).
That is because within a block you have the ability to make conditional
assignments.

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

With an initializer list, you are always going to assign a value.
Therefore, in order to make the instance-variables non-nullable, we have to use
an initializer list for the assignments.

## Immutability

If we don't want the values of *x* and *y* to change, then we can declare them
as final.

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
Luckily the Dart designers made a nice shorthand for us.

```dart
class Point {
  final num x;
  final num y;

  const Point(this.x, this.y);
}
```

Notice I've also added the `const` keyword in-front of the constructor.
I'm allowed to do that because all of the instance variables are `final`.
An object that can't change is said to be immutable.
So `const` before constructor tells the compiler that the object will be immutable.
Which allows the compiler to do some optimizations.

An immutable class can be instantiated as a compile-time constant.
Thereby saving some CPU cycles at runtime.

```dart
const Point origin = Point(0, 0);
```

Here, `origin` is created when the code compiles, not when the application runs.
It simplifies how *x* and *y* are accessed, thereby making it more efficient.

## Named parameters

Previously we used positional parameters.
It means that we have to pass values for parameters in the same order as they
are defined in the method signature.

Named parameters can be specified in any order.
They also make the meaning of the parameter more explicit.
This style is preferred when there is no logical order for the parameters.

Named parameters are wrapped in curly brackets.

```dart
class Line {
  Point? a;
  Point? b;
  Line({this.a, this.b});
}
```

In this example, we have a line from point *a* to point *b*.
We use named parameters to imply that direction matters for the line.
Notice that the instance variables are nullable again.
That is because named parameters are optional by default.
We can make them required with the `required` keyword.

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

# Modifiers

Maybe you have noticed that there are no public or private keywords anywhere.
That is because everything in Dart is public by default.
To make something private you just prefix it with a `_` underscore.

```dart
class Nonsense {
    String _foo = "bar";
}
```

It is a common convention in other languages (like C# and TypeScript) to prefix
private instance-variables with an underscore.
In Dart this convention is enforced by the compiler, so there is no need for a
private keyword.

The same is true for methods.

```dart
class Nonsense {
  String _secretGreeting(String name) => "Pssst, hello " + name;
}
```

Putting the keyword `static` in front of method behaves just as you would
expect.

```dart
class Greeter {
  static String greeting(String name) => "Hello " + name;
}

Greeter.greeting("bob");
```

You could also written:

```dart
class Greeter {
  static String greeting(String name) => "Hello $name!";
}
```

Here `$name` is substituted with the value of the variable `name`.
This is called string interpolation.

For comparison, this is what it looks like in:

**C#**

```csharp
$"Hello {name}!"
```

**JavaScript/TypeScript**

```typescript
`Hello ${name}!`
```

# Extension methods

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
However, they are super useful for people writing libraries, as it allows them to
extend existing types.
You will be calling extension methods a lot.

# Inheritance

Like other object-oriented programming languages, Dart (of course) supports
inheritance. 
You can declare a class that extends another.

```dart
class Shape {}

class Circle extends Shape {}
```

We can make it abstract by using the `abstract` modifier.

```dart
import 'dart:math' as math;

abstract class Shape {
  double area();
}

class Circle extends Shape {
  num radius;
  Circle(this.radius);

  @override
  area() {
    return math.pow(radius, 2) * math.pi;
  }
}
```

The subclass needs to implement the abstract method `area`, unless we make the
subclass abstract as well.

Notice that we don't need to specify a return type for `area` in the subclass.
That is because the compile can tell from base class.

The `@override` isn't strictly required.
It is just an indicator to whoever reads the code that the methods override a
method in a base class.

It is also possible to have a class only implement the interface of another,
but none of the functionality.

```run-dartpad:run-true
class Greeter {
  void greet(String name) {
    print("Hello $name");
  }
}

class PoliteGreeter implements Greeter {
  @override
  void greet(String name) {
    print("Good day to you, dear $name");
  }
}

void main() {
  Greeter greeter = Greeter();
  greeter.greet("Bob");

  greeter = PoliteGreeter();
  greeter.greet("Bob");
}
```

Here `PoliteGreeter` implements `Greeter`, meaning it will need to implement all
of its methods and fields.

**In Dart, a class can be used as an interface!**

Why is that you might be wondering.
Let's see how it can be useful.

In C# you might have something like:

```csharp
public interface IUserService {
  // Imagine a lot of stuff here
}

public class UserService : IUserService {
  // You need to keep the implementation in sync with the interface
}

public class MockUserService : IUserService {}
```

You need the interface, just in case you want to make an alternative
implementation of UserService.
Like a mock for testing.

However, in Dart you could just do:

```dart
class UserService {}

class MockUserService implements UserService {}
```

## Combined

Here is an example of using it all together.

```run-dartpad:mode-dart
{% include demo path="codelab/lib/objects/" %}
```