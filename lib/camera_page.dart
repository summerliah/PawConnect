import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final currentCamera = _cameraController!.description;
    final newCamera = cameras.firstWhere(
      (camera) => camera.lensDirection != currentCamera.lensDirection,
      orElse: () => cameras[0],
    );

    await _cameraController!.dispose();
    _cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.camera.request(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data?.isGranted ?? false) {
          if (_isCameraInitialized && _cameraController != null) {
            return Stack(
              children: [
                // Camera Preview
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_cameraController!),
                ),
                // Camera Controls
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.flip_camera_ios, color: Colors.white),
                          onPressed: _switchCamera,
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.camera, color: Colors.white, size: 40),
                          onPressed: () async {
                            try {
                              if (!_cameraController!.value.isTakingPicture) {
                                final image =
                                    await _cameraController!.takePicture();
                                // Handle the captured image
                                print('Picture saved to: ${image.path}');
                              }
                            } catch (e) {
                              print('Error taking picture: $e');
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_library, color: Colors.white),
                          onPressed: () {
                            // Handle gallery access
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Initializing Camera...'),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_photography, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text('Camera Permission Required',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Text('Please enable camera access in settings.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: Text('Open Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
