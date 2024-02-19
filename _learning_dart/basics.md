---
title: Learning Dart
layout: default
---

{% include dart_embed %}

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

```run-dartpad:mode-dart:height-200px
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

```run-dartpad:mode-dart:height-200px
divide(a, b) {
    return a / b;
}

main(){
  divide(1, "foobar");
}
```

Here we get a syntax error, which allows us to fix the mistake before it becomes
a bug in our program.

```run-dartpad:mode-dart:height-200px
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

```run-dartpad:mode-dart:height-200px
void main() {
    for (var i = 1; i < 5; i++) {
        print(i);
    }
}
```

The same with **for-each loops**

```run-dartpad:mode-dart:height-200px
void main() {
    var numbers = [1, 2, 3, 4];
    for (var i in numbers) {
        print(i);
    }
}
```

And **while loops**

```run-dartpad:mode-dart:height-200px
void main() {
    var counter = 1;
    while(counter < 5) {
        print(counter++);
    }
}
```

### Branching

#### if

**if** statements are also works as you might expect.

Can you write an algorithm to determine when someone is allowed to by alcohol in Denmark.

Current rules are:

- Beverages with 1.2 percent alcohol or more may not be sold to persons under the age of 16
- When selling beverages with 1.2 to 16.5 percent alcohol, the retailer must verify that the customer are 16 years of age
- Beverages with 16.5 percent alcohol or more may not be sold to persons under the age of 18

```run-dartpad:mode-dart
{% include exercise path="codelab/lib/if_statement/" %}
```

#### switch

**switch-statement** can be used in similar ways as in C# or TypeScript.
But with the exception that each-empty `case` clause jumps to the end of the
`switch` statement.
Meaning there is no need for `break` statement in `case`-clauses.
You could say that it auto-breaks.

```dart
switch (answer) {
    case true:
        print("Correct");
    case false:
        print("Wrong");
    default:
        print("No valid answer was given");
}
```

Dart also supports **switch expressions**.

```dart
String message = switch (answer) {
  true => "Correct",
  false => "Wrong",
  _ => "No valid answer was given",
};
print(message)
```

Note that `_` functions as a default.

> Expressions evaluate to a value that can either be assigned to a value or returned.
> Statements do not evaluate to a value.

Solve the following exercises with either a switch-statement.

Imagine you have an API that returns day of week as an `int`.
The numeric values follows
[DayOfWeek](https://docs.oracle.com/javase/8/docs/api/java/time/DayOfWeek.html)
definition in Java.
Write a simple function that takes a day of the week as input and returns
whether it's a weekday or a weekend.
On invalid input it should `throw ArgumentError('Invalid day')`.

```run-dartpad:mode-dart
{% include exercise path="codelab/lib/switch_statement/" %}
```

Solve this one with a switch-expression.

Write a simple function that converts Denmark's 7-step-scale to ECTS grading scale.
See [Academic grading in Denmark](https://en.wikipedia.org/wiki/Academic_grading_in_Denmark).

```run-dartpad:mode-dart
{% include exercise path="codelab/lib/switch_expression/" %}
```

## Variables

The official documentation explains it better than I can.

**[Dart - Variables](https://dart.dev/language/variables)**

**Note** `const` in TypeScript are the same as `final` in Dart.
In Dart you can only declare a variable as `const` when the value can be
determined during compilation and will never change at runtime.

## Error handling

In Dart you can throw any arbitrary object (just like TypeScript).

```dart
throw "Party!!!";
```

However you pretty much always want to throw types that implement
[Error](https://api.dart.dev/stable/3.2.6/dart-core/Error-class.html) or
[Exception](https://api.dart.dev/stable/3.2.6/dart-core/Exception-class.html).

Try-catch can look very similar to TypeScript:

```run-dartpad:mode-dart:height-300px
void coolFunction() => throw new UnimplementedError();

void main() {
  try {
      coolFunction();
  } catch (error) {
      print("Oh no, oh no, oh no no no");
  }
}
```

As indicated, having `new` before invoking a constructor is not necessary.

```dart
void coolFunction() => throw UnimplementedError();
```

If you want to catch some specific type, you can do:

```run-dartpad:mode-dart:height-250px
void coolFunction() => throw UnimplementedError();

void main() {
    try {
        coolFunction();
    } on UnimplementedError {
        print("Bro need to implement that function!");
    }
}
```

In case you want to do something with the catch object.


```run-dartpad:mode-dart:height-400px
class ValidationError extends ArgumentError {
    ValidationError(super.message);
}

void validateAge(int age) {
    if (age < 0) {
        throw ValidationError("Age can be less than 0");
    }
}

void main() {
    try {
        validateAge(-1);
    } on ArgumentError catch (e) {
        print(e.message);
    }
}
```