import 'package:flutter/material.dart';

import 'camera_screen.dart';
import 'gallery_screen.dart';
import 'home_screen.dart';

// https://docs.flutter.dev/cookbook/design/drawer

const menu = {
  'Home': HomeScreen.new,
  'Camera': CameraScreen.new,
  'Gallery': GalleryScreen.new,
};

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  _onMenuTap(BuildContext context, Widget Function({Key? key}) constructor) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => constructor.call()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.greenAccent, Colors.blue],
              ),
            ),
            child: Text('Photos', style: textTheme.titleLarge),
          ),
          for (final entry in menu.entries)
            ListTile(
              title: Text(entry.key),
              onTap: () => _onMenuTap(context, entry.value),
            ),
        ],
      ),
    );
  }
}
