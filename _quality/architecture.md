---
title: Architecture
description: >-
    A small study of architecture for apps
layout: default
---

# App we build

Let's start by examining the architecture the apps we build so far.

## Photos

[Link](../interactivity/photos)

It got a presentation layer.
That's it.
The app is all widgets.

{% include_relative architecture_photos.drawio.svg %}

## Jokes

[Link](../working-with-data/jokes)

We have a presentation layer with `MyApp` and `JokePage`.
That is our presentation layer.

Then we have a data layer.
Consisting of `DataSource` and `JokeDto`.

{% include_relative architecture_jokes.drawio.svg %}

## Weather app

[Link](../working-with-data/weather1)

It follows a similar architecture, but slightly more complex.

{% include_relative architecture_jokes.drawio.svg %}

There a a lot more classes so I'm not going to name them all.

## Password manager

[Link](../advanced-state/password-manager)

Where the two previous apps where basically just consuming data from a web API.
The password manager app is a bit different.

Its all local.
Not talking to any web API.

Its goal is to manage credentials and store them in a protected way.

{% include_relative architecture_password_manager.drawio.svg %}

It got a different architecture because what is does is a lot different.
If there were one size fits all architecture we wouldn't be talking about it.
