---
title: Supabase Setup
description: >-
    The Supabase setup for a simple chat app
layout: default
---

We are going to create a chat app using Supabase as a backend.

# Project setup

## Create a Flutter project

Create a new project.
You can adjust the platforms as usual.

```sh
flutter create chat_supabase --platforms=linux,web,android
cd chat_supabase
flutter pub add supabase_flutter
```

If you want Android support you need to open `android/app/src/main/AndroidManifest.xml` and add internet permission:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <!-- Required to fetch data from the internet. -->
  <uses-permission android:name="android.permission.INTERNET" />
  <!-- ... -->
</manifest>
```

## Setup a Supabase account

Go to [supabase.com - sign-up](https://supabase.com/dashboard/sign-up) and created an account.

![](../supabase_signup.png)

Create an organization with free plan.

![](../supabase_create_organization.png)

And create a project in nearby region.

**Important: Save the password!**

![](../supabase_create_project.png)

## Connect Flutter and Supabase

When your Supabase project is finished creating, scroll down to the "Connecting
to your new project" section.

![](../supabase_connect_to_project.png)

Copy the Project URL and API Key.

Open op `lib/main.dart` and replace with the following:

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child:  Text("Hello World")),
      ),
    );
  }
}
```

Normally you would store API-keys in environment variables on your backend.
But the API Key here is what your app needs to talk to your
backend(-as-a-service).
You can restrict what can be done with the API Key by enabling Row Level
Security (RLS) for your tables and configure policies.
More on that later.

You can run app now to verify that everything works so far.

## Create a database schema

Navigate to the SQL Editor.
Paste [this schema](../supabase_profile.sql) and click the green "Run" button.

![](../supabase_sql_editor.png)

# Setup deep links

The authentication method we will use requires setting up deep links in order to
bring the user back into the app after they have logged in.

First, add `io.supabase.flutterquickstart://login-callback/` as a new [redirect
URL](https://supabase.com/dashboard/project/_/auth/url-configuration) in the
Dashboard.

![](../supabase_deep_links.png)

Deep links are a way to link to app content.
The platform (iOS/Android) needs to know that a link resolves to our app.
This way we configure it is inherently platform specific.

## iOS

Edit the `ios/Runner/Info.plist` file and add CFBundleURLTypes as shown.

```xml
<!-- ... other tags -->
<plist>
<dict>
  <!-- ... other tags -->

  <!-- Add this array for Deep Links -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>io.supabase.flutterquickstart</string>
      </array>
    </dict>
  </array>
  <!-- ... other tags -->
</dict>
</plist>
```

## Android

Edit the `android/app/src/main/AndroidManifest.xml` file and add an
intent-filter as shown.

```xml
<manifest ...>
  <!-- ... other tags -->
  <application ...>
    <activity ...>
      <!-- ... other tags -->

      <!-- Add this intent-filter for Deep Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
        <data
          android:scheme="io.supabase.flutterquickstart"
          android:host="login-callback" />
      </intent-filter>

    </activity>
  </application>
</manifest>
```

# Build a User Management

Continue from the "Set up splash screen" section of the Build a "User Management App with Flutter" tutorial on Supabase site.
(Link below)

Notice that some settings are platform specific.
Follow the steps in the tab for the platforms your project supports.

Replace the `supabase_quickstart` in all imports with `chat_supabase` or what
you named the project.

Completing the "Bonus: Profile photos" part is optional.

**[Link to tutorial](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?database-method=sql&platform=ios#set-up-splash-screen)**

Most of it is explained in the video below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/r7ysVtZ5Row?si=EEhlwteM75JdFa9Y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>