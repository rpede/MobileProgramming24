---
title: Password Manager
description: >-
    Simplified password-manager demonstrating the use of Cubit
layout: default
---

{% include alert.html %}

<div class="alert danger">
  I do not recommend actually using it.

  The app you will build following this project is overly simplified and therefore not suitable for real world use. 

  I'm using this as an example because I want to do something other than a TODO-list
  app.
  <br>
  <br>

  See <a href="https://en.wikipedia.org/wiki/List_of_password_managers">List of
  password managers</a>
</div> 

![](../password_manager_password_screen.png)
![](../password_manager_vault.png)
![](../password_manager_credential.png)

# Project setup

Create your project as usual.

```sh
flutter create password_manager
```

This project will work on all platforms supported by Flutter.
But you are free to only create it for the platforms you actually care about.

Then install the following packages.

```sh
flutter pub add json_annotation dev:build_runner dev:json_serializable equatable logging logging_appenders shared_preferences cryptography flutter_bloc fast_immutable_collections
```

Some of the packages are only need for development that's why some are prefixed
with `dev:`.

Packages will be explained when we use them.
But here is a quick overview.

| Package | Description |
|-|-|
| build_runner | Runner for programmatic generation of Dart code |
| json_serializable | Generates code to help with JSON serialization |
| json_annotation | Annotations that tell json_serializable how the JSON should look |
| equatable | Helps make data-classes that support equality comparison, hashCode and toString |
| logging | logging library for Dart |
| logging_appenders | some appenders for logging |
| shared_preferences | Local key-value storage that works on all platforms |
| cryptography | Implementation of many cryptographic algorithms |
| flutter_bloc | Flutter package for BLoC |
| fast_immutable_collections | Makes it simple to work with immutable collections |

# Models

This time we will use code generation for JSON serialization/deserialization.

