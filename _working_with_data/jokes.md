---
title: Jokes
layout: default
---
<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# Joke Teller

This will be a fun one (hopefully).
Today we are going to kill the boredom by writing an app that tells jokes.

First you need to create a new Flutter project.

```sh
flutter create make_me_laugh
```

You can use a different project name if you want.

## Fetch data

You could write a long list of jokes yourself for the app.
However that sounds like a lot of work for something supposed to be fun.

Instead, lets use jokes other people have written.
Luckily there is a nice free API we can use to fetch random jokes.

Head over to [jokeapi](https://jokeapi.dev/#try-it).

I suggest that you select *Programming* as the category.
It is also recommended that you select everything under **Select flags to
blacklist** as some of the jokes are really offensive otherwise.

![Recommended jokeapi settings](../jokeapi.png)

The URL should look something like this:

```
https://v2.jokeapi.dev/joke/Programming?blacklistFlags=nsfw,religious,political,racist,sexist,explicit
```

Feel free to hit the *Send Request* button a couple of times to see how the API
responds.

Remember the URL because you will need it later.

There are two types of jokes `single` and `twopart`.
You can tell which type you get from the `type` field in the response.

For the next step you need to merge a response of both types.
So you get something like:

```json
{
    "error": false,
    "category": "Programming",
    "type": "twopart",
    "setup": "Why do programmers confuse Halloween and Christmas?",
    "delivery": "Because Oct 31 = Dec 25",
    "joke": "Java is like Alzheimer's, it starts off slow, but eventually, your memory is gone.",
    "flags": {
        "nsfw": false,
        "religious": false,
        "political": false,
        "racist": false,
        "sexist": false,
        "explicit": false
    },
    "id": 11,
    "safe": true,
    "lang": "en"
}
```

It should have both `setup`, `delivery` and `joke` fields.

Copy the merged JSON.
Head over to [JSON to Dart](https://javiercbk.github.io/json_to_dart/) and paste
it in.
For the Dart class name field you type `JokeDto` and hit the *Generate Dart* button.

Copy all the generated Dart code and paste it into a new file named
`joke_dto.dart` inside your project.

It generated a DTO class for you, from the json, with convince methods to help
convert to and from JSON.

Now that you have a class for the data, you need some code to fetch it from the
API.
For that you need a package.

```sh
flutter pub add http
```

*There is a HTTP client build into Dart but the
[http package](https://pub.dev/packages/http) is a lot nicer to work with.*

You also need to add the [provider package](https://pub.dev/packages/provider).

```sh
flutter pub add provider
```

In `android/app/src/main/AndroidManifest.xml`, you need add a couple of lines:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- These two lines -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    ...
```

Adding permissions to AndroidManifest.xml is required to access the internet.

Add a new file called `data_source.dart` to your project with the following content:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'joke_dto.dart';

class DataSource {
  Future<JokeDto> getJoke() async {
    // Your URL from goes here...
    const url = "https://v2.jokeapi.dev/joke/Programming?blacklistFlags=nsfw,religious,political,racist,sexist,explicit";
    final response = await http.get(Uri.parse(url));
    final map = json.decode(response.body);
    return JokeDto.fromJson(map);
  }
}
```

## Make a UI

In `main.dart`, wrap `MaterialApp` with a provider for `DataSource`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DataSource(),
      child: MaterialApp(
        // ...
      ),
    );
  }
}
```

Now, replace `MyHomePage` with:

```dart
class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  JokeDto? joke;

  @override
  void initState() {
    _loadJoke();
    super.initState();
  }

  _loadJoke() async {
    setState(() {
      joke = null;
    });
    final newJoke = await context.read<DataSource>().getJoke();
    setState(() {
      joke = newJoke;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jokes")),
      body: Column(
        children: [
          if (joke == null) const CircularProgressIndicator(),
          if (joke?.joke != null) Text(joke!.joke!),
          if (joke?.setup != null) Text(joke!.setup!),
          if (joke?.delivery != null) Text(joke!.delivery!),
          TextButton(onPressed: _loadJoke, child: const Text("Show another")),
        ],
      ),
    );
  }
}
```

You should have a working app by now.
Try it out!

It looks really boring, doesn't it?
Spend some time to make it pretty, before you head to the challenges.

## Challenges

### Challenge 1 - Add some graphics

Without some graphics the app will still look a bit boring.
So lets fix it!

You are not required to follow the steps in this section.
You can get creative instead and do your own thing instead.

I though it would be cool if it looks like there were different characters
telling the jokes.

I've found a avatar library/service called [DiceBear with an HTTP
API](https://www.dicebear.com/how-to-use/http-api/).

Find a [avatar style](https://www.dicebear.com/styles/) you like.

You can get a new avatar for each joke with:

```dart
"https://api.dicebear.com/7.x/pixel-art/svg?seed=${joke.id}"
```

Where `joke.id` is the id field from the DTO.

Replace `pixel-art` with your preferred style.

SVG is nice format since it looks crisp no matter the size.
However Flutter out-of-the-box doesn't easily allow you to draw SVGs.
But that can easily be fixed just by adding another package.

```sh
flutter pub add flutter_svg
```

Now you can add an avatar to the UI with following widget:

```dart
SvgPicture.network("https://api.dicebear.com/7.x/adventurer/svg?seed=${joke?.id}")
```

Mine ended up looking like this:

![My version of the app](../my_app.jpg)

### Challenge 2 - Settings

Remember there where a lot of settings you could change on the [jokeapi website](https://jokeapi.dev/)?

Wouldn't it be cool if your users could change settings themselves?

For that you need a couple things.

1. an object to hold the settings
2. (optionally) persistent storage of the settings
3. another page to change the settings
4. change `DataSource` to use the settings

#### 1. Object to hold settings

You can solve the first by simple adding a `Settings` class for the settings you
want the user to be able to change.

You can make the `Settings` class accessible across your application with a
provider (just like DataSource).
I suggest using a
[MultiProvider](https://pub.dev/packages/provider#multiprovider) to cleanly
provider both `DataSource` and settings.

#### 2. Persistence

You can use the [localstorage package](https://pub.dev/packages/localstorage) to
easily persist simple data in your app.

One caveat is that whatever data you try to persist needs to be JSON
serializable.
Meaning you can only use types like: int, double, bool, String List & Map.
Also you will have to cast the value you get back to the appropriate type.