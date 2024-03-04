---
title: Working with JSON
layout: default
---

{% include dart_embed %}

# Manual serialization

## Decoding

In Dart we can deserialize JSON using
[jsonDecode](https://api.dart.dev/stable/3.3.0/dart-convert/jsonDecode.html)
function from the `dart:convert` library.

The function has a return type of `dynamic`, which means that Dart can't tell
what type it is before running the the application.

It is important to know how types a treated when working with JSON.
Here are some examples you can play around with:

```run-dartpad:run-true:width-100%:height-610px
import 'dart:convert';

final json = '''{
    "id": 35,
    "categories": ["Programming","Geeky"],
    "joke": "There are only 10 kinds of people in this world: those who know binary and those who don't.",
    "flags": {
        "explicit": false
    }
}''';

void main() {
  final data1 = jsonDecode(json);
  print(data1.toString());
  print("\nRuntime type: ${data1.runtimeType}");
  print("Can I use it as a Map? ${data1 is Map}");

  print("Can I use it as a Map<String, dynamic>? ${data1 is Map<String, dynamic>}");
  print("Can I use it as a Map<String, Object>? ${data1 is Map<String, Object>}");
  print("\n");
  
  final categories = data1['categories'];
  print('The field "categories": $categories');
  print('Runtime type: ${categories.runtimeType}');
  print('Is it a List<dynamic>? ${categories is List<dynamic>}');
  print('Is it a List<String>? ${categories is List<String>}');
  print('Is first element a String? ${categories[0] is String}');
}
```

---

## Encoding

For serialization to JSON we can use [jsonEncode](https://api.dart.dev/stable/3.3.0/dart-convert/jsonEncode.html).

It works fine for the following types:

- num, int, double
- bool
- String
- List
- Map

```run-dartpad:run-true:width-100%:height-350px
import 'dart:convert';

void main() {
    final data = {
        "id": 35,
        "categories": ["Programming","Geeky"],
        "joke": "There are only 10 kinds of people in this world: those who know binary and those who don't.",
        "flags": {
            "explicit": false
        }
    };
    final json = jsonEncode(data);
    print(json);
}
```

Notice how similar Dart literals are to JSON.

You can make the JSON more readable to humans with
`JsonEncoder.withIndent('\t').convert`.

```run-dartpad:run-true:width-100%:height-350px
import 'dart:convert';

void main() {
    final data = { "id": 35, "categories": ["Programming","Geeky"], "joke": "There are only 10 kinds of people in this world: those who know binary and those who don't.", "flags": { "explicit": false } };
    final json = JsonEncoder.withIndent('\t').convert(data);
    print(json);
}
```

## Data transfer objects

What if we want to work with classes?
We don't get classes back when deserializing.
And we can **not** serialize classes directly.

Attempting to do so, gives us a nasty error.

```run-dartpad:run-true:width-100%:height-500px
import 'dart:convert';

class JokeDto {
  int? id;
  List<String>? categories;
  String? setup;
  String? delivery;

  JokeDto({this.id, this.categories, this.setup, this.delivery});
}

void main() {
  final joke = JokeDto(
    id: 1,
    categories: ["Programming"],
    setup: ".NET developers are picky when it comes to food.",
    delivery: "They only like chicken NuGet.",
  );
  jsonEncode(joke);
}
```

Instead we need some methods to convert between `Map<String, dynamic>` and our
**DTO**.

It is common to put those conversion methods in the DTO class.

```run-dartpad:run-true:width-100%:height-800px
import 'dart:convert';

const json = '''{
    "id": 49,
    "categories": [
        "Programming"
    ],
    "setup": ".NET developers are picky when it comes to food.",
    "delivery": "They only like chicken NuGet."
}''';

class JokeDto {
  int? id;
  List<String>? categories;
  String? setup;
  String? delivery;

  JokeDto({this.id, this.categories, this.setup, this.delivery});

  JokeDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categories = json['categories']?.cast<String>();
    setup = json['setup'];
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categories'] = this.categories;
    data['setup'] = this.setup;
    data['delivery'] = this.delivery;
    return data;
  }
}

void main() {
  final dto = JokeDto.fromJson(jsonDecode(json));
  print(dto);
  
  print(jsonEncode(dto.toJson()));
}
```

Wondering why the methods are called `fromJson` and `toJson` when they work with `Map` type?
It is just a convention that people in the Dart community use.

The convention implies that `fromJson` is compatible with `jsonDecode` and
`toJson` with `jsonEncode`.

# Automatic serialization (using code generation libraries)

This is a subject for later.
Here are some emojies instead.

🧒 🍷 🚗 🛣️ 🚔 🎫

🧑 🚲 🌳 🌻 😎 🏫 

👷🏿‍♂️ 👈 🔥 🤖 🏗️

*(I haven't written this part yet)*