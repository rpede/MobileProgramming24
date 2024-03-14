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
flutter pub add json_annotation dev:build_runner dev:json_serializable equatable logging shared_preferences cryptography cryptography_flutter flutter_bloc fast_immutable_collections 
```

TODO table describing packages.

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