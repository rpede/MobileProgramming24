---
title: Immutability
description: >-
    Mutable vs immutable
layout: default
---

{% include dart_embed %}

```run-dartpad:mode-flutter:width-100%:height-1000px
/*
  __  __      _        _    _     
 |  \/  |_  _| |_ __ _| |__| |___ 
 | |\/| | || |  _/ _` | '_ \ / -_)
 |_|  |_|\_,_|\__\__,_|_.__/_\___|                                             
*/
class Person {
  String firstName;
  String lastName;
  Person({required this.firstName, required this.lastName});
  
  toString() => "$firstName $lastName";
}

void main() {
  final p1 = Person(firstName: "Alice", lastName: "Smith");
  print("p1: $p1}");
  final p2 = changeName(p1, lastName: 'Carpenter');
  print("p1: $p1");
  print("p2: $p1");
  print("Are p1 and p2 identical? ${identical(p1, p2)}");
}

void changeName(Person person, {required String lastName}) {
  person.lastName = lastName;
}
```

```run-dartpad:mode-flutter:width-100%:height-1000px
/*
  ___                 _        _    _     
 |_ _|_ __  _ __ _  _| |_ __ _| |__| |___ 
  | || '  \| '  \ || |  _/ _` | '_ \ / -_)
 |___|_|_|_|_|_|_\_,_|\__\__,_|_.__/_\___|
*/
class Person {
  final String firstName;
  final String lastName;
  const Person({required this.firstName, required this.lastName});
  
  toString() => "$firstName $lastName";
}

void main() {
  final p1 = Person(firstName: "Alice", lastName: "Smith");
  print("p1: $p1}");
  final p2 = changeName(p1, lastName: 'Carpenter');
  print("p1: $p1");
  print("p2: $p2");
  print("Are p1 and p2 identical? ${identical(p1, p2)}");
}

Person changeName(Person person, {required String lastName}) {
  return Person(firstName: person.firstName, lastName: lastName);
}
```