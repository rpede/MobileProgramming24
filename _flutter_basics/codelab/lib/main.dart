import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    CupertinoApp(
      title: 'Flutter Demo',
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text("Flutter Cupertino Demo")),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Showcase some widgets:'),
              CupertinoButton.filled(child: const Text("Button"), onPressed: () {}),
              CupertinoSwitch(value: true, onChanged: (_) {}),
              CupertinoSlider(value: 0.5, onChanged: (_) {}),
            ],
          ),
        ),
      ),
    ),
  );
}