The short version of how it works, is that you add annotations to a plain Dart
class.
[json_serializable](https://pub.dev/packages/json_serializable) use these
annotations to generate code for serialization/deserialization.

You can read more about it on the [package page](https://pub.dev/packages/json_serializable) or
[Flutter docs on JSON](https://docs.flutter.dev/data-and-backend/serialization/json#serializing-json-using-code-generation-libraries).

## Model classes

Add the following files.

`lib/models/credential.dart`

```dart
class Credential {
  final String name;
  final String username;
  final String password;

  const Credential({
    required this.name,
    required this.username,
    required this.password,
  });
}
```

`lib/models/encrypted_vault.dart`

```dart
class EncryptedVault {
  final List<int> salt;
  final List<int> nonce;
  final List<int> mac;
  final List<int> cipherText;

  EncryptedVault({
    required this.salt,
    required this.nonce,
    required this.mac,
    required this.cipherText,
  });
}
```

`lib/models/open_vault.dart`

```dart
class OpenVault {
  List<Credential> credentials;
  Key key;
  OpenVault({required this.credentials, required this.key});
}
```

**Key will be defined later**

## About the classes

`Credential` represents a credential for a service (username+password).
It also got a name field, so you can tell what service the credentials are for.

A vault is a container for a list of credentials.
We got two versions of a vault.

- `EncryptedVault` contains encrypted credentials. The `List<int>` represents a
sequence of bytes.
- `OpenVault` contains unencrypted credentials. It even got a key in it.

## Refining the models

### Equatable

Later on, we need to be able to compare to instances of `Credential` for
equality (`a == b`).
So we might as well implement it now.

The default behavior you get in Dart, is that two object are equal if they are
the same instance.
It can, however, be changed by overriding the [operator
==](https://api.dart.dev/stable/3.3.1/dart-core/Object/operator_equals.html).
When overriding it, one should also override the `hashCode` method.
It can be super annoying to do manually.
So, we will use the [equatable](https://pub.dev/packages/equatable) package to
help us.

Equatable also supports `toString`.
However, we don't want passwords in logs, so we override it manually.

Change `Credential` class, so it extends `Equatable`.
Now, you just need to implement the `prop` method to return all instance
variables.

Here is the full version:

```dart
import 'package:equatable/equatable.dart';

class Credential extends Equatable {
  final String name;
  final String username;
  final String password;

  const Credential({
    required this.name,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [name, username, password];

  @override
  String toString() => "$runtimeType($name, $username, ***)";
}
```

### Json serializable

The `Credential` class needs to be serializable so it can be encrypted.
And, to make storage management simpler, we will also make `EncryptedVault`
serializable.

The unencrypted `OpenVault` is only meant to exist in memory for a short-period
of time.
We will never store credentials unencrypted, so there is no need to make it
serializable.

Make `Credential` and `EncryptedVault` JSON serializable by adding
`@JsonSerializable()` to the class definition.
Example:

```dart
@JsonSerializable()
class Credential {
  // ...
}
```

By default `List<int>` will be serialized as an array of numbers.
We can make it more compact by base64 encoding it instead.

Add a converter to `lib/models/encrypted_vault.dart`.

```dart
class Base64Converter implements JsonConverter<List<int>, String> {
  const Base64Converter();
  @override
  List<int> fromJson(String json) => base64Decode(json);

  @override
  String toJson(List<int> bytes) => base64Encode(bytes);
}
```

Now add `@Base64Converter()` on a new line above each of the instance variables in `EncryptedVault`.
Example:

```dart
@JsonSerializable()
class EncryptedVault {
  @Base64Converter()
  final List<int> salt;
  // ...
}
```

## Code generation

The code for `toJson` and `fromJson` can be generated based on the annotations
you just added.

You can generate once with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

And continuously with:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

Try it out!

...

Nothing interested happened.
It printed some stuff, that's it.

```
[INFO] Generating build script completed, took 318ms
[INFO] Precompiling build script... completed, took 7.0s
[INFO] Building new asset graph completed, took 1.2s
[INFO] Checking for unexpected pre-existing outputs. completed, took 1ms
[INFO] Generating SDK summary completed, took 4.7s
[WARNING] source_gen:combining_builder on lib/models/encrypted_vault.dart:
encrypted_vault.g.dart must be included as a part directive in the input library with:
    part 'encrypted_vault.g.dart';
[WARNING] source_gen:combining_builder on lib/models/credentials.dart:
credentials.g.dart must be included as a part directive in the input library with:
    part 'credentials.g.dart';
[INFO] Running build completed, took 15.2s
[INFO] Caching finalized dependency graph completed, took 104ms
[INFO] Succeeded after 15.3s with 52 outputs (112 actions)
```

Let's examine one of the warnings.

```
[WARNING] source_gen:combining_builder on lib/models/credentials.dart:
credentials.g.dart must be included as a part directive in the input library with:
    part 'credentials.g.dart';
```

Add `part 'credential.g.dart';` right under the imports in
`lib/models/credential.dart`.
Now, try the code generation command again.
This time it created a `credential.g.dart` file.
The "g" is short for generated.
If you open it up, you will find:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../_bloc/credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credential _$CredentialFromJson(Map<String, dynamic> json) => Credential(
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$CredentialToJson(Credential instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
    };

```

What we got are some helper methods that does JSON conversion to and from an
instance of the class.
You just have to add the following to `Credentials`:

```dart
  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
  Map<String, dynamic> toJson() => _$CredentialToJson(this);
```

Practice by doing the same with `lib/models/encrypted_vault.dart`.

It might seem like a lot of work for very little.
However, for a big project with many models that occasionally change, then this
technique will save you a lot of hassle.

<div class="alert info">
  <b>Why do you need to do so much work just to serialize something to
  JSON in Dart?</b>
  <p>
  C# and some other programming languages that you might be familiar with.
  They got something called <a
  href="https://en.wikipedia.org/wiki/Type_introspection">type
  introspection</a>.
  In those programming languages you can write code that can inspect the fields of
  a type at runtime.
  This feature makes it possible to write a JSON serialization library that
  (mostly) just works with no additional configuration for any kind of object
  you through at it.
  </p>
  <p>
  Type introspection adds overhead to the runtime .
  Since Dart is designed to declaratively write UI that updates with 60 FPS on
  commodity phones, the designers have decided against the added overhead.
  </p>
</div>

# Cryptography

In all password managers, it's important that the stored credentials are kept
confidential.
We can achieve the goal by only storing encrypted credentials.

The basic model is as follows:

- Use [Key derivation function (KDF)](https://en.wikipedia.org/wiki/Key_derivation_function) to derive an encryption key from a master-password.
- The key is used to encrypt credentials before storage.
- Credentials can be retrieved again by deriving an identical key given the same
master-password.

## Algorithms

Our app will use cryptographic algorithms implemented in the
[cryptography](https://pub.dev/packages/cryptography) package.

We will use Argon2id as KDF.

*This code snippet is just an example.
Don't put it in your project.*

```dart
import 'package:cryptography/cryptography.dart';

String masterPassword = askUserForMasterPassword();

KdfAlgorithm kdfAlgorithm = Argon2id(
  parallelism: 1,
  memory: 12288,
  iterations: 3,
  hashLength: 256 ~/ 8,
);

List<int> salt = List<int>.generate(32, (i) => SecureRandom.safe.nextInt(256));
SecretKey encryptionKey = await kdfAlgorithm.deriveKeyFromPassword(
    password: masterPassword, nonce: salt);
```

Settings for `Argon2d` are based on [OWASP recommendations](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id)

We use AES-GCM for encryption.

*Again, don't put this in your project.*

```dart
SecretBox secretBox = await AesGcm.with256bits()
  .encryptString(plainText, secretKey: encryptionKey);
List<int> cipherText = secretBox.cipherText;
List<int> nonce = secretBox.nonce;
List<int> mac = secretBox.mac.bytes;
```

Nonce is also known as initialization vector (IV).
And MAC is a message authentication code/tag.

## Protection

It is often good practice to build an abstraction around external
libraries/packages.
It shields the rest of the application from API changes in the future versions
of the package.
And allows you to build an API for the functionality that better fits the
domain.

First, we need a class for the encryption key that can be passed around in the
application.
We also want to limit access to the key.
Our entire application to depend on the
[cryptography](https://pub.dev/packages/cryptography) package.
Sound like a difficult problem to solve, but it can actually be done pretty
simple.

Add a new `lib/infrastructure/protection.dart` file with:

```dart
sealed class Key {
  void destroy();
}

class _Key extends Key {
  final SecretKey secretKey;
  final List<int> salt;

  _Key(this.secretKey, {required this.salt});

  @override
  void destroy() {
    secretKey.destroy();
    salt.setAll(0, List.filled(salt.length, 0));
  }
}
```

Sealed classes are abstract classes that cannot be extended outside their own
package.
See [sealed class modifier](https://dart.dev/language/class-modifiers#sealed).

It means that the only way to instantiate `Key` is through its `_Key` sub-class
which isn't accessible outside its own package.
The only publicly available part of `Key` is its `destroy()` method.
The application should call `destroy` when the key is no longer needed.
In other words when we are closing the vault.

The cryptography package works with `SecretBox` class.
It is just a container for cipher-text, nonce and salt.
Add these extensions to the file, to easily convert between `SecretBox` and our
`EncryptedVault` model class.

```dart
extension EncryptedVaultX on EncryptedVault {
  SecretBox toSecretBox() => SecretBox(cipherText, nonce: nonce, mac: Mac(mac));
}

extension SecretBoxX on SecretBox {
  EncryptedVault toEncryptedVault({required List<int> salt}) {
    return EncryptedVault(
      salt: salt,
      nonce: nonce,
      mac: mac.bytes,
      cipherText: cipherText,
    );
  }
}
```

Now for the actual vault protection layer.
Add this to the same file.

```dart
class Protection {
  final KdfAlgorithm kdfAlgorithm;
  final Cipher cipher;

  Protection({required this.kdfAlgorithm, required this.cipher});

  Protection.sensibleDefaults()
      : kdfAlgorithm = Argon2id(
          parallelism: 1,
          memory: 12288,
          iterations: 3,
          hashLength: 256 ~/ 8,
        ),
        cipher = AesGcm.with256bits();

  Future<Key> createKey(String masterPassword) async {
    final salt = generateSalt();
    final secretKey = await kdfAlgorithm.deriveKeyFromPassword(
        password: masterPassword, nonce: salt);
    return _Key(secretKey, salt: salt);
  }

  List<int> generateSalt() =>
      List<int>.generate(32, (i) => SecureRandom.safe.nextInt(256));

  Future<Key> recreateKey(EncryptedVault vault, String masterPassword) async {
    final secretKey = await kdfAlgorithm.deriveKeyFromPassword(
      password: masterPassword,
      nonce: vault.salt,
    );
    return _Key(secretKey, salt: vault.salt);
  }

  Future<List<Credential>> decrypt(EncryptedVault encryptedVault, Key key) async {
    final jsonString = await cipher.decryptString(
      encryptedVault.toSecretBox(),
      secretKey: (key as _Key).secretKey,
    );
    final json = jsonDecode(jsonString) as List<dynamic>;
    return List<Credential>.from(json.map((e) => Credential.fromJson(e)));
  }

  Future<EncryptedVault> encrypt(OpenVault openVault) async {
    final key = (openVault.key as _Key);
    final encrypted = await cipher.encryptString(
        jsonEncode(openVault.credentials),
        secretKey: key.secretKey);
    return encrypted.toEncryptedVault(salt: key.salt);
  }
}
```

The `Protection` class can create an encryption key from a password.
It can then encrypt and decrypt a vault with the key.

It can be instantiated with different algorithms, but also provides a
`Protection.sensibleDefaults()` to instantiate it with some sensible defaults.
Being able to change the algorithms allows you to instantiate it with a dummy
implementation to speed up tests.

## Storage

We use `SharedPreferences` from
[shared_preferences](https://pub.dev/packages/shared_preferences) package for
storage.
It provides a simple key-value API to store app data that works on all
platforms.
The underlying storage mechanism differs between platforms.
See table:

| Platform | Location |
|-|-|
| Android | SharedPreferences |
| iOS | NSUserDefaults |
| Linux | In the XDG_DATA_HOME directory |
| macOS | NSUserDefaults |
| Web | LocalStorage |
| Windows | In the roaming AppData directory |

Let's build an small abstraction around it too.
In `lib/infrastructure/storage.dart`, add:

```dart
class Storage {
  static const _key = 'data';
  final SharedPreferences _preferences;

  Storage._(this._preferences);

  bool get exits => _preferences.containsKey(_key);

  static Future<Storage> create() async {
    return Storage._(await SharedPreferences.getInstance());
  }

  Future<bool> save(EncryptedVault vault) =>
      _preferences.setString(_key, jsonEncode(vault.toJson()));

  EncryptedVault? load() {
    final json = _preferences.getString(_key);
    if (json == null) return null;
    return EncryptedVault.fromJson(jsonDecode(json));
  }

  delete() => _preferences.clear();
}
```

To simplify things, we just JSON encode the entire vault and store it as a
single value.

`SharedPreferences` needs to be initialized before it can be used.
It is done with `SharedPreferences.getInstance()`.
This initialization is async, so it can't be done in the constructor of
`Storage`.
We therefor use an async factory method to create an instance of it.

# Core

## API

We got our two infrastructure classes (Protection & Storage).
Time to build a high-level API around them that expose the core functionality of
our app.

`lib/core/vault_api.dart`

```dart
class VaultApi {
  final Storage _storage;
  final Protection _protector;

  VaultApi({required storage, required Protection protector})
      : _protector = protector,
        _storage = storage;

  bool get exists => _storage.exits;

  Future<OpenVault> create(
      String masterPassword) async {
    final key = await _protector.createKey(masterPassword);
    final vault = OpenVault(credentials: <Credential>[], key: key);
    await _storage.save(await _protector.encrypt(vault));
    return vault;
  }

  Future<OpenVault> open(String masterPassword) async {
    final vault = _storage.load();
    if (vault == null) throw VaultNotFoundFailure();
    final key = await _protector.recreateKey(vault, masterPassword);
    final credentials = await _protector.decrypt(vault, key);
    return OpenVault(credentials: credentials, key: key);
  }

  Future<bool> save(OpenVault vault) async {
    final encryptedVault = await _protector.encrypt(vault);
    return await _storage.save(encryptedVault);
  }
}
```

*VaultNotFoundFailure will be defined in a bit.*

| Method | Description |
|-|-|
| create | Creates a vault that can only be opened with the given master-password. |
| save | Protect and store the given vault |
| open | Opens the stored vault when given the same master-password that was used to create it. |
| exists | Check if a stored vault exists. |

With protect (above), I mean encrypt with AES.
With store, I mean JSON encode and save using SharedPreferences.
Those are low-level details that we shouldn't be concerned with at this level of abstraction.

Notice that `create`, `open` and `save` are all async.

## State

Now that we got all the fundamental application logic implemented, we can start
how to manage state in the app.

The vault can either be open, closed, absent or transitioning between.

- **Open** means that the vault exists unencrypted in the memory of our app.
- **Closed** means a vault is only stored in an encrypted form.
- **Absent** means that a vault hasn't been created yet.

So, the status of our app can be either:

```dart
enum VaultStatus {
  open,
  closed,
  absent,
  opening,
  saving,
}
```

In addition, our app state can have any number of credentials.
And, we also need a way to deal with any failures.
So, the entire state of the app can be expressed with an instance of:

```dart
class VaultState extends Equatable {
  final IList<Credential> credentials;
  final VaultStatus status;
  final Failure? failure;
}
```

Failures should have a message describing what is wrong.

```dart
abstract class Failure implements Exception {
  String get message;
}

class OpenVaultFailure extends Failure {
  @override
  String get message => """
Unable to open vault.
Did you type the correct password?
  """;
}

class VaultNotFoundFailure extends Failure {
  @override
  String get message => "Vault not found.";
}

class SaveVaultFailure extends Failure {
  @override
  String get message => """
Unable to save vault.
Please try again or check logs.
""";
}

class UnknownVaultFailure extends Failure {
  @override
  String get message => """
An unknown error has occurred.
See log for details.
""";
}
```

Put the failures above in a file `lib/core/failures.dart`.

Then put the following in `lib/core/vault_state.dart`.

```dart
enum VaultStatus {
  open,
  closed,
  absent,
  opening,
  saving,
}

class VaultState extends Equatable {
  final IList<Credential> credentials;
  final VaultStatus status;
  final Failure? failure;

  const VaultState({
    required this.credentials,
    required this.status,
    this.failure,
  });

  VaultState.initial(bool exists)
      : credentials = <Credential>[].lock,
        status = exists ? VaultStatus.closed : VaultStatus.absent,
        failure = null;

  VaultState failed({VaultStatus? status, required Failure reason}) {
    return copyWith(status: status, failure: reason);
  }

  VaultState ok({
    IList<Credential>? credentials,
    required VaultStatus status,
  }) {
    return copyWith(credentials: credentials, status: status, failure: null);
  }

  VaultState copyWith({
    IList<Credential>? credentials,
    VaultStatus? status,
    Failure? failure,
  }) {
    return VaultState(
      credentials: credentials ?? this.credentials,
      status: status ?? this.status,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [credentials, status];
}
```

Notice that I've added some extra methods.
The state is immutable, so when we want to express a new state, we make a copy of
the old with some fields having a different value.
The added methods are there for convenience, making it easier to copy with changes.

It is also `Equatable`.
Meaning we can compare if two states are equivalent.
The UI will be rebuild when `previousState != newState`.

Notice the type `IList<Credential>`.
The "I" is for immutable (not interface).
The type comes from the
[fast_immutable_collections](https://pub.dev/packages/fast_immutable_collections)
package.

## Why immutability is important?

To answer, let's first look at the meaning behind the word.

- **Mutable**: able to mutate/change
- **Immutable**: not able to mutate/change

Using only immutable state prevents us from changing state all over the place
thereby making it difficult to debug the app. 
However, having an app that doesn't react to user input because its state can't
be changed is not fun.
So, we need state changes to happen somewhere.
That somewhere is in a bloc or cubit.

## Cubit

Start of by adding following to `lib/core/vault_cubit.dart`:

```dart
class VaultCubit extends Cubit<VaultState> {
  final VaultApi api;
  Key? _key;

  VaultCubit(this.api) : super(VaultState.initial(api.exists));
}
```

It takes a `VaultApi` as constructor parameter.
Then calls the constructor on the super class with an initial state based on
whether a stored vault exists.

*(_key will be explained in a moment.)*

Add methods to the VaultCubit class, one by one as I explain them.

### Create vault

```dart
  Future<void> createVault(String masterPassword) async {
    // If an vault is absent then allow creating one.
    // We shouldn't allow accidentally override all stored passwords.
    assert(state.status == VaultStatus.absent);

    // We start by emitting an "opening" state.
    // It can be used to show a spinner in UI.
    emit(state.ok(status: VaultStatus.opening));

    try {
      // Ask api to create a new vault that can be opened with the given master
      // password.
      final vault = await api.create(masterPassword);
      // The key shouldn't be accessible through the UI, so we store it in a
      // private instance variable.
      _key = vault.key;
      
      // Emit "open" state with credentials converted to IList (immutable list).
      emit(state.ok(
        credentials: vault.credentials.lock,
        status: VaultStatus.open,
      ));
    } catch (e) {
      // If something goes wrong we emit new "absent" state with a generic
      // failure.
      emit(state.failed(
        status: VaultStatus.absent,
        reason: UnknownVaultFailure(),
      ));
      // Forward details to `addError` so a BlocObserver can log it.
      addError(e);
    }
  }
```

<div class="alert info">
A Cubit would normally not have any instance variables (other than through its
constructor).
Doing it here is a compromise, as I don't want the key anyway near UI.
</div>

### Open vault

```dart
  Future<void> openVault(String masterPassword) async {
    // It doesn't make sense to attempt to open a vault if it is absent.
    assert(state.status == VaultStatus.closed);

    // Emit "opening" so UI can show a spinner (or some other indicator).
    emit(state.ok(status: VaultStatus.opening));
    try {
      // Attempt to open the stored vault.
      // It will throw an exception if `masterPassword` is wrong.
      final vault = await api.open(masterPassword);

      // The key shouldn't be accessible through the UI, so we store it in a
      // private instance variable.
      _key = vault.key;

      // Emit "open" state with credentials converted to IList (immutable list).
      emit(state.ok(
        credentials: vault.credentials.lock,
        status: VaultStatus.open,
      ));
    } catch (e) {
      // If something goes wrong we emit new "absent" state with a specialized
      // failure message.
      emit(state.failed(
        status: VaultStatus.closed,
        reason: OpenVaultFailure(),
      ));
      // Forward details to `addError` so a BlocObserver can log it.
      addError(e);
    }
  }
```

### Add credential

```dart
  Future<void> addCredential(Credential credential) async {
    // Requires that the vault have opened.
    assert(state.status == VaultStatus.open);

    // Emit "saving" so UI can show an indication.
    emit(state.ok(status: VaultStatus.saving));
    try {
      // "unlock" (getting mutable copy) credentials.
      // Then add the new credential.
      final credentials = state.credentials.unlock..add(credential);

      // Save the new credentials immediately.
        await api.save(OpenVault(credentials: credentials, key: _key!));

      // "lock" (get immutable copy) credentials and emit it as a new "open"
      // state.
      emit(state.ok(
        credentials: credentials.lock,
        status: VaultStatus.open,
      ));
    } catch (e) {
      // Transition back to "open" state if something goes wrong.
      emit(state.failed(
        status: VaultStatus.open,
        reason: SaveVaultFailure(),
      ));
      addError(e);
    }
  }
```

### Close vault

```dart
  void closeVault() {
    // Destroy key.
    // User would have to open with same master-password to access credentials
    // again.
    _key?.destroy();
    // "closed" state with empty credentials.
    emit(state.ok(
      credentials: <Credential>[].lock,
      status: VaultStatus.closed,
    ));
  }
```

### Auto close whe idle

As an extra security mechanism, we want the vault to automatically close after
it has been idle for a while.

This is actually really easy to do.
There is a `onChange` method that gets called each time a new state is emitted.
All we need is a timer that gets reset each "open" state change.

Add to the top of `VaultCubit`:

```dart
  static const closeAfter = Duration(minutes: 1);
  Timer? _timer;
```

Then override `onChange`.

```dart
  @override
  void onChange(Change<VaultState> change) {
    super.onChange(change);
    if (change.nextState.status == VaultStatus.open) {
      _timer?.cancel();
      _timer = Timer(closeAfter, closeVault);
    }
  }
```

We want `closeAfter` to be short enough that a malicious person can't get access
to credentials if the device is suddenly left unattended.
But it should also be long enough that it doesn't annoy the user.

## Observability

Another neat thing you can do with BLoC/Cubit is to register an observer which
is an object that gets called each time the state changes (or on errors).

Add this to a file somewhere:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class LoggerBlocObserver extends BlocObserver {
  final log = Logger('LoggerBlocObserver');
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log.log(Level.INFO, '${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.log(Level.WARNING, '${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
```

It simply logs all state changes and errors using the
[logging](https://pub.dev/packages/logging) package.
This is also why `Key` isn't part of the state object.

In the top of your `main` method you do:

```dart
  PrintAppender(formatter: const ColorFormatter()).attachToLogger(Logger.root);
  Bloc.observer = LoggerBlocObserver();
```

First, we are setting the root logger to just print the logged record (with
colors).
When we start having beta testers project (hypothetically), then we will
reconfigure it to log to a server.
That way we will be able to automatically capture details on any errors.

Next, the `LoggerBlocObserver` is registered with the bloc library.

# UI

## Main

Start by making the `main` function async.

Then await the creation on `Storage`:

```dart
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await Storage.create();
```

Next, wrap your app with a `BlocProvider` like:

```dart
  runApp(BlocProvider(
    create: (context) => VaultCubit(
      VaultApi(protector: Protection.sensibleDefaults(), storage: storage),
    ),
    child: const MyApp(),
  ));
```

The provider allows widgets throughout the app to access `VaultCubit` and its
state.

## MyApp

Replace `MyApp` with:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PasswordManager',
      home: BlocListener<VaultCubit, VaultState>(
          listenWhen: (previous, current) => current.failure != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message)));
          },
          child: const PasswordScreen()),
    );
  }
}
```

A `BlocLister` allows you to execute something, that should happen only once for
every state change.
We are going to use it to display a `SnackBar` message.
See [BlocListener docs](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocListener-class.html).

Remove the `MyHomePage` widget.
We don't need the demo app.

**Android Studio will give some red lines while typing in the screens.
Either live with it for a while, or out-comment the offending lines along, then
fix imports at the end.**

## Password screen

The first thing the user will be presented with is the password screen (for
master-password).

`lib/ui/password_screen.dart`

```dart
class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your master password"),
        centerTitle: true,
      ),
      body: BlocConsumer<VaultCubit, VaultState>(
        listenWhen: (previous, current) => current.status == VaultStatus.open,
        listener: (context, state) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const VaultScreen()),
          );
        },
        builder: (context, state) {
          return switch (state.status) {
            VaultStatus.absent => PasswordForm(
                onSubmit: (password) =>
                    context.read<VaultCubit>().createVault(password),
                buttonText: "Create",
              ),
            VaultStatus.closed => PasswordForm(
                onSubmit: (password) =>
                    context.read<VaultCubit>().openVault(password),
                buttonText: "Open",
              ),
            _ => const Center(child: CircularProgressIndicator.adaptive()),
          };
        },
      ),
    );
  }
}
```

Here, we will use another bloc related widget.
That is the `BlockConsumer`.
It works like a `BlockLister`, but it also takes `builder` function as a
parameter, which can build a child tree based on the `state` of a Cubit.
In this case that will be our `VaultCubit`.

There are two variations.
Either a stored vault is **absent**, in which case a new can be created with
master password.
Or it is **closed**, in which case the user can open it by entering the same
master password that was used to create it.
In either case, the state will transition to "open", which makes the listener
navigate to another screen.

We also need to define the form.

```dart
class PasswordForm extends StatefulWidget {
  final Function(String password) onSubmit;
  final String buttonText;

