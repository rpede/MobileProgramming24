---
title: Immutability
description: >-
    Mutable vs immutable
layout: default
---

{% include dart_embed %}

<iframe src="https://easv.cloud.panopto.eu/Panopto/Pages/Embed.aspx?id=950a575f-9c64-4e19-93c1-b13700fc1583&autoplay=false&offerviewer=true&showtitle=true&showbrand=true&captions=false&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay" aria-label="Panopto Embedded Video Player"></iframe>

# Mutable class

```run-dartpad:mode-dart:width-100%:height-600px
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
  print("p1: $p1");
  final p2 = changeName(p1, lastName: 'Carpenter');
  print("p1: $p1");
  print("p2: $p2");
  print("Are p1 and p2 identical? ${identical(p1, p2)}");
}

Person changeName(Person person, {required String lastName}) {
  person.lastName = lastName;
  return person;
}
```

# Immutable class

```run-dartpad:mode-dart:width-100%:height-600px
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
  print("p1: $p1");
  final p2 = changeName(p1, lastName: 'Carpenter');
  print("p1: $p1");
  print("p2: $p2");
  print("Are p1 and p2 identical? ${identical(p1, p2)}");
}

Person changeName(Person person, {required String lastName}) {
  return Person(firstName: person.firstName, lastName: lastName);
}
```