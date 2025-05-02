import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordVideoPage extends StatefulWidget {
  const RecordVideoPage({super.key});

  @override
  State<RecordVideoPage> createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  bool _isRecording = false;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    try {
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
        return;
      }

      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        var mediaStatus = await Permission.videos.request();
        if (!mediaStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          return;
        }
      }

      List<CameraDescription> _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        setState(() {
          cameras = _cameras;
          cameraController = CameraController(_cameras.first, ResolutionPreset.medium);
        });

        _initializeControllerFuture = cameraController?.initialize();
        await _initializeControllerFuture?.catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera initialization failed: $e')),
          );
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras available')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting up camera: $e')),
      );
    }
  }

  Future<String> _generateVideoPath() async {
    final directory = await getExternalStorageDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory!.path}/video_$timestamp.mp4';
  }

  Future<void> _toggleRecording() async {
    try {
      if (!_isRecording) {
        final path = await _generateVideoPath();
        await cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording started')),
        );
      } else {
        final XFile video = await cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording stopped: ${video.path.split('/').last}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during recording: $e')),
      );
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Widget _buildUI() {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(
        child: Text(
          'Camera not available on this device/emulator',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(cameraController!),
                IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    color: Colors.amberAccent[400],
                    size: 120,
                  ),
                  onPressed: _toggleRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Record Video",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildUI(),
    );
  }
}