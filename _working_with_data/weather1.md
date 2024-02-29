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

File|Name|Type
-|-|-
`lib/weather_app`|WeatherApp|StatefulWidget
`lib/weather_sliver_app_bar.dart`|WeatherSliverAppBar|StatelessWidget
`lib/weekly_forecast_list.dart`|WeeklyForecastList|StatelessWidget

Now, take everything between the line and `ConstantScrollBehavior`, and place it in `lib/data_source.dart`.

Move `ConstantScrollBehavior` to `lib/weather_app`.