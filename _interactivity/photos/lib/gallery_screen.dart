import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app_drawer.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  void _onPhotoTap(BuildContext context, File file) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PhotoScreen(file: file),
    ));
  }

  Future<List<FileSystemEntity>> _listPhotos() async {
    String imagePath;
    if (Platform.isIOS) {
      final documentsDir = await getApplicationDocumentsDirectory();
      imagePath = [documentsDir.path, 'camera', 'pictures'].join('/');
    } else {
      // Assume Android
      final cacheDir = await getApplicationCacheDirectory();
      imagePath = cacheDir.path;
    }
    return Directory(imagePath).list().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _listPhotos(),
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
