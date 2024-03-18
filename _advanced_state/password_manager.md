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

# Project setup

Create your project as usual.

```sh
flutter create password_manager
```

This project will work on all platforms supported by Flutter.
But you are free to only create it for the platforms you actually care about.

Then install the following packages.

```sh
flutter pub add json_annotation dev:build_runner dev:json_serializable equatable logging shared_preferences cryptography flutter_bloc fast_immutable_collections
```

Some of the package are only need for development that's why some are prefixed
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
import '../infrastructure/protection.dart';
import '../_bloc/credential.dart';

class OpenVault {
  List<Credential> credentials;
  Key key;
  OpenVault({required this.credentials, required this.key});
}
```

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
So we will use the [equatable](https://pub.dev/packages/equatable) package to
help us.

Equatable also supports `toString`.
However we don't want passwords in logs, so we override it manually.

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
We will never store credentials unencrypted, so no need to make it serializable.

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
It printed some stuff, thats it.

```
[INFO] Generating build script completed, took 310ms
[INFO] Reading cached asset graph completed, took 114ms
[INFO] Checking for updates since last build completed, took 1.0s
[WARNING] source_gen:combining_builder on lib/models/encrypted_vault.dart:
encrypted_vault.g.dart must be included as a part "../_bloc"directive in the input library with:
    part '../_bloc/encrypted_vault.g.dart';
[WARNING] source_gen:combining_builder on lib/models/credential.dart:
credential.g.dart must be included as a part "../_bloc"directive in the input library with:
    part '../_bloc/credential.g.dart';
[INFO] Running build completed, took 14.7s
[INFO] Caching finalized dependency graph completed, took 128ms
[INFO] Succeeded after 14.8s with 585 outputs (1181 actions)
```

Let's examine one of the warnings.

```
[WARNING] source_gen:combining_builder on lib/models/credential.dart:
credential.g.dart must be included as a part "../_bloc"directive in the input library with:
    part '../_bloc/credential.g.dart';
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

- Use [Key derivation function (KDF)](https://en.wikipedia.org/wiki/Key_derivation_function) to derive a encryption key from a master-password.
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
We also want to limit access to key.
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

Sealed classes are abstract classes that can not be extended outside their own
package.
See [sealed class modifier](https://dart.dev/language/class-modifiers#sealed).

It means that the only way to instantiate `Key` is through its `_Key` sub-class
which isn't accessible outside its own package.
The only public available part of `Key` is its `destroy()` method.
The application should call `destroy` when the key is no longer need.
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

The `Protection` class can create en encryption key from a password.
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

  delete() => _preferences.clear;
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
    final key = await _protector.getKey(vault, masterPassword);
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
- **Absent** means that a vault haven't been created yet.

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

class KeyMissingFailure extends Failure {
  @override
  String get message => """
Key is missing.
Vault haven't been opened.
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
The state is immutable, so when we want to express a new state we make a copy of
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
thereby it hard to debug the app. 
However, having an app that doesn't react to user input because its state can't
changed is not fun.
So we need state changes to happen somewhere.
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
    // We don't want to accidentally override all stored passwords.
    if (state.status != VaultStatus.absent) return;

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
    if (state.status != VaultStatus.closed) return;

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