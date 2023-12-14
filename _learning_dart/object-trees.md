---
title: Learning Dart
layout: default
---

# Building object trees

Constructing object trees is very important in Flutter (framework).

Dart (language) got a couple of tricks you can use to write constructors for
classes, so that they are both clear and concise.

## Constructors

**Constructor in C#**

This is how you are used to writing constructors in C#.

```csharp
class Task
{
    string name;
    bool done;
    Task(string name, bool done)
    {
        this.name = name;
        this.done = done;
    }
}
```

**Constructor in Dart**

In Dart we need to assign fields/instance-variables a bit different.

```dart
class Task {
  String name;
  bool done;
  Task(String name, bool done):
    this.name = name,
    this.done = done;
}
```

Notice that colon is used followed by a list of assignments.

**Shorthand parameters**

Because assigning parameters to fields/instance-variables is so common, there is
a shorthand for it.

```dart
class Task {
  String name;
  bool done;
  Task(this.name, this.done);
}

Task("Learn Dart", false);
```

**Optional parameters**

We can make a parameter optional wrapping it in `[]` and making the field nullable.

```dart
class Task {
  String name;
  bool? done;
  Task(this.name, [this.done]);
}

Task("Learn Dart"); // `done` is null
Task("Learn Dart", false);
```

**Optional with default value**

Instead of having the field nullable, you could specify a default value.

```dart
class Task {
  String name;
  bool done;
  Task(this.name, [this.done = false]);
}

Task("Learn Dart"); // `done` is true
Task("Learn Dart", true);
```

**Named parameter**

With positional parameters, it is not always obvious from looking at the
invocation what the purpose of the parameter is.

Named parameters can be used to make the purpose of a parameter more explicit.

```dart
class Task {
  String name;
  bool? done;
  Task(this.name, {this.done});
}

Task("Learn Dart", done: true);
```

**Named with default value**


```dart
class Task {
  String name;
  bool? done;
  Task(this.name, {this.done = false});
}

Task("Learn Dart"); // `done` is false
```

**Required named parameter**

It can also be useful to require that a named parameter be specified.

```dart
class Task {
  String name;
  bool done;
  Task(this.name, {required this.done});
}
```

## Challenge

You are building a computer.
Come up with a class hierarchy for assembling computer components.

Such that:
1. you can't make invalid configurations
2. it is easy to understand the configuration.

Here is a crude example with cars:

```dart
class Car {
  String model;
  int wheels;
  int doors;
  Engine engine;
  
  Car(this.model, {required this.doors, this.wheels = 4, required this.engine});
}

class Engine {}
class V6 extends Engine {}
class V8 extends Engine {}

void main() {
  Car("Golf", doors: 4, engine: V6());
}
```

If you haven't build a computer before, then here are some pointers to get you started.

Motherboard is what components are connected to. It got:

- [CPU socket](https://www.tomshardware.com/reviews/cpu-socket-definition,5758.html)
    - CPU
        - Brand (Intel, AMD)
        - Number of cores
        - Model
- [DIMM](https://en.wikipedia.org/wiki/DIMM)
    - Type (DDR3, DDR4, DDR5)
    - Clock frequency
    - Capacity
- [PCI](https://www.tomshardware.com/reviews/pcie-definition,5754.html)
    - Graphics card
        - Brand (Nvidia, AMD)
        - Architecture
        - Memory
        - Cores
- [M.2](https://www.tomshardware.com/reviews/glossary-m2-definition,5887.html)

Write your code on [DartPad](https://dartpad.dev/)