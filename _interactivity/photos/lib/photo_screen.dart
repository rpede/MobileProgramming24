import 'dart:io';

import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final File file;

  const PhotoScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file.path.split('/').last)),
      body: Hero(tag: file.path, child: Image.file(file)),
    );
  }
}
