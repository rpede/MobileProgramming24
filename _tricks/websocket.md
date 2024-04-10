---
title: WebSocket
description: >-
    Example of using WebSocket with BLoC pattern.
layout: default
---

![](../websocket_demo_screenshot.png)

# Project

## [Link](https://github.com/rpede/MiniProjectSolution/)

The project is based on an example project provided by my college Alex.
You can find his original [here](https://github.com/uldahlalex/MiniProjectSolution).

I've reimplemented the frontend in Flutter using
[BLoC](https://bloclibrary.dev/) to manage state changes based on events send
from the backend.

## Backend

The backend is a .NET application.
You can find the code in `Api/`.

I've made a couple of changes to the original source code.

1. Remove Azure services.
2. Get `JWT_KEY` and `PG_CONN` from `IConfiguration` instead of `Environment`.

The changes are just to make it simpler to get started.

## Flutter frontend

Code is found in `flutter_frontend`.

[freezed](https://pub.dev/packages/freezed) is used to enhance model classes
through code generation.
It helps create immutable classes, combining features from
[equatable](https://pub.dev/packages/equatable) and
[json_serializable](https://pub.dev/packages/json_serializable)
with a `copyWith` method added.

Code generation can be run with:

```sh
dart run build_runner build
```

---

# Getting started

If you have docker then you can start a database by running `sh setup.sh`.
Otherwise, adjust `PG_CONN` in `Api/appsettings.Development.json`.

Start backend:

```sh
dotnet watch --project Api
```

Start Flutter frontend:

```sh
cd flutter_frontend
flutter pub get
flutter run -d chrome
```

Start Angular frontend:

```sh
cd frontend
npm install
npm start
```

---

# How it works

## Websocket

The [web_socket_channel](https://pub.dev/packages/web_socket_channel) package is
used to connect to the backend.

You connect to a WebSocket with the WebSocketChannel class.
It provides an interface that resembles a StreamController.
Messages added to the **sink** will be sent to the connected server.
Messages sent from the server can be observed from the **stream**.
A message here is just a String.

{% include_relative websocket.drawio.svg %}

Read more on how to [Communicate with WebSockets](https://docs.flutter.dev/cookbook/networking/web-sockets).

The WebSocket protocol for the chat app is based on JSON events.
Each event has an `eventType`.
Events send from client start with `"ClientWants"`
Events from server starts with `"Server"`.
All events are defined in `flutter_frontend/lib/models/events.dart`.
So, to communicate with the server we need serialized events to have
`eventType`.
When deserializing events from server, the `eventType` is used to determine
which which class to user.

## BLoC

The protocol and state changes are implemented in
`flutter_frontend/lib/bloc/chat_bloc.dart`.

Bloc was chosen over Cubit.
Because we are dealing with events.

See [Cubit vs. Bloc](https://bloclibrary.dev/bloc-concepts/#cubit-vs-bloc).

### Client events

**ChatBloc** exposes methods to add events based on user interactions.
Here is an example:

```dart
  /// Sends ClientWantsToSignIn event to server
  void signIn({required String password, required String email}) {
    add(ClientWantsToSignIn(
      eventType: ClientWantsToSignIn.name,
      email: email,
      password: password,
    ));
  }
```

Adding events trigger event handler for the corresponding event type.
All events of type ClientEvent is handled by the same method.

```dart
    // Handler for client events
    on<ClientEvent>(_onClientEvent);
```

The handler method serializes events to JSON, before they are send to the
server.
Sending to server is done by adding messages to the channels sink.

```dart
  FutureOr<void> _onClientEvent(ClientEvent event, Emitter<ChatState> emit) {
    _channel.sink.add(jsonEncode(event.toJson()));
  }
```

### Server events

The constructor listens to messages from server.
It deserialize messages to the correct subclass of ServerEvent.
Then trigger the corresponding event handler, by passing the event to `add`.

```dart
    // Feed deserialized events from server into this bloc
    _channelSubscription = _channel.stream
        .map((event) => jsonDecode(event))
        .map((event) => ServerEvent.fromJson(event))
        .listen(add, onError: addError);
```

Each event is handled by an event handler.

```dart
    // Handlers for server events
    on<ServerAddsClientToRoom>(_onServerAddsClientToRoom);
    on<ServerAuthenticatesUser>(_onServerAuthenticatesUser);
    on<ServerBroadcastsMessageToClientsInRoom>(
        _onServerBroadcastsMessageToClientsInRoom);
    on<ServerNotifiesClientsInRoomSomeoneHasJoinedRoom>(
        _onServerNotifiesClientsInRoomSomeoneHasJoinedRoom);
    on<ServerSendsErrorMessageToClient>(_onServerSendsErrorMessageToClient);
```

Event handlers emit a new state.
This new state is copy of previous state with new information added from the
event.
Here is an example for when client has authenticated:

```dart
  FutureOr<void> _onServerAuthenticatesUser(
      ServerAuthenticatesUser event, Emitter<ChatState> emit) {
    _jwt = event.jwt;
    emit(state.copyWith(
      authenticated: true,
      headsUp: 'Authentication successful!',
    ));
  }
```

*Note: The JWT is in ChatState because it is a secret value that shouldn't be
shown in UI.*

## Models

[Freezed](https://pub.dev/packages/freezed) is used to enhance the model
classes.

Here is an example:

```dart
// This file is "person.dart"
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// required: associates our `person.dart` with the code generated by Freezed
part 'person.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json)
      => _$PersonFromJson(json);
}
```

It is important that you follow the conventions shown.
Otherwise things will break.
Every symbol start with `_$` is code that will be generated.
Pay attention to `part` in top of the files.
Without those, it won't generate the code.

When ever you change the model with freezed, you need to re-run `dart run
build_runner build`.