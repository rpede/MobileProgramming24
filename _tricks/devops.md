---
title: DevOps
description: CI/CD for Flutter
layout: default
---

# Commands

There are a bunch of flutter commands that are useful for creating pipelines.
Here is a quick overview.

| Command | Description |
|-|-|
| `flutter doctor` | Shows diagnostics. |
| `flutter pub get` | Install dependencies from `pubspec.yaml` |
| `flutter test` | Run unit and widget tests. |
| `flutter build apk` | Build installable package for Android. |
| `flutter build web` | Build project to static HTML and JavaScript. |

# Testing

See [Testing Flutter apps](https://docs.flutter.dev/testing/overview) for an
overview of the different kinds of testing.

## Running specific tests

Just running `flutter test` will execute tests in the `test` folder.
You can append a path to only run specific tests.
Example:

```sh
flutter test test/widget_test.dart
```

## Coverage

You can get a code coverage report for the tests with:

```sh
flutter test --coverage
```

It will generate a coverage report in
[lcov](https://github.com/linux-test-project/lcov) format.
You will find the output at `coverage/lcov.info`.
It looks like this:

```
SF:lib/main.dart
DA:1,1
DA:2,1
LF:2
LH:2
end_of_record
```

Not very human friendly.
You can turn it into HTML with:

```sh
genhtml ./coverage/lcov.info -o ./coverage/html
```

You will find the index at `coverage/html/index.html` and it looks like this:

![](../lcov_html.png)

The `genhtml` command is part of the aforementioned lcov package.
So it needs to be available.
How you do that, depends on the OS.

**Windows**

In git-bash:

```sh
cd ~
wget https://github.com/jgonzalezdr/lcov/releases/download/v1.15.alpha1w/lcov-1.15.alpha1w.zip
unzip lcov-1.15.alpha1w.zip
```

Then you can do:

```sh
~/lcov/genhtml ./coverage/lcov.info -o ./coverage/html
```

**macOS**

```sh
brew install lcov
```

Assuming you have [Homebrew](https://brew.sh/) installed.

**Debian/Ubuntu**

```sh
apt install lcov
```

## Integration test

Integration test in the Flutter world, means that you run tests on a real (or
emulated) device.

What you need to do, depends a bit on the platform.

### Web

Before executing tests you need ChromeDriver downloaded and running.
See
[here](https://docs.flutter.dev/cookbook/testing/integration/introduction#5b-web).

### Mobile

I don't have a good solution here.

You could try [Firebase Test Lab](https://firebase.google.com/docs/test-lab/flutter/integration-testing-with-flutter).
But, free quota is pretty low.

See [pricing for Test Lab](https://firebase.google.com/docs/test-lab/usage-quotas-pricing).

# Build/Release

## Web

Just run `flutter build web` then upload files in `build/web` to a static web
host.

You can find instructions on deployment to Firebase hosting [here](https://rpede.github.io/MobileProgramming24/tricks/web).

You can get a token, that can be used to deploy from CI/CD with:

```sh
firebase login:ci
```

Configure the token as an environment variable named `FIREBASE_TOKEN` in your CI/CD pipeline.
Then deploy from your pipeline with:

```sh
firebase deploy --token "$FIREBASE_TOKEN"
```

Links:

- [Build and release a web app](https://docs.flutter.dev/deployment/web)
- [Continuous delivery with Flutter](https://docs.flutter.dev/deployment/cd)

## iOS

It's complicated

## Android

Android uses a package format called APK.
You can simply bundle your app to an APK then copy it to a Android device and
install it.

```sh
flutter build apk
```

Then upload `build/app/outputs/flutter-apk/app-release.apk` to somewhere.

You can make the bundle size smaller by building individual APKs per hardware
platform.

```sh
flutter build apk --split-per-abi
```

Here is the size difference for a basic app.

![](../apk_split_per_abi.png)

*Note: most newer phones are running 64 bit ARM, so they will use the
`app-arm64-v8a-release.apk`.*

APKs needs to be digitally signed before they can be put on Play Store.
I think that is out of scope.

# Monitoring

Monitoring is important to detect defects early, optimize performance and gain
insight for improving user experience.

Google got two great services under the Firebase umbrella.
Check out the links:

- [Get started with Google Analytics](https://firebase.google.com/docs/analytics/get-started?platform=flutter)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics/)


# Drone CI

Here is a minimal pipeline that test and build a Flutter project.

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: test
  image: instrumentisto/flutter:3.19
  commands:
  - flutter doctor
  - flutter pub get
  - flutter test
- name: build
  image: instrumentisto/flutter:3.19
  commands:
  - flutter pub get
  - flutter build apk
```

I couldn't find an official Flutter image.
However,
[instrumentisto/flutter](https://hub.docker.com/r/instrumentisto/flutter) seems
like an okay option.
It is based on Ubuntu 22.04, got Android SDK and latest version of Flutter build
in.
Not the most minimal image though.

