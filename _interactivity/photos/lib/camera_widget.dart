import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({required this.camera, super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Use the camera given to the widget.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // The future errored, display the error.
          return Center(child: Text(snapshot.error!.toString()));
        }
        if (!_controller.value.isInitialized) {
          // While waiting for initialization, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        } else {
          // When the Future is complete, display the preview.
          return Column(
            children: [
              // Live preview of what the camera is pointing at.
              CameraPreview(_controller),
              // Button for taking pictures.
              _takePictureButton(context),
            ],
          );
        }
      },
    );
  }

  Widget _takePictureButton(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return FloatingActionButton(
      // Provide an onPressed callback.
      onPressed: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and then get the location
          // where the image file is saved.
          final image = await _controller.takePicture();
          // Displaying the path can be useful for debugging.
          messenger.showSnackBar(SnackBar(content: Text(image.path)));
        } catch (e) {
          // If an error occurs, display it with a red background.
          messenger.showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
          );
        }
      },
      child: const Icon(Icons.camera),
    );
  }
}
