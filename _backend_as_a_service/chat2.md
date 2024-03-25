---
title: Chat - Part 2
description: >-
    Expand chat app with rooms and authorization using Row Level Security
layout: default
---

Supabase got another tutorial for this.

Before you start you should the Table Editor in Supabase dashboard and delete any rows
in the `messages` table.
Otherwise you will get: `ERROR:  23502: column "room_id" of relation "messages" contains null values`.

Follow the [Flutter Authorization with
RLS](https://supabase.com/blog/flutter-authorization-with-rls) tutorial.

But change the dependencies for current version.

# Install additional dependencies

```yml
    flutter_bloc: ^8.1.5
```

# Setup deep links

Here are the paths for setting up deep links.

- **iOS** `ios/Runner/Info.plist`
- **Android** `android/app/src/main/AndroidManifest.xml`

Deep links are a way to link to app content.
The platform (iOS/Android) needs to know that a link resolves to our app.
This way we configure it is inherently platform specific.

# Missing code

[Complete set of code of this chat app](https://github.com/supabase-community/flutter-chat/tree/with_auth)

There are a couple of code snippets missing from the tutorial.

`lib/components/user_avatar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/cubits/profiles/profiles_cubit.dart';
import 'package:my_chat_app/utils/constants.dart';

/// Widget that will display a user's avatar
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        if (state is ProfilesLoaded) {
          final user = state.profiles[userId];
          return CircleAvatar(
            child:
                user == null ? preloader : Text(user.username.substring(0, 2)),
          );
        } else {
          return const CircleAvatar(child: preloader);
        }
      },
    );
  }
}
```

Add `spacer` to `lib/utils/constants.dart`:

```dart
/// Simple sized box to space out form elements
const spacer = SizedBox(width: 16, height: 16);
```

In `lib/pages/splash_page.dart` replace:

```dart
final session = await SupabaseAuth.instance.initialSession;
```

With:

```dart
final session = supabase.auth.currentSession;
```

Replace `lib/models/message.dart` with
[this](https://github.com/supabase-community/flutter-chat/blob/with_auth/lib/models/message.dart).