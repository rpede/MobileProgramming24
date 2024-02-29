---
title: Weather
description: Part 1
layout: default
---

# Setup

In this lesson we will be building on the [Building scrolling experiences in Flutter Workshop](https://old-dartpad-3ce3f.web.app/workshops.html?webserver=https%3A%2F%2Fdartpad-workshops-io2021.web.app%2Fgetting_started_with_slivers).

Create a new project.

```sh
flutter create weather --platforms=android,ios
```

Open `main.dart`.
And paste the end result from the workshop.

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

## Data from API

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
9. Create a `assets` folder in your project.
10. Download the JSON from API URL to `assets/daily_weather.json`.
11. Paste the JSON into the site [Json To
Dart](https://jsontodart.zariman.dev/), check **Use num** type
**WeeklyForecast** as class name and click "Generate".
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
You should drop that into your `lib/models.dart` file too.

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
class DataSource {
  Future<WeeklyForecast> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecast.fromJson(jsonDecode(json));
  }
}
```

It simply loads, decodes and converts JSON from asset to an instance of
WeeklyForecast.

## Modify UI to use the data

When we make HTTP requests in Flutter, we are always going to get a Future back
(like Promise in JS).
That is because it takes some time for our request to hit the server, for it to
generate a response, and for the response to be transferred over the internet.

Even when loading a bundled assets, it doesn't happen instantaneously.

The app needs to handle the Future somewhere.
I think a good place for that somewhere, is to introduce a new screen, that sits
between  `WeatherApp` and `WeeklyForecastList`.

That way we can let `WeeklyForecastList` just deal with how to show the
forecast.
Also it makes it easier for us to add new screens later that show some different
data.

Add following code to `lib/weekly_forecast_screen.dart`.

```dart
class WeeklyForecastScreen extends StatelessWidget {
  const WeeklyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DataSource().getWeeklyForecast(),
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

  SliverToBoxAdapter buildError(Object? error, BuildContext context) {
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

  SliverFillRemaining buildSpinner() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
```

**Important** we can't put our normal layout widgets inside slivers.
It doesn't work directly with the fancy scrolling.
We can get around the limitation by wrapping with it with a
[SliverToBoxAdapter](https://api.flutter.dev/flutter/widgets/SliverToBoxAdapter-class.html).
There is also a
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
  final WeeklyForecast weeklyForecast;

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

It gives some compile errors, see if you can fix those.

Here are some code for showing name of week days, that might come handy.1

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