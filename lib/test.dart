import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:developer' as developer;
import 'video_player_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File? videoFile;
  CameraController? _controller;
  List<CameraDescription>? cameras;
  VideoPlayerController? _thumbnailController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } else {
      developer.log('No cameras available');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cameras available on this device')),
      );
    }
  }

  Future<void> _initializeThumbnail() async {
    if (videoFile != null) {
      _thumbnailController?.dispose();
      _thumbnailController = VideoPlayerController.file(videoFile!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        var mediaStatus = await Permission.photos.request();
        if (!mediaStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied. Please enable it in settings.')),
          );
          openAppSettings();
          return;
        }
      }

      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          videoFile = File(video.path);
        });
        await _initializeThumbnail();
        developer.log('Video selected: ${video.path}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected video: ${video.path.split('/').last}')),
        );
      } else {
        developer.log('No video selected from gallery');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video selected')),
        );
      }
    } catch (e) {
      developer.log('Error picking video from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video from gallery: $e')),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied. Please enable it in settings.')),
        );
        openAppSettings();
        return;
      }

      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        var mediaStatus = await Permission.videos.request();
        if (!mediaStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied. Please enable it in settings.')),
          );
          openAppSettings();
          return;
        }
      }

      if (_controller == null || !_controller!.value.isInitialized) {
        developer.log('Camera not initialized');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not initialized')),
        );
        return;
      }

      await _controller!.startVideoRecording();
      developer.log('Recording started');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording... Tap to stop')),
      );

      await Future.delayed(const Duration(seconds: 5));
      final XFile video = await _controller!.stopVideoRecording();
      developer.log('Recording completed, video: ${video.path}');

      if (video.path.isNotEmpty) {
        setState(() {
          videoFile = File(video.path);
        });
        final result = await PhotoManager.editor.saveVideo(
          File(video.path),
          title: 'AthleteHubVideo_${DateTime.now().millisecondsSinceEpoch}.mp4',
        );
        if (result != null) {
          developer.log('Video saved to gallery: ${video.path}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recorded video saved: ${video.path.split('/').last}')),
          );
        } else {
          developer.log('Failed to save video to gallery');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save video to gallery')),
          );
        }
        await _initializeThumbnail();
      } else {
        developer.log('No video recorded');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video recorded')),
        );
      }
    } catch (e, stackTrace) {
      developer.log('Error recording video: $e', stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording video: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _thumbnailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Test Video Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: videoFile == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam,
                    color: Colors.grey,
                    size: 60,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Video Placeholder",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  : _thumbnailController != null && _thumbnailController!.value.isInitialized
                  ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _thumbnailController!.value.aspectRatio,
                    child: VideoPlayer(_thumbnailController!),
                  ),
                  const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white70,
                    size: 60,
                  ),
                ],
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _pickFromGallery(),
              icon: const Icon(Icons.photo_library, color: Colors.black),
              label: const Text(
                "Pick from Gallery",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickFromCamera(),
              icon: const Icon(Icons.videocam, color: Colors.black),
              label: const Text(
                "Pick from Camera",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            if (videoFile != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(videoFile: videoFile!),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text(
                  "Play Video",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent[400],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}