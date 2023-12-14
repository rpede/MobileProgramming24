---
title: Learning Dart
layout: default
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>
<style>iframe {height: 300px;}</style>

# The basics

Dart is in many ways very similar to languages you already know.
Some things are simplified a bit compared to C#.

**Note** click the "Run" button on the code snippets to execute the code.

## Types

Here is a list of the basic type in Dart

- **String**
- **bool**
- **List**
- **Set** like `HashSet` in C#
- **Map** like `Dictionary` in C#
- **int**
- **double**
- **num** can be either `int` or `double`. So it is like `Number` in JavaScript/TypeScript
- **dynamic** which is like `dynamic` in C# or `any` in TypeScript

You can add `?` after a type to make it nullable, similar to TypeScript.
Example `int?`, can be either an `int` or `null`.

## Functions

In Dart you can have functions that are not part of a class, just like TypeScript.

```dart
num add(num a, num b) {
    return a + b;
}
```

The entry point for a program in Dart is a main function.

```run-dartpad:mode-dart
void main() {
    print("This prints");
}

void anotherFunction() {
    print("This doesn't, since it isn't being called");
}
```

You don't need to specify types in Dart.
But the compiler can't type check if you don't specify types.

This will give you an error when you run the code, because you can't divide a
number by a string.

```run-dartpad:mode-dart
divide(a, b) {
    return a / b;
}

main(){
  divide(1, "foobar");
}
```

Here we get a syntax error, which allows us to fix the mistake before it becomes
a bug in our program.

```run-dartpad:mode-dart
num divide(num a, num b) {
    return a / b;
}

void main(){
  divide(1, "foobar");
}
```

## Control flow

### Loops

**for loops** works as you will expect.

```run-dartpad:mode-dart
void main() {
    for (var i = 1; i < 5; i++) {
        print(i);
    }
}
```

The same with **for-each loops**

```run-dartpad:mode-dart
void main() {
    var numbers = [1, 2, 3, 4];
    for (var i in numbers) {
        print(i);
    }
}
```

And **while loops**

```run-dartpad:mode-dart
void main() {
    var counter = 1;
    while(counter < 5) {
        print(counter++);
    }
}
```

### Branching

TODO