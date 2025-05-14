import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:id_card/submission_confirmation_page.dart'; // Import new page
import 'dart:io';

class VideoRecorderPage extends StatefulWidget {
  final String sport;
  const VideoRecorderPage({super.key, required this.sport});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  File? videoFile;

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
        SnackBar(content: Text('Error picking video from gallery: $e')),
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
            // Video Placeholder
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
            // Pick from Gallery Button
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
            // Pick from Camera Button
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
            // Submit Button
            ElevatedButton.icon(
              onPressed: () {
                if (videoFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select or record a video first')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmissionConfirmationPage(
                      sport: widget.sport,
                      videoPath: videoFile!.path,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.upload, color: Colors.black),
              label: const Text(
                "Submit",
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