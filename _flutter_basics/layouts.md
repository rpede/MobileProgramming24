---
title: Layouts
description: >-
  This is an introduction to layouts in Flutter.
layout: default
---

<script type="text/javascript" src="https://dartpad.dev/inject_embed.dart.js" defer></script>

# What are layout widgets

Some widgets in Flutter don't show anything on the screen on their own.
They are there to control the layout of other widgets.

You have seen a couple of these already like `Center` and `Column`.
However, there are many more.

Layout widgets can be divided into two categories, those that have just a single
child widget, and those that have multiple.

This exercise will show some of the layout widgets that are most commonly used.
You can find a full list of layout widgets [here](https://docs.flutter.dev/ui/widgets/layout).

## Single child layout widgets

### Center

You have already seen the
[Center](https://api.flutter.dev/flutter/widgets/Center-class.html) widget.
It simply puts its child in the center of the available space.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hello World"),
        ),
      ),
    ),
  );
}
```

### Container

The [Container](https://api.flutter.dev/flutter/widgets/Container-class.html)
widget wraps just a single child.
It provides a number of ways to alter the appearance of the child.
Including margin, padding, decoration, color, shape and size.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/c1xLMaTUWCY?si=0Zujj3ITjVgaZJOD"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

Here is an example you can play around with:

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-800px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(10),
          width: 150,
          height: 75,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue,
                Colors.lightGreen,
              ],
              begin: Alignment(0, 0),
              end: Alignment(0.5, 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(5, 5),
              )
            ],
          ),
          child: const Text("Hello World"),
        ),
      ),
    ),
  );
}
```

You can also set the alignment of the child:

```dart
Container(
    alignment: Alignment.bottomCenter,
    child: const Text("Hello World"),
)
```

But then height and width will be ignored.

That was a lot of stuff.
But don't worry, you don't have to memorize it all.
Your IDE will be able to guide you.
You just need to remember that if you need something that you can style, like a
`<div></div>` in HTML, then a `Container` is likely what you are looking for.

### SizedBox

Often you need to just be able to set the size of something.
For that a [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html)
is probably a better fit.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/EHPu_DzRfqA?si=w9r24QkuTtLKWlfR"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 75,
          width: double.infinity,
          child: Container(color: Colors.teal),
        ),
      ),
    ),
  );
}
```

### ConstrainedBox

Maybe you want to set a minimum or maximum size instead.
For that there is [ConstrainedBox](https://api.flutter.dev/flutter/widgets/ConstrainedBox-class.html).

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/o2KveVr7adg?si=SOcvP5TSNke_K8a8"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-400px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.amber, Colors.pink])),
          ),
        ),
      ),
    ),
  );
}
```

Note: Drag the border between code and rendered app to change its size.

## Multi child layout widgets

The following widgets takes a list of children.

### Row and Column

[Row](https://api.flutter.dev/flutter/widgets/Row-class.html) and
[Column](https://api.flutter.dev/flutter/widgets/Column-class.html) you will be
using a lot as building blocks for your layouts.
The difference between them is what axis it uses to layout its children.

{% include_relative row_column.drawio.svg %}

`Row` will layout its children horizontally.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Container(width: 50, height: 50, color: Colors.amber),
            Container(width: 50, height: 50, color: Colors.blue),
            Container(width: 50, height: 50, color: Colors.brown),
            Container(width: 50, height: 50, color: Colors.cyan),
          ],
        ),
      ),
    ),
  );
}
```

And `Column` will layout vertically.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(width: 50, height: 50, color: Colors.amber),
            Container(width: 50, height: 50, color: Colors.blue),
            Container(width: 50, height: 50, color: Colors.brown),
            Container(width: 50, height: 50, color: Colors.cyan),
          ],
        ),
      ),
    ),
  );
}
```

`Row` and `Column` are often combined to create more intricate layouts.
They also both have a `mainAxisAlignment` parameter to control the spacing of its children.
The different possibilities are shown below:

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-800px:split-40
import 'package:flutter/material.dart';

void main() {
  final boxes = [
    Container(width: 50, height: 50, color: Colors.amber),
    Container(width: 50, height: 50, color: Colors.blue),
    Container(width: 50, height: 50, color: Colors.brown),
    Container(width: 50, height: 50, color: Colors.cyan),
  ];
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Text("MainAxisAlignment.start"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: boxes,
            ),
            const SizedBox(height: 50),
            const Text("MainAxisAlignment.end"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: boxes,
            ),
            const SizedBox(height: 50),
            const Text("MainAxisAlignment.center"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: boxes,
            ),
            const SizedBox(height: 50),
            const Text("MainAxisAlignment.spaceAround"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: boxes,
            ),
            const SizedBox(height: 50),
            const Text("MainAxisAlignment.spaceBetween"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: boxes,
            ),
            const SizedBox(height: 50),
            const Text("MainAxisAlignment.spaceEvenly"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: boxes,
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Wrap

Sometimes you might want more children in a `Row` or `Column` than what fits on the screen.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Container(width: 50, height: 50, color: Colors.amber),
            Container(width: 50, height: 50, color: Colors.blue),
            Container(width: 50, height: 50, color: Colors.brown),
            Container(width: 50, height: 50, color: Colors.cyan),
            Container(width: 50, height: 50, color: Colors.green),
            Container(width: 50, height: 50, color: Colors.indigo),
            Container(width: 50, height: 50, color: Colors.lime),
          ],
        ),
      ),
    ),
  );
}
```

In which case you will see diagonal stripes alternating between yellow and black.
Like this:

![Overflow warning](../overflow.png)

That is something you should try to avoid.

One solution is to use the
[Wrap](https://api.flutter.dev/flutter/widgets/Wrap-class.html) widget.
It will arrange its children like `Row` or `Column`, but when it runs out of
space it will wrap to a new line.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/z5iw2SeFx2M?si=eUm_GPY42Xf2FY6k"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

Let's try the example above again, but with a `Wrap` instead of a `Row`.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Wrap(
          children: [
            Container(width: 50, height: 50, color: Colors.amber),
            Container(width: 50, height: 50, color: Colors.blue),
            Container(width: 50, height: 50, color: Colors.brown),
            Container(width: 50, height: 50, color: Colors.cyan),
            Container(width: 50, height: 50, color: Colors.green),
            Container(width: 50, height: 50, color: Colors.indigo),
            Container(width: 50, height: 50, color: Colors.lime),
          ],
        ),
      ),
    ),
  );
}
```

