import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'submission_confirmation_page.dart';
import 'user_data.dart';

class VideoRecorderPage extends StatefulWidget {
  final String sport;
  const VideoRecorderPage({super.key, required this.sport});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  File? videoFile;
  bool _isAnalyzing = false;

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          videoFile = File(video.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected video: ${video.path.split('/').last}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        setState(() {
          videoFile = File(video.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recorded video: ${video.path.split('/').last}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video recorded')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording video: $e')),
      );
    }
  }

  Future<void> _analyzeVideo() async {
    if (_isAnalyzing || videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analysis in progress or no video selected')),
      );
      return;
    }

    _isAnalyzing = true;
    const apiUrl = 'https://${UserData.serverIP}/analyze'; // Updated ngrok URL
    print('Analysis URL: $apiUrl');

    final String videoPath = videoFile!.path;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        videoPath,
        filename: videoPath.split('/').last,
      ));

      final client = http.Client();
      final response = await client.send(request).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          client.close();
          throw Exception('Analysis timed out');
        },
      );
      print('Received response with status: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final results = data['results'] ?? data;
        final videoPathFromApi = data['output_video_path'] as String?;
        if (mounted) {
          UserData().saveVideoData(
            videoPath: videoPath,
            analysisResults: results,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmissionConfirmationPage(
                sport: widget.sport,
                videoPath: videoPath,
                analysisResults: results,
                annotatedVideoUrl: videoPathFromApi != null
                    ? 'https://1fc5-115-91-214-5.ngrok-free.app/$videoPathFromApi'
                    : null,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Analysis failed: $responseBody')),
          );
        }
      }
    } catch (e) {
      print('Error during analysis: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    } finally {
      _isAnalyzing = false;
      if (mounted) {
        setState(() {
          videoFile = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Video Recorder: ${widget.sport}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_library,
                    color: Colors.grey,
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Selected: ${videoFile!.path.split('/').last}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _pickFromGallery,
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
              onPressed: _pickFromCamera,
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _analyzeVideo,
              icon: const Icon(Icons.analytics, color: Colors.black),
              label: const Text(
                "Analyze Video",
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
        ),
      ),
    );
  }
}