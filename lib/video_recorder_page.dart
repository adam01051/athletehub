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

  // Test data variables
  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Map<String, String>> _testDataRecords = []; // Store test entries

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Test Data", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _testNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Test Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                TextField(
                  controller: _scoreController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Score',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Duration (seconds)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                TextField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                final testName = _testNameController.text.trim();
                final score = _scoreController.text.trim();
                final duration = _durationController.text.trim();
                final notes = _notesController.text.trim();

                if (testName.isEmpty || score.isEmpty || duration.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required test fields.')),
                  );
                  return;
                }

                setState(() {
                  _testDataRecords.add({
                    'testName': testName,
                    'score': score,
                    'duration': duration,
                    'notes': notes,
                    'video': _videoFiles.isNotEmpty ? _videoFiles.last : 'No video',
                  });
                  _testNameController.clear();
                  _scoreController.clear();
                  _durationController.clear();
                  _notesController.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test data submitted')),
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
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey[800],
                  title: const Text(
                    "Test Data Records",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: _testDataRecords.isEmpty
                      ? const Text("No test data submitted.", style: TextStyle(color: Colors.grey))
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _testDataRecords.map((record) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Test Name: ${record['testName']}\nScore: ${record['score']}\nDuration: ${record['duration']} sec\nNotes: ${record['notes'] ?? 'None'}\nVideo: ${record['video']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
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
            child: const Text('View Test Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent[400],
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
      appBar: AppBar(title: Text('Video Recorder: ${widget.sport}')),
      body: _buildUI(),
    );
  }
}
