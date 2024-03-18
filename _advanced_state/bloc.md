---
title: BLoC
description: >-
    Business Logic Component.
    A state management library for Flutter.
layout: default
---

{% include dart_embed %}

# StatefulWidget

With StatefulWidget alone, it is cumbersome to have separate parts of the UI
update to changes in state.

Calling `setState()` only rebuilds that widget and its children.
What if you got a different widget (PersonTitle) somewhere else that you also
want to change?

```run-dartpad:mode-flutter:width-100%:height-1000px
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Person>(
          create: (context) => Person(firstName: "Alice", lastName: "Smith"),
        ),
        Provider<PersonService>(
          create: (context) => PersonService(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: PersonTitle(),
          ),
          body: NameChanger(),
        ),
      ),
    ),
  );
}

class PersonTitle extends StatelessWidget {
  const PersonTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final person = context.read<Person>();
    return Text("$person");
  }
}

class NameChanger extends StatefulWidget {
  const NameChanger({super.key});

  @override
  State<NameChanger> createState() => _NameChangerState();
}

class _NameChangerState extends State<NameChanger> {
  late Person person;

  @override
  void initState() {
    super.initState();
    person = context.read<Person>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$person"),
          ElevatedButton(
            onPressed: () {
              final changedPerson = context
                  .read<PersonService>()
                  .changeName(person, lastName: "Carpenter");
              setState(() {
                person = changedPerson;
              });
            },
            child: Text("Click me"),
          ),
        ],
      ),
    );
  }
}

class PersonService {
  Person changeName(Person person, {String? firstName, String? lastName}) {
    return Person(
      firstName: firstName ?? person.firstName,
      lastName: lastName ?? person.lastName,
    );
  }
}

class Person {
  String firstName;
  String lastName;
  Person({required this.firstName, required this.lastName});
  toString() => "$firstName $lastName";
}
```

# Callbacks

You could try to coordinate state changes by moving the state to a parent widget
and then use callbacks to invoke `setState()`.

It works, but have a number of drawbacks.

1. It changes the structure of your application.
2. If the state is need in a widget deep down the tree, then you need to pass it
through the constructor in all the layers.
3. The entire tree is being rebuild. Not just the parts that are using the
shared state.

```run-dartpad:mode-flutter:width-100%:height-1000px
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Person>(
          create: (context) => Person(firstName: "Alice", lastName: "Smith"),
        ),
        Provider<PersonService>(
          create: (context) => PersonService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Person state;

  @override
  void initState() {
    super.initState();
    state = context.read<Person>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: PersonTitle(person: state),
        ),
        body: NameChanger(
          person: state,
          personChangeCallback: (changedPerson) {
            setState(() {
              state = changedPerson;
            });
          },
        ),
      ),
    );
  }
}

class PersonTitle extends StatelessWidget {
  final Person person;
  const PersonTitle({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Text("$person");
  }
}

class NameChanger extends StatelessWidget {
  final Person person;
  final Function(Person changedPerson) personChangeCallback;
  const NameChanger(
      {super.key, required this.person, required this.personChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$person"),
          ElevatedButton(
            onPressed: () {
            final changedPerson = context
                .read<PersonService>()
                .changeName(person, lastName: "Carpenter");
              personChangeCallback(changedPerson);
            },
            child: Text("Click me"),
          ),
        ],
      ),
    );
  }
}

class PersonService {
  Person changeName(Person person, {String? firstName, String? lastName}) {
    return Person(
      firstName: firstName ?? person.firstName,
      lastName: lastName ?? person.lastName,
    );
  }
}

class Person {
  String firstName;
  String lastName;
  Person({required this.firstName, required this.lastName});
  toString() => "$firstName $lastName";
}
```

# BLoC

BLoC makes it easy to have the widgets that rebuild on state changes.
And we can keep the rebuild to just the parts that depend on the state.

Here I'm using a simplified version of BLoC called Cubit.

```dart
class PersonBloc extends Cubit<Person> {
  PersonBloc(super.initialState);

  void changeName({String? firstName, String? lastName}) {
    emit(Person(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
    ));
  }
}
```

```run-dartpad:mode-flutter:width-100%:height-1000px
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) =>
          PersonBloc(Person(firstName: "Alice", lastName: "Smith")),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: PersonTitle(),
          ),
          body: NameChanger(),
        ),
      ),
    ),
  );
}

class PersonTitle extends StatelessWidget {
  const PersonTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final person = context.watch<PersonBloc>().state;
    return Text("$person");
  }
}

class NameChanger extends StatelessWidget {
  const NameChanger({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<PersonBloc, Person>(
            builder: (context, person) => Text("$person")
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PersonBloc>().changeName(lastName: "Carpenter");
            },
            child: Text("Click me"),
          ),
        ],
      ),
    );
  }
}

class PersonBloc extends Cubit<Person> {
  PersonBloc(super.initialState);

  void changeName({String? firstName, String? lastName}) {
    emit(Person(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
    ));
  }
}

class Person {
  String firstName;
  String lastName;
  Person({required this.firstName, required this.lastName});
  toString() => "$firstName $lastName";
}
```