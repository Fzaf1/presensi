import 'dart:io';

import 'package:camera/camera.dart';

typedef ImageCapturedCallback = Future<void> Function(File imageFile);

class BiometricCameraService {
  CameraController? _controller;
  CameraController? get controller => _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('NoCamera', 'Kamera tidak tersedia di perangkat.');
    }
    final camera = cameras.firstWhere(
      (item) => item.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    final controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = controller;
    await controller.initialize();
  }

  Future<File> captureImage() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('Kamera belum siap.');
    }
    final image = await controller.takePicture();
    return File(image.path);
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