Drag the border between code and layout and observe how the arrangement changes.

### Table

The [Table](https://api.flutter.dev/flutter/widgets/Table-class.html) widget is
sometimes a better option than combining multiple Row and Column widgets.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/_lbE0wsVZSw?si=B_qrqJOWOOticMUi"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.grey),
              children: [
                const SizedBox(height: 64),
                Container(height: 64, color: Colors.green),
                Container(height: 32, color: Colors.yellow),
              ],
            ),
            TableRow(
              decoration: const BoxDecoration(color: Colors.grey),
              children: [
                const SizedBox(height: 64),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(height: 32, width: 32, color: Colors.red),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Container(height: 32, color: Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```

A `Table` can have a default alignment for its children, which can be overridden
by wrapping the child in a
[TableCell](https://api.flutter.dev/flutter/widgets/TableCell-class.html).


### ListView

The [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html)
widget is used to create scrollable lists.

<iframe width="560" height="315"
    src="https://www.youtube-nocookie.com/embed/KJpkjHGiI5A?si=BWFtG76KgyEP7M3_"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen></iframe>

A [ListTile](https://api.flutter.dev/flutter/material/ListTile-class.html) is
often for the children `ListView`, since it provides an easy way to layout the 
content.
However, the children can be any widget as long as their size is constrained in
the scroll direction.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          children: const [
            ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Headline'),
              subtitle: Text('Supporting text'),
              trailing: Icon(Icons.favorite_rounded),
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Text('B')),
              title: Text('Headline'),
              subtitle: Text(
                  'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
              trailing: Icon(Icons.favorite_rounded),
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Text('C')),
              title: Text('Headline'),
              subtitle: Text(
                  "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
              trailing: Icon(Icons.favorite_rounded),
              isThreeLine: true,
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Text('D')),
              title: Text('Headline'),
              subtitle: Text('Another tile to demonstrate scrolling.'),
              trailing: Icon(Icons.favorite_rounded),
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Text('E')),
              title: Text('Headline'),
              subtitle: Text('Yet another tile to demonstrate scrolling.'),
              trailing: Icon(Icons.favorite_rounded),
            ),
            Divider(height: 0),
          ],
        ),
      ),
    ),
  );
}
```

Sometimes the items you want to display in a ListView need to be generated or
fetched.
In such situations you would use an `itemBuilder` function to build the items.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-70
import 'package:flutter/material.dart';

final List<int> colorCodes = [800, 600, 300, 100];

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) => Container(
            height: 50,
            color: Colors.blue[colorCodes[index % colorCodes.length]],
            child: Center(child: Text('Entry $index')),
          ),
        ),
      ),
    ),
  );
}
```

### GridView

If want a scrollable grid then
[GridView](https://api.flutter.dev/flutter/widgets/GridView-class.html) is the
widget to use.

Among other things, it is a perfect fit for creating a gallery or product catalog.

<iframe width="560" height="315"
  src="https://www.youtube-nocookie.com/embed/bLOtZDTm4H8?si=ZAjBlTsh7kNH5kvt"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowfullscreen></iframe>

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(20, (i) =>
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.lightBlue[100],
              child: FlutterLogo(style: FlutterLogoStyle.values[i % FlutterLogoStyle.values.length]),
            ),
          )
        ),
      ),
    ),
  );
}
```

The spacing between tiles can be controlled with `mainAxisSpacing` and
`crossAxisSpacing`.
The number of tiles displayed across is controlled with `crossAxisCount`.

You can use the
[GridTile](https://api.flutter.dev/flutter/material/GridTile-class.html) widget
in children list to quickly add some flair.

```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-460px:split-60
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
          children: [
            GridTile(
              header: const GridTileBar(
                title: Text("T-Shirt"),
                subtitle: Text("Basic shirt made of cotton"),
              ),
              footer: const GridTileBar(
                leading: Text("19.99\$"),
              ),
              child: Container(
                color: Colors.lightBlue,
                child: const Placeholder(),
              ),
            ),
            GridTile(
              header: const GridTileBar(
                title: Text("Premium t-Shirt"),
                subtitle: Text("Luxury shirt made of silk"),
              ),
              footer: const GridTileBar(
                leading: Text("300.00\$"),
              ),
              child: Container(
                color: Colors.lightBlue,
                child: const Placeholder(),
              ),
            ),
            GridTile(
              header: const GridTileBar(
                title: Text("Jeans"),
                subtitle: Text("Quality slim fit jeans"),
              ),
              footer: const GridTileBar(
                leading: Text("39.99\$"),
              ),
              child: Container(
                color: Colors.lightBlue,
                child: const Placeholder(),
              ),
            ),
          ]
        ),
      ),
    ),
  );
}
```