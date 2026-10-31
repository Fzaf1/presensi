import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'biometric_camera_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    required this.isClockIn,
    super.key,
    this.onImageCaptured,
  });

  final bool isClockIn;
  final ImageCapturedCallback? onImageCaptured;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _cameraService = BiometricCameraService();
  String? _cameraError;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();
      if (mounted) setState(() {});
    } on CameraException catch (error) {
      if (mounted) {
        setState(() => _cameraError = error.description ?? error.code);
      }
    } catch (error) {
      if (mounted) setState(() => _cameraError = 'Kamera gagal dibuka: $error');
    }
  }

  Future<void> _capture() async {
    setState(() => _isCapturing = true);
    try {
      final imageFile = await _cameraService.captureImage();
      await widget.onImageCaptured?.call(imageFile);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto presensi berhasil diambil.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil foto: $error')));
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: lookInNavy,
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF281876),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'FaceID Authentication',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.isClockIn ? 'Presensi Masuk' : 'Presensi Pulang',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Siap untuk identifikasi biometrik',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: .72,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_cameraService.controller?.value.isInitialized ??
                          false)
                        CameraPreview(_cameraService.controller!)
                      else
                        Container(
                          color: const Color(0xFF241459),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                _cameraError ?? 'Menyiapkan kamera...',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      const _FaceFrame(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          IconButton.filled(
            onPressed:
                _isCapturing ||
                    !(_cameraService.controller?.value.isInitialized ?? false)
                ? null
                : _capture,
            style: IconButton.styleFrom(
              backgroundColor: lookInBlue,
              foregroundColor: Colors.white,
              fixedSize: const Size(68, 68),
            ),
            icon: _isCapturing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.camera_alt_outlined, size: 30),
          ),
          const SizedBox(height: 8),
          IconButton(
            tooltip: 'Batal',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 26),
          ),
          const SizedBox(height: 18),
        ],
      ),
    ),
  );
}

class _FaceFrame extends StatelessWidget {
  const _FaceFrame();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _FaceFramePainter(), child: const SizedBox.expand());
}

class _FaceFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const insetX = 32.0;
    final rect = Rect.fromLTWH(
      insetX,
      size.height * .16,
      size.width - insetX * 2,
      size.height * .68,
    );
    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const corner = 24.0;
    for (final point in [
      (rect.left, rect.top, 1.0, 1.0),
      (rect.right, rect.top, -1.0, 1.0),
      (rect.left, rect.bottom, 1.0, -1.0),
      (rect.right, rect.bottom, -1.0, -1.0),
    ]) {
      canvas.drawLine(
        Offset(point.$1, point.$2),
        Offset(point.$1 + corner * point.$3, point.$2),
        white,
      );
      canvas.drawLine(
        Offset(point.$1, point.$2),
        Offset(point.$1, point.$2 + corner * point.$4),
        white,
      );
    }
    final scanner = Paint()
      ..color = const Color(0xFF2AF5A0)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(rect.left + 8, size.height * .5),
      Offset(rect.right - 8, size.height * .5),
      scanner,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
