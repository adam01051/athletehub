import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoRecorderPage extends StatefulWidget {
  final String sport;
  const VideoRecorderPage({super.key, required this.sport});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  bool _isRecording = false; // Placeholder for recording state
  List<String> _videoFiles = []; // To store video file paths

  // @override
  // void initState() {
  //   super.initState();
  //   _loadVideos(); // Load videos when the page opens
  // }

  // Future<void> _loadVideos() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final files = directory.listSync();
  //     setState(() {
  //       _videoFiles = files
  //           .where((file) => file.path.endsWith('.mp4')) // Filter for .mp4 files
  //           .map((file) => file.path)
  //           .toList();
  //     });
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error loading videos: $e')),
  //       );
  //     }
  //   }
  // }

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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  _isRecording ? Icons.stop : Icons.videocam,
                  color: Colors.amberAccent[400],
                  size: 120, // Larger icon for prominence
                ),
                onPressed: () {
                  // Placeholder for toggling recording
                  setState(() {
                    _isRecording = !_isRecording;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isRecording ? 'Recording started' : 'Recording stopped',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                // Show a dialog with the list of videos
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
                // Placeholder for submit action
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
}