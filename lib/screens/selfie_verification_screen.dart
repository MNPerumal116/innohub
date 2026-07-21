import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes/app_routes.dart';

class SelfieVerificationScreen extends StatefulWidget {
  const SelfieVerificationScreen({super.key});

  @override
  State<SelfieVerificationScreen> createState() =>
      _SelfieVerificationScreenState();
}

class _SelfieVerificationScreenState extends State<SelfieVerificationScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitializing = true;
  bool _isCaptured = false;
  bool _isCapturing = false;
  String? _capturedImagePath;
  String? _initError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        setState(() {
          _initError = 'Camera permission is required.';
          _isInitializing = false;
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _initError = 'No camera found on this device.';
          _isInitializing = false;
        });
        return;
      }

      // Try to pick front camera
      final frontCam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameras = cameras;
      _controller = CameraController(
        frontCam,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initError = 'Camera error: ${e.toString()}';
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      ctrl.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takeSelfie() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized || _isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final file = await ctrl.takePicture();
      setState(() {
        _capturedImagePath = file.path;
        _isCaptured = true;
        _isCapturing = false;
      });
    } catch (e) {
      setState(() => _isCapturing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture failed: $e')),
        );
      }
    }
  }

  void _retake() {
    setState(() {
      _isCaptured = false;
      _capturedImagePath = null;
    });
  }

  Future<void> _proceed() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.confirmClockIn,
      arguments: _capturedImagePath,
    );
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Face Verification',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_controller != null &&
              _cameras != null &&
              _cameras!.length > 1 &&
              !_isCaptured)
            IconButton(
              icon: const Icon(Icons.flip_camera_ios_outlined,
                  color: Colors.white),
              onPressed: _flipCamera,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Position your face within the frame',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Camera / Preview area
            Expanded(
              child: Center(
                child: _buildCameraView(),
              ),
            ),

            // Bottom controls
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: _isCaptured ? _buildPostCaptureControls() : _buildShutterButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    // Show error state
    if (_initError != null) {
      return _buildErrorState(_initError!);
    }

    // Loading
    if (_isInitializing) {
      return const CircularProgressIndicator(color: Colors.blueAccent);
    }

    final ctrl = _controller;

    // Captured preview
    if (_isCaptured && _capturedImagePath != null) {
      return _buildOvalFrame(
        child: Image.file(
          File(_capturedImagePath!),
          fit: BoxFit.cover,
        ),
        borderColor: Colors.green,
        showCheck: true,
      );
    }

    // Camera not ready
    if (ctrl == null || !ctrl.value.isInitialized) {
      return _buildErrorState('Camera not available');
    }

    // Live viewfinder
    return _buildOvalFrame(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: AspectRatio(
          aspectRatio: ctrl.value.aspectRatio,
          child: CameraPreview(ctrl),
        ),
      ),
      borderColor: Colors.blueAccent,
      showCheck: false,
    );
  }

  Widget _buildOvalFrame({
    required Widget child,
    required Color borderColor,
    required bool showCheck,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 260,
          height: 340,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: borderColor, width: 4),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
        // Scan line animation
        if (!showCheck)
          Positioned(
            top: 80,
            child: Container(
              width: 200,
              height: 2,
              color: Colors.blueAccent.withOpacity(0.6),
            ),
          ),
        // Success overlay
        if (showCheck)
          Container(
            width: 260,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.black26,
            ),
            child: const Center(
              child: Icon(Icons.check_circle, color: Colors.green, size: 72),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(String msg) {
    return Container(
      width: 260,
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: Colors.grey.shade900,
        border: Border.all(color: Colors.redAccent, width: 4),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _isCapturing ? null : _takeSelfie,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: _isCapturing
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPostCaptureControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: _retake,
          icon: const Icon(Icons.refresh, color: Colors.white70),
          label: const Text('Retake',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: _proceed,
          icon: const Icon(Icons.map_outlined, color: Colors.white, size: 18),
          label: const Text(
            'Verify Location',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }

  Future<void> _flipCamera() async {
    final cameras = _cameras;
    final ctrl = _controller;
    if (cameras == null || cameras.length < 2 || ctrl == null) return;

    final currentLens = ctrl.description.lensDirection;
    final next = cameras.firstWhere(
      (c) => c.lensDirection != currentLens,
      orElse: () => cameras.first,
    );

    setState(() => _isInitializing = true);
    await ctrl.dispose();

    _controller = CameraController(
      next,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _controller!.initialize();
    if (mounted) setState(() => _isInitializing = false);
  }
}
