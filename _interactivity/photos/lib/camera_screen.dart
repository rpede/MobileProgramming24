import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photos/app_drawer.dart';

import 'camera_widget.dart';

// https://docs.flutter.dev/cookbook/plugins/picture-using-camera

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraDescription? camera;

  Future<List<CameraDescription>> _getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    return cameras;
  }

  _onCameraChanged(CameraDescription? camera) {
    setState(() {
      this.camera = camera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (camera == null)
            _buildCameraSelection()
          else
            CameraWidget(
              camera: camera!,
              key: ValueKey('camera-${camera!.name}'),
            )
        ],
      ),
    );
  }

  FutureBuilder<List<CameraDescription>> _buildCameraSelection() {
    return FutureBuilder(
      future: _getCameras(),
      builder: (context, snapshot) {
        return DropdownButton<CameraDescription>(
          value: camera,
          hint: const Text('Select a camera'),
          items: [
            for (final e in snapshot.data ?? <CameraDescription>[])
              DropdownMenuItem(
                value: e,
                child: Text('${e.lensDirection.name} ${e.name}'),
              )
          ],
          onChanged: _onCameraChanged,
        );
      },
    );
  }
}
