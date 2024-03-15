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

Some of the package are only need for development that's why some are prefixed
with `dev:`.

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

The short version of how it works is that you add annotations to a plain Dart
class.
[json_serializable](https://pub.dev/packages/json_serializable) use the
annotations to generate code for serialization/deserialization.

You can read more about it on the package page or
[here](https://docs.flutter.dev/data-and-backend/serialization/json#serializing-json-using-code-generation-libraries).

## Model classes

Add the following files.
*Note it won't compile immediately*

`lib/models/credential.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'credential.g.dart';

@JsonSerializable()
class Credential implements Equatable {
  final String name;
  final String username;
  final String password;

  const Credential({
    required this.name,
    required this.username,
    required this.password,
  });

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
  Map<String, dynamic> toJson() => _$CredentialToJson(this);

  @override
  List<Object?> get props => [name, username, password];

  @override
  bool? get stringify => true;
}
```

`lib/models/encrypted_vault.dart`

```dart
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'encrypted_vault.g.dart';

@JsonSerializable()
class EncryptedVault {
  @Base64Converter()
  final List<int> salt;
  @Base64Converter()
  final List<int> nonce;
  @Base64Converter()
  final List<int> mac;
  @Base64Converter()
  final List<int> cipherText;

  EncryptedVault({
    required this.salt,
    required this.nonce,
    required this.mac,
    required this.cipherText,
  });

  factory EncryptedVault.fromJson(Map<String, dynamic> json) =>
      _$EncryptedVaultFromJson(json);
  Map<String, dynamic> toJson() => _$EncryptedVaultToJson(this);
}

class Base64Converter implements JsonConverter<List<int>, String> {
  const Base64Converter();
  @override
  List<int> fromJson(String json) => base64Decode(json);

  @override
  String toJson(List<int> bytes) => base64Encode(bytes);
}
```

`lib/models/open_vault.dart`

```dart
import '../infrastructure/protection.dart';
import 'credential.dart';

class OpenVault {
  List<Credential> credentials;
  Key key;
  OpenVault({required this.credentials, required this.key});
}
```

## About the classes

A vault is basically just a list of credentials.

`Credentials` represents are credential for a service (username+password).
It has a name field, so you can tell what service the credentials are for.

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

Sealed classes are abstract classes that can not be extended outside their own
package.
See [sealed class modifier](https://dart.dev/language/class-modifiers#sealed).

It means that the only way to instantiate `Key` is through its `_Key` sub-class
which isn't accessible outside its own package.
The only public available part of `Key` is its `destroy()` method.

The cryptography package works with `SecretBox` class.
Add these extensions to the file, so you can easily convert between it and our
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

  Future<Key> getKey(EncryptedVault vault, String masterPassword) async {
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
`Protection.saneDefaults()` to instantiate it with some sensible defaults.
Being able to change the algorithms allows you to instantiate it with a dummy
implementation to speed up tests.