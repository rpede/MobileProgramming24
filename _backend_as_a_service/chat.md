---
title: Chat
description: >-
    A simple chat app with Supabase as backend
layout: default
---

# Follow tutorial

Start by following [Flutter Tutorial: building a Flutter chat
app](https://supabase.com/blog/flutter-tutorial-building-a-chat-app).

But change the dependencies for current version.

```yml
  supabase_flutter: ^2.3.4
  timeago: ^3.6.1
```

# Database trigger

During the tutorial you probably wondered what is this:

```sql
-- Function to create a new row in profiles table upon signup
-- Also copies the username value from metadata
create or replace function handle_new_user() returns trigger as $$
    begin
        insert into public.profiles(id, username)
        values(new.id, new.raw_user_meta_data->>'username');

        return new;
    end;
$$ language plpgsql security definer;

-- Trigger to call `handle_new_user` when new user signs up
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function handle_new_user();
```

The first part is a function.
You can write your own custom database functions in PostgreSQL.
You can actually write those functions in a bunch of different programming languages.
Here the language is `plpgsql` which you can think of as an extended SQL.

The second part is a trigger.
Triggers are a way to get the database to execute some code when a change
happens on a table.
Here the change it should execute code for is `after insert on auth.users` and
the code to execute is the function defined in part 1.

We are getting into advanced database territory here.
But if you are still curious to learn more, you can go watch these two excellent
videos on the topic by the Supabase team.

- [Create PostgreSQL Functions with Supabase](https://www.youtube.com/watch?v=MJZCCpCYEqk)
- [Using PostgreSQL triggers to automate processes with Supabase](https://www.youtube.com/watch?v=0N6M5BBe9AE)

# Logout

Open `lib/pages/splash_page.dart` and add a route method just like on the other pages.

```dart
static Route<void> route() {
  return MaterialPageRoute(builder: (context) => const SplashPage());
}
```

Change the `appBar` in `lib/pages/chat_page.dart` to:

```dart
appBar: AppBar(
  title: const Text('Chat'),
  actions: [
    IconButton(
      onPressed: () async {
        await supabase.auth.signOut();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(SplashPage.route());
      },
      icon: const Icon(Icons.logout),
    )
  ],
),
```

Without the `if (!mounted) return;` part you will get the following warning:

```
Don't use 'BuildContext's across async gaps.

Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check.
```

What it means is that whenever you use await on a Future within a callback,
something elsewhere in you app could have caused the widget to be removed, in
which case the `context` would no longer be valid.
This scenario doesn't occur often in practice.
But when it does the user will experience a random crash.

Therefor when using `context` after awaiting on a future, you should always
check if the element is still part of the widget tree.
This is done by checking the value of `mounted`.