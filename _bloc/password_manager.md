---
title: Password Manager
description: >-
    Simplified password-manager demonstrating the use of Cubit
layout: default
---

<style>
.alert {
  padding: 20px;
  background-color: #f44336; /* Red */
  border-radius: 10px;
  color: white;
  margin-bottom: 15px;
}
</style>

<div class="alert">
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

```sh
flutter pub add json_annotation dev:build_runner dev:json_serializable equatable logging shared_preferences cryptography flutter_bloc fast_immutable_collections
```

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

Packages will be explained in for detail when we use them.

# Models

This time we will use code generation for JSON serialization/deserialization.

## Code generation

You can generate once with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

And continuously with:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

# Cryptography

For all password managers, it's important that the stored credentials are kept
confidential.
We can archive this by only storing encrypted credentials.

The basic model is as follows:

- Use [Key derivation function (KDF)](https://en.wikipedia.org/wiki/Key_derivation_function) to derive a encryption key from a master-password.
- The key is used to encrypt credentials before storage.
- Credentials can be retrieved again by deriving an identical key from master-password.

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

*Settings for `Argon2d` are base on [OWASP recommendations](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id)*

We use AES-GCM for encryption.

*Again don't put this in you projection*

```dart
SecretBox secretBox = await AesGcm.with256bits()
  .encryptString(plainText, secretKey: encryptionKey);
List<int> cipherText = secretBox.cipherText;
List<int> nonce = secretBox.nonce;
List<int> mac = secretBox.mac.bytes;
```

Nonce is also known as initialization vector (IV).
And `mac` is a message authentication code/tag.

## Protection layer

It is often good practice to build an abstract around external
libraries/packages.
It shields the rest of the application from API changes in the future versions
of the package.
And allows you to make your own API for the functionality that better fits your
domain.

First, we need class for the encryption key that can be passed around in the
application.
But we don't want still want to limit access to key and we also don't want the
entire application to depend on the
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
    salt.clear();
  }
}
```
