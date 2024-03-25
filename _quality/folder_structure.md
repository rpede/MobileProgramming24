---
title: Folder structure
description: >-
    Make a folder structure for your apps that scales
layout: default
---

{% include alert.html %}

As the project grows in size it can become more difficult to find the right file
for a change.
To combat this, we need a good folder structure for our code files.

In general there are two widely deployed approaches folder structure the code of
an application.

<div class="alert info">
These concepts will be explained in the context of Flutter.
However the ideas are by no means specific to Flutter applications.
The same ideas applies to all programming languages and frameworks I can think
of.
</div>

# Layer-first

Also referred to as organized by technical concern.

Though there can be variations it typically goes like this.
When you open up the lib folder you will see the following sub-folders.

- cubit (or logic)
- models
- screens (or pages)
- widgets (or components)

What's wrong with that?
It looks neatly organized, you might be thinking.

When you expand the folders you will see something like this.

- cubit
    - profile
        - profile_cubit.dart
        - profile_state.dart
    - shopping_cart
        - shopping_cubit.dart
        - shopping_state.dart
- models
    - profile.dart
    - shopping_cart_item.dart
    - shopping_dart.dart
- screens
    - edit_profile_screen.dart
    - shopping_cart_screen.dart
    - view_profile_screen.dart
- widgets
    - price.dart
    - user_avatar.dart

When you are working on the "shopping cart" feature.
You will need all the top-level folders expanded.
Because the files you will be working on are:

- shopping_cart_screen.dart
- shopping_cubit.dart
- shopping_state.dart
- shopping_dart.dart
- shopping_cart_item.dart
- price.dart

When you are working with "profile" feature you likewise need all the top-level
folders expanded.
But the files you will be working on are instead:

- edit_profile_screen.dart
- profile.dart
- profile_cubit.dart
- profile_state.dart
- user_avatar.dart
- view_profile_screen.dart

Now imagine that the app got many more features, like catalog, product,
authentication, payment etc.
With all the folders expanded you will be looking at more files than you have
vertical space on you screen.
Which means that you will constantly have to scroll around in the "Project
Files" view (or use search to find the files).

This approach works great for small projects, but doesn't really scale as the
project gets bigger.

# Feature-first

Also referred to as vertical slice.

Instead of organizing by layer or technical concern, what if you organized the
files by feature-first.
That will give you:

- profile
    - cubit
        - profile_cubit.dart
        - profile_state.dart
    - models
        - profile.dart
    - screens
        - edit_profile_screen.dart
        - view_profile_screen.dart
    - widgets
        - user_avatar.dart
- shopping_cart
    - cubit
        - shopping_cubit.dart
        - shopping_state.dart
    - models
        - shopping_cart_item.dart
        - shopping_dart.dart
    - screens
        - shopping_cart_screen.dart
    - widgets
        - price.dart

This approach will give you more folders in total, but fewer files in each.

Now when working on the "shopping cart" feature you can have the "shopping_cart"
folder expanded and even all sub-folders, while still being able to see all
files for that feature on the screen at the same time.

If I make the claim that files related to the same feature are more likely to be
changed together.
Then it should be obvious that this is the better approach.

There are two problems though.

1. What about files that are used in all (or most) features?
2. What about files that are equally belong to two separate features?

First is easy to solve.
Just place them in a top-level folder named "common" or "shared".
With a name like that, it is easy to tell that those files are used in many
different places.

Second is a lot harder.
The best answer I can give, is just to pick one.
Then come up with a justification you can tell to the other developers on your
project.
If you later on find that you are constantly looking for the file in the wrong
folder, it means that you made the wrong choice.
Do you move the file to a different folder and (perhaps) confuse the rest of the team, or do you suck it up and leave it where it is?

I think the second problem is why so many people just stick to the layer-first
approach.

# Conclusion

No matter which folder structure approach you use, it will always be faster just
to be good at using the search function in your IDE 😉.

I hope that you can see, that there still might be some value in the argument to
the argument I'm trying to make above.

Do you use a folder structure where you always know what folder a given file is in.
Or do you use a folder structure where you most of the time know what folder a
file is in.

Which approach do you think make it easiest for a new developer to understand
the codebase?

# Shortcuts

- **Recent files**
    - Windows: <kbd>Control</kbd>+<kbd>E</kbd>
    - macOS: <kbd>Command</kbd>+<kbd>E</kbd>
- **Navigate to Class**
    - Windows: <kbd>Control</kbd>+<kbd>N</kbd>
    - macOS: <kbd>Command</kbd>+<kbd>O</kbd>