---
title: Weather
description: Part 1
layout: default
---

{% include hint.html %}

![Screenshot](../weather_app_part1_screenshot.png)

# Setup

In this lesson we will be building on the [Building scrolling experiences in Flutter Workshop](https://old-dartpad-3ce3f.web.app/workshops.html?webserver=https%3A%2F%2Fdartpad-workshops-io2021.web.app%2Fgetting_started_with_slivers).

Create a new project.

```sh
flutter create weather --platforms=android,ios
```

Open `main.dart` and replace its content with the result from the workshop.

## Refactor

Place the text cursor on `SliverAppBar` and "Extract Flutter widget" and name it
**WeatherSliverAppBar**.

Rename `HorizonsApp` to **WeatherApp**.

Place each widget in a separate file.
You should end up with

File|Class|
-|-|-
`lib/weather_app`|WeatherApp
`lib/weather_sliver_app_bar.dart`|WeatherSliverAppBar
`lib/weekly_forecast_list.dart`|WeeklyForecastList

Now, take everything between the line and `ConstantScrollBehavior`, and place it in `lib/server.dart`.

Move `ConstantScrollBehavior` to `lib/weather_app`.

# Mock data from API

1. Go to [Open-Meteo - Wether Forecast API](https://open-meteo.com/en/docs).
2. Use the search field in the top to find your location.
3. Select **Europe/Berlin** as "Timezone".
4. Uncheck everything under "Hourly Weather Variables".
5. Check **Weather code**, **Maximum Temperature (2 m)** and **Minimum
Temperature (2 m)** under "Daily Weather Variables".
6. Select the units you like under "Settings".
7. You can preview the data under "API Response".
8. Copy the API URL from the field right below the preview.
    - It should look something like:
    - `https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=weather_code,temperature_2m_max,temperature_2m_min&wind_speed_unit=ms&timezone=Europe%2FBerlin`
    - Also save it for later
9. Create a `assets` folder in your project.
10. Download the JSON from API URL to `assets/daily_weather.json`.
11. Paste the JSON into the site [Json To
Dart](https://jsontodart.zariman.dev/), check **Use num** type
**WeeklyForecastDto** as class name and click "Generate".
12. Save the generated dart code to `lib/models.dart`.
13. Add your `assets/` folder to flutter->assets section in `pubspec.yaml`.

It should look something like this:

```yaml
flutter:
  assets:
    - assets/
```

*Weather Code* describes the weather conditions (sunny, rain, snow etc).
I wrote an enum that might help interpret the `int` value we get from API.
You should drop it into your `lib/models.dart` file too.

```dart
// 0 	Clear sky
// 1, 2, 3 	Mainly clear, partly cloudy, and overcast
// 45, 48 	Fog and depositing rime fog
// 51, 53, 55 	Drizzle: Light, moderate, and dense intensity
// 56, 57 	Freezing Drizzle: Light and dense intensity
// 61, 63, 65 	Rain: Slight, moderate and heavy intensity
// 66, 67 	Freezing Rain: Light and heavy intensity
// 71, 73, 75 	Snow fall: Slight, moderate, and heavy intensity
// 77 	Snow grains
// 80, 81, 82 	Rain showers: Slight, moderate, and violent
// 85, 86 	Snow showers slight and heavy
// 95 * 	Thunderstorm: Slight or moderate
// 96, 99 * 	Thunderstorm with slight and heavy hail
enum WeatherCode {
  clearSky(0, 'Clear sky'),

  mainlyClear(1, 'Mainly clear'),
  partlyCloudy(2, 'Partly cloudy'),
  overcast(3, 'Overcast'),

  fog(45, 'Fog'),
  depositingRimeFog(48, 'Depositing rime fog'),

  drizzleLight(51, 'Drizzle: Light intensity'),
  drizzleModerate(53, 'Drizzle: Moderate intensity'),
  drizzleDense(55, 'Drizzle: Dense intensity'),

  freezingDrizzleLight(56, 'Freezing Drizzle: Light intensity'),
  freezingDrizzleDense(57, 'Freezing Drizzle: dense intensity'),

  rainSlight(61, 'Rain: Slight intensity'),
  rainModerate(63, 'Rain: Moderate intensity'),
  rainHeavy(65, 'Rain: Heavy intensity'),

  freezingRainLight(66, 'Freezing Rain: Light intensity'),
  freezingRainHeavy(66, 'Freezing Rain: Heavy intensity'),

  snowFallSlight(71, 'Snow fall: Slight intensity'),
  snowFallModerate(73, 'Snow fall: Moderate intensity'),
  snowFallHeavy(75, 'Snow fall: Heavy intensity'),

  snowGrains(77, 'Snow grains'),

  rainShowersSlight(80, 'Rain showers: Slight'),
  rainShowersModerate(81, 'Rain showers: Moderate'),
  rainShowersVoilent(82, 'Rain showers: Violent'),

  snowShowersSlight(85, 'Snow showers: Slight'),
  snowShowersHeavy(86, 'Snow showers: Heavy'),

  thunerstorm(95, 'Thunderstorm: Slight or moderate'),
  thunderstormSlightHail(96, 'Thunderstorm with slight hail'),
  thunderstormHeavyHail(99, 'Thunderstorm with heavy hail'),
  ;

  final int value;
  final String description;
  const WeatherCode(this.value, this.description);

  factory WeatherCode.fromInt(int value) {
    return WeatherCode.values.singleWhere((code) => code.value == value);
  }
}
```

Add this to your `lib/data_source.dart`:

```dart
class FakeDataSource {
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
}
```

It simply loads, decodes and converts JSON from asset to an instance of
WeeklyForecastDto.

# Modify UI to use the new mock data

When we make HTTP requests in Flutter, we are always going to get a Future back
(like Promise in JS).
That is because, it takes some time for our request to hit the server, for it to
generate a response, and for the response to be transferred over the internet.

Even when loading a bundled assets, it doesn't happen instantaneously.

The app needs to handle the Future somewhere.
I think a good place for it, would be to introduce a new screen, that sits
between  `WeatherApp` and `WeeklyForecastList`.

That way we can let `WeeklyForecastList` just deal with how to show the
forecast.
Also it makes it easier for us to add new screens to show some different data
later on.

Add following code to `lib/weekly_forecast_screen.dart`.

```dart
class WeeklyForecastScreen extends StatelessWidget {
  const WeeklyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FakeDataSource().getWeeklyForecast(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              const WeatherSliverAppBar(),
              if (snapshot.hasData)
                WeeklyForecastList(weeklyForecast: snapshot.data!)
              else if (snapshot.hasError)
                buildError(snapshot, context)
              else
                buildSpinner()
            ],
          );
        },
      ),
    );
  }

  Widget buildError(Object? error, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          error.toString(),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget buildSpinner() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
```

**Important** we can't directly put our normal layout widgets inside slivers.
It doesn't work directly with the fancy scrolling.
We can get around the limitation by wrapping it with a
[SliverToBoxAdapter](https://api.flutter.dev/flutter/widgets/SliverToBoxAdapter-class.html).
Btw, there is also a
[SliverFillRemaining](https://api.flutter.dev/flutter/widgets/SliverFillRemaining-class.html)
which is like the Expanded widget but for slivers.


We need to change `WeatherApp` in `lib/main.dart` to use the new screen we
added.

```dart
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Horizons Weather',
      home: const WeeklyForecastScreen(),
    );
  }
}
```


In `lib/weekly_forecast_list.dart` replace the constructor with:

```dart
class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;

  const WeeklyForecastList({super.key, required this.weeklyForecast});

  // ...
}
```

Staying within `WeeklyForecastList`.
Remove the following from `SliverChildBuilderDelegate` in the build method:

```dart
final DailyForecast dailyForecast =
    Server.getDailyForecastByID(index);
```

It gives some compile errors, see if you can fix them.

Here are some code for showing name of week days, that might come handy.

```dart
String weekdayAsString(DateTime time) {
  return switch (time.weekday) {
    DateTime.monday => 'Monday',
    DateTime.tuesday => 'Tuesday',
    DateTime.wednesday => 'Wednesday',
    DateTime.thursday => 'Thursday',
    DateTime.friday => 'Friday',
    DateTime.saturday => 'Saturday',
    DateTime.sunday => 'Sunday',
    _ => ''
  };
}
```

<div class="hint">
  Hints
  <pre class="hinttext hint-top">
final daily = weeklyForecast.daily!;
final date = DateTime.parse(daily.time![index]);
final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
final tempMax = daily.temperature2MMax![index];
final tempMin = daily.temperature2MMin![index];
  </pre>
</div>

# Challenge

Modify the UI too look good on you phone.

Find images for different weather conditions.
Save the images to `assets/` folder.

Now, replace the image in `WeeklyForecastList` with a fitting image based on
`WeatherCode`.
You can do it by adding a new field to `WeatherCode` with the image name or
asset path.

You can adjust the JSON data to simulate different weather conditions.

Also change the image in the app bar and play around with the colors.

When done, you should be able to remove the `lib/server.dart` file containing
the old mock data from codelab.

# Use live data

## Dependency injection with providers

It would be nice, if we were able to quickly switch between mock and real data.
Therefore, we need to dependency injection!

A popular option that allows accessing dependencies in the widgets that need
them is with the [provider package](https://pub.dev/packages/provider).

Open a terminal and type:

```sh
flutter pub add provider
```

Change `lib/data_source.dart` to:

```dart
abstract class DataSource {
  Future<WeeklyForecastDto> getWeeklyForecast();
}

class FakeDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
}
```

Remember, in Dart we use abstract classes instead of interfaces.

In `lib/main.dart` you need to have:

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<DataSource>(create: (context) => FakeDataSource()),
      ],
      child: const WeatherApp(),
    ),
  );
}
```

Actually, you do with just the following in `runApp`:

```dart
Provider<DataSource>(
  create: (context) => FakeDataSource(),
  child: const WeatherApp(),
)
```

However using a `MultiProvider` from the get-go makes it easier to add
additional DI providers in the future.

You can think of:

```dart
Provider<DataSource>(create: (context) => FakeDataSource()),
```

As Flutters version of this in .NET:

```csharp
builder.Services.AddSingleton<IDataSource, FakeDataSource>();
```

Anyway.
We also need to change `WeeklyForecastScreen` to use `DataSource` from the
provider.

Simply replace

```dart
FakeDataSource().getWeeklyForecast(),
```

with

```dart
context.read<DataSource>().getWeeklyForecast()
```

If you look at the definition of `read`, it basically does
`Provider.of<DataSource>(context, listen: false)`.
The `Something.of(context)` pattern should start to look familiar by now.
It is the same we do with `Theme` and `Navigator`.

So what happens, is that the `read` method is reaching up the widget tree for a
`Provider<DataSource>` from which we get a `DataSource`.
We configured `Provider<DataCourse>` to provide the concrete type `FakeDataSource`.
We could have many screens/pages in the app accessing the same `DataSource` this way.

Never mind the `listen: false` part.
That's a story for day.

## Calling the real API

Lets create another data-source.

1. Add the [http](https://pub.dev/packages/http) package.
2. Grab the API URL you had from the beginning.
3. Create a class called `RealDataSource` that extends `DataSource`.
4. Implement `getWeeklyForecast()` such that it returns data from a GET request
to API URL.

Refer to [Jokes pages](jokes) for an example on how to use the http package.

Now you can switch between the real and fake data source with a small change in
`lib/main.dart`.

## Refresh data

It would be nice if there were a way to refresh the data without closing and
reopening the app.

The app bar has a `onStretchTrigger` that fires when you pull down from the top
of the screen.
This is perfect for what we need.
There is just one problem.
It lives in a different class than where we call the data source.

To solve the problem, add an instance variable `final AsyncCallback? onRefresh`
in `WeatherSliverAppBar`.
Add it as a parameter in the constructor.
Assign `onRefresh` to `onStretchTrigger` in the build method.

Btw.
AsyncCallback is defined as:

```dart
typedef AsyncCallback = Future<void> Function();
```

So `AsyncCallback` is just an alias for `Future<void> Function()`.

Back on track.
Now we need to fetch need data when `onRefresh` is called.

To do that, convert `WeeklyForecastScreen` to a **StatefulWidget**.

In `_WeeklyForecastScreenState` add an instance variable:

```dart
final controller = StreamController<WeeklyForecastDto>();

@override
void initState() {
  super.initState();
  loadForecast();
}

Future<void> loadForecast() async {
  final future = context.read<DataSource>().getWeeklyForecast();
  controller.addStream(future.asStream());
  await future;
}
```

**Important** when overriding `initState`, the method must start with
`super.initState()`.
Also you can **not** use `await` inside it.


[StreamController](https://api.flutter.dev/flutter/dart-async/StreamController-class.html)
is a cool class.
Picture a pipe.
One person can add things at one end.
While another person retrieves them in another.
We call the end where things get added a *sink*.
And where it comes out the *stream*.

{% include_relative pipe.drawio.svg %}

Person at *stream* and might not be able to see then things are added to the
*sink*.
But can listen for when something is going to flow through.

Consider:

```dart
controller.addStream(future.asStream());
```

Here we convert the future to a stream, adding it to the sink of our controller.
It means that when the future resolves to a value then it will flow through the
pipe.
If the future fails, then an error will flow through instead.

The
[StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
can be used to listen to a stream from within the widget tree.

Replace the `FutureBuilder` in build method with a `StreamBuild`.
So instead of:

```dart
FutureBuilder(
  future: context.read<DataSource>().getWeeklyForecast(),
  builder: (context, snapshot) {
    // ...
  },
)
```

We go:

```dart
StreamBuilder(
  stream: controller.stream,
  builder: (context, snapshot) {
    // ...
  },
)
```

Also, pass `loadForecast` to `WeatherSliverAppBar`.

```dart
WeatherSliverAppBar(onRefresh: loadForecast),
```

You can now refresh by pulling down within the app.
