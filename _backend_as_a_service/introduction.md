---
title: Introduction to BaaS
description: >-
    Backend for mobile apps without writing a backend
layout: default
---

# What is Backend as a Service

BaaS provides app (or frontend) developers with an easy way to get backend
functionality without having to build a full-blown backend from scratch.

A BaaS consists of a bunch of tightly integrated services that each solve part
of what you would need from a backend.
These services commonly include:

- Authentication and authorization
- Database management
- Blob storage
- Notification service
- Cloud functions

Although there are similarities between services from various BasS providers they
are not interoperable.
Each provider has their own SDK which gives you access to everything they offer
bundles up a single package.

# Choosing a provider

Google is behind Flutter.
They are also behind Firebase.
So naturally Firebase and Flutter very well integrated.
The problem with Firebase is that you need to sign-up with a credit card in
order to use cloud functions.

I've considered multiple alternatives.
Among those are:

- [AWS Amplify](https://aws.amazon.com/amplify/)
- [Supabase](https://supabase.com/)
- [Appwrite](https://appwrite.io/)
- [PocketBase](https://pocketbase.io/)
- [Serverpod](https://serverpod.dev/)

Severpod is not technically a BaaS, but a backend framework for Dart.

What I was looking for is:

- Mature enough for production use.
- Cloud hosted (managed)
- Doesn't require credit card
- Can do:
    - Authentication
    - Realtime database
    - Cloud functions

I found Supabase to be the most viable.

You can read how Supabase developers phrase the differences between it and
Firebase [here](https://supabase.com/alternatives/supabase-vs-firebase).

# Supabase

Supabase is open source and built around PostgreSQL.
You can access PostgreSQL directly if you desire.
In addition, it provides the following features:

- Auto-generated API for clients.
- Realtime changes.
- Authentication/Authorization with social media login and SSO (single sign-on).
- Edge functions (aka cloud or serverless functions) give you backend like
functionality without writing a full-blown backend or managing servers.
- Storage for hosting blobs like images, videos etc.

Given that Supabase is built on PostgreSQL, you might be tempted to want to
write SQL directly in your Flutter app.
Even though it is technically possible to establish a connection directly to
PostgreSQL from Flutter, this should be avoided.
Your frontend is not supposed to talk directly to the database.
Flutter apps should use the auto-generated API.

The auto-generated API simplifies writing queries for the database.
Consider the schema below:

![](../supabase_countries_schema.png)

You can fetch countries with a list of cities just by:

```dart
final data = await supabase.from('countries').select('id, name, cities(id, name)');
```

And you get a result like this:

```dart
[
  {
    "id": 1,
    "name": "United Kingdom",
    "cities": [
      { "id": 1, "name": "London" },
      { "id": 2 "name": "Manchester" }
    ]
  },
  {
    "id": 2,
    "name": "United States",
    "cities": [
      { "id": 3, "name": "Los Angeles" },
      { "id": 4 "name": "New York" }
    ]
  }
]
```