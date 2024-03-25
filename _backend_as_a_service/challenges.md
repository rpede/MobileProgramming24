---
title: Chat - Challenges
description: >-
    Expand the chat app
layout: default
---

# Profile

Add functionality so a user can update their profile.

You can find hints in [Build a User Management App with
Flutter](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
tutorial.

See also [Bonus: Profile photos](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?platform=web#bonus-profile-photos)

# Refactor

Some of the page widgets (RegisterPage & RoomsPage) are a bit long and contains
lot of nesting.

Use "Extract method" and "Extract Flutter Widget" to make code easier to read.

Currently the code is organized by technical concern.
All pages in one folder.
All models in another.
And so on.
It doesn't really scale when the app becomes the size of SnapChat.

Therefore, reorganize the project so organized by feature instead of layer.

[Read more](../quality/folder-structure)

# Presence

Indicate which users are currently online using the [Presence
feature](https://supabase.com/docs/guides/realtime/presence?language=dart) of
Supabase.

# And Now for Something Completely Different

Are you bored?
Do you want to play games on your phone instead?

I'll let you.
But there is a catch.
You'll have to make the game first.

[How to build a real-time multiplayer game with Flutter Flame](https://supabase.com/blog/flutter-real-time-multiplayer-game)