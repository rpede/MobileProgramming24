import 'dart:io';

import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'photo_screen.dart';

const imageDir = '/data/user/0/com.example.photos/cache/';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  _onPhotoTap(BuildContext context, File file) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PhotoScreen(file: file),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Directory(imageDir).list().toList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final files = (snapshot.data ?? []).map((entry) => File(entry.path));
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: [
              for (final file in files)
                GestureDetector(
                  onTap: () => _onPhotoTap(context, file),
                  child: Hero(
                    tag: file.path,
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