  const PasswordForm({
    super.key,
    required this.onSubmit,
    required this.buttonText,
  });

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_passwordController.text);
  }

  String? _passwordValidator(String? value) {
    const minLength = 8;
    final invalid = value == null || value.length < minLength;
    return invalid ? "Must be at least $minLength" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          const Text("Password"),
          TextFormField(
            controller: _passwordController,
            validator: _passwordValidator,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (newValue) => _formKey.currentState!.validate(),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          Center(
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: Text(widget.buttonText),
            ),
          ),
        ]),
      ),
    );
  }
}
```

The method `_passwordValidator` shows an error if the entered password is less
than 8 characters.

`_handleSubmit` checks validation invoking `onSubmit` callback.

## Vault screen

This is the screen that gets shown when the vault has been opened.

`lib/ui/vault_screen.dart`

```dart
class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  void _addNewCredential(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CredentialScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.read<VaultCubit>().closeVault(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Your Vault")),
        body: BlocConsumer<VaultCubit, VaultState>(
          listenWhen: (previous, current) =>
              current.status == VaultStatus.closed,
          listener: (context, state) => Navigator.pop(context),
          builder: (context, state) => CredentialList(credentials: state.credentials),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewCredential(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

[PopScope](https://api.flutter.dev/flutter/widgets/PopScope-class.html) allows
overriding the behavior when back navigation is invoked.
Either by gesture or the back button.
We override it here to close the vault.

We also see another `BlocConsumer`.
Here the `listenerWhen` and `listener` will make sure the navigation is popped
once the vault has been closed.
The `builder` returns a `CredentialsList` widget (which we will define in a moment).

We also have a button to push a new screen for adding credentials.

```dart
class CredentialList extends StatelessWidget {
  const CredentialList({
    super.key,
    required this.credentials,
  });

  final IList<Credential> credentials;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => CredentialListTile(credential: credentials[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: credentials.length,
    );
  }
}


class CredentialListTile extends StatelessWidget {
  const CredentialListTile({
    super.key,
    required this.credential,
  });

  final Credential credential;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(credential.name),
      subtitle: Text(credential.username),
      trailing: PopupMenuButton<MenuAction>(
        onSelected: (MenuAction action) => action.call(),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
          PopupMenuItem<MenuAction>(
            value: () => Clipboard.setData(ClipboardData(text: credential.username)),
            child: const Text('Copy username'),
          ),
          PopupMenuItem<MenuAction>(
            value: () => Clipboard.setData(ClipboardData(text: credential.password)),
            child: const Text('Copy password'),
          ),
          PopupMenuItem<MenuAction>(
            value: () {
              // TODO remove credential
            },
            child: const Text('Remove'),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CredentialScreen(existingCredential: credential),
      )),
    );
  }
}

typedef MenuAction = void Function();
```

Here we have a
[PopupMenuButton](https://api.flutter.dev/flutter/material/PopupMenuButton-class.html)
that gives options to copy username or password to
[Clipboard](https://api.flutter.dev/flutter/services/Clipboard-class.html).

## Credential screen

The credentials screen allowing user to add new credentials.

`lib/ui/credential_screen.dart`

```dart
class CredentialScreen extends StatefulWidget {
  final Credential? existingCredential;

  const CredentialScreen({super.key, this.existingCredential});

  @override
  State<CredentialScreen> createState() => _CredentialScreenState();
}

class _CredentialScreenState extends State<CredentialScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;
  var showPassword = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingCredential?.name);
    _usernameCtrl = TextEditingController(text: widget.existingCredential?.username);
    _passwordCtrl = TextEditingController(text: widget.existingCredential?.password);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void save() {
    final vault = context.read<VaultCubit>();
    final credential = Credential(
      name: _nameCtrl.text,
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );
    if (widget.existingCredential == null) {
      vault.addCredential(credential);
    } else {
      // TODO update existing credential
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Credential")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            NameField(controller: _nameCtrl),
            UsernameField(controller: _usernameCtrl),
            PasswordField(controller: _passwordCtrl),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
            SaveButton(onSave: save),
          ],
        ),
      ),
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(label: Text("Username")),
    );
  }
}

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(label: Text("Name/Site")),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            obscureText: !showPassword,
            decoration: const InputDecoration(label: Text("Password")),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
        IconButton.outlined(
          onPressed: () {
            setState(() => showPassword = !showPassword);
          },
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
        IconButton.outlined(
          onPressed: () {
            // TODO generate a random password
          },
          icon: const Icon(Icons.casino),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  final Function() onSave;

  const SaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultCubit, VaultState>(builder: (context, state) {
      if (state.status == VaultStatus.saving) {
        return const CircularProgressIndicator();
      } else {
        return ElevatedButton(
          onPressed: onSave,
          child: const Text("Save"),
        );
      }
    });
  }
}
```

It is "just" a simple form with 3 input fields.
One for name, username and password.

The password has a toggle for visibility (obscured by default).

When "Save" button is pressed and the fields pass validation, it will call
`addCredential` on the `VaultCubit` instance with the text values from input
fields.
The "Save" button gets disabled while saving.

# Closing thoughts

You're close to have created a *toy* password manager.

There are still some important features missing.
See if you can implement those in the challenges below.

# Challenges

**Searching for TODO might give you some hints**

## Generate password

People are bad at inventing good passwords, so you should add functionality to
generate passwords.

## Remove credential

Allow the user to clean up old accounts by providing a function to remove
credentials.

Maybe you should present a dialog or something to make sure they don't remove
credentials by accident.

## Update credential

Add functionality for updating credentials.

You should be able to reuse most of `CredentialScreen`.