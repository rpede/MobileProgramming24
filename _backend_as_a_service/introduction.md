---
title: Introduction to BaaS
description: >-
    Backend for mobile apps without writing a backend
layout: default
---

# What is Backend as a Service

BaaS provides app (or frontend) developers with a easy way to get backend
functionality without having to build a full-blown backend from scratch.

A BaaS consists of a bunch of tightly integrated services that each solve part
of what you would need from a backend.
These services commonly include:

- Authentication and authorization
- Database management
- Blob storage
- Notification service
- Cloud functions

Though there are similarities between services from various BasS providers they
are not interoperable.
Each provider got their own SDK which gives you access to everything they offer
from a single package.

# Choosing a provider

Google is behind Flutter.
They are also behind Firebase.
So naturally they go Firebase and Flutter very well integrated.
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
    - Notifications

I found Supabase to be the most viable.