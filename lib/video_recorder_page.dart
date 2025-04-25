import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class VideoRecorderPage extends StatefulWidget {
  final String sport;
  const VideoRecorderPage({super.key, required this.sport});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  bool _isRecording = false;
  List<String> _videoFiles = [];
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    try {
      print('Requesting camera permission...');
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        print('Camera permission denied');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
        return;
      }

      print('Requesting storage permission...');
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        print('Storage permission not granted, trying media permission...');
        var mediaStatus = await Permission.videos.request();
        if (!mediaStatus.isGranted) {
          print('Media permission denied');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          return;
        }
      }

      print('Fetching available cameras...');
      List<CameraDescription> _cameras = await availableCameras();
      print('Found ${_cameras.length} cameras');
      if (_cameras.isNotEmpty) {
        setState(() {
          cameras = _cameras;
          cameraController = CameraController(_cameras.first, ResolutionPreset.medium);
        });

        print('Initializing camera...');
        _initializeControllerFuture = cameraController?.initialize();
        await _initializeControllerFuture?.catchError((e) {
          print('Camera initialization failed: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera initialization failed: $e')),
          );
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        print('No cameras available');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras available')),
        );
      }
    } catch (e) {
      print('Error setting up camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting up camera: $e')),
      );
    }
  }

  Future<String> _generateVideoPath() async {
    final directory = await getExternalStorageDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory!.path}/${widget.sport}_$timestamp.mp4';
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
        final path = video.path;
        setState(() {
          _isRecording = false;
          _videoFiles.add(path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording stopped')),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.grey[800],
                    title: const Text(
                      "Video Archives",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: _videoFiles.isEmpty
                        ? const Text(
                      "No videos found.",
                      style: TextStyle(color: Colors.grey),
                    )
                        : SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _videoFiles.length,
                        itemBuilder: (context, index) {
                          final fileName = _videoFiles[index].split('/').last;
                          return ListTile(
                            title: Text(
                              fileName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected: $fileName')),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.amberAccent[400]),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.archive, color: Colors.black),
              label: const Text(
                "Archives",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submitting...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "${widget.sport} Video Recorder",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildUI(),
    );
  }
}