import 'package:flutter/material.dart';
import 'video_player_page.dart'; // Make sure this file exists

class ResultsPage extends StatelessWidget {
  final String sport;
  final String videoPath;
  final Map<String, dynamic> analysisResults;
  final String? annotatedVideoUrl;
  final Map<String, dynamic>? videoFormat;

  const ResultsPage({
    super.key,
    required this.sport,
    required this.videoPath,
    required this.analysisResults,
    this.annotatedVideoUrl,
    this.videoFormat,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> metrics = {
      'Speed': '${analysisResults['max_speed'] ?? 'N/A'} m/s',
      'Average Speed': '${analysisResults['avg_speed'] ?? 'N/A'} m/s',
      'Final Speed': '${analysisResults['final_speed'] ?? 'N/A'} m/s',
      'Swing': '${analysisResults['swing'] ?? 'N/A'} m',
      'Spin': '${analysisResults['spin'] ?? 'N/A'}',
      'Confidence': '${analysisResults['confidence'] ?? 'N/A'}',
    };

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Results: $sport",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Analysis Results",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Metric',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Value',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: metrics.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(entry.key, style: const TextStyle(color: Colors.white))),
                      DataCell(Text(entry.value, style: const TextStyle(color: Colors.white))),
                    ],
                  );
                }).toList(),
                dataRowColor: MaterialStateProperty.all(Colors.grey[800]),
                headingRowColor: MaterialStateProperty.all(Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Submitted Video",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (annotatedVideoUrl != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Processed Video: ${annotatedVideoUrl!.split('/').last}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerPage(videoUrl: annotatedVideoUrl!),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      label: const Text(
                        "View Processed Video",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent[400],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Video: ${videoPath.split('/').last} (No processed video available)",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
            if (videoFormat != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Video Format",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Codec: ${videoFormat!['codec'] ?? 'N/A'}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Resolution: ${videoFormat!['resolution'] ?? 'N/A'}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Frame Rate: ${videoFormat!['frame_rate'] ?? 'N/A'} fps",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Back",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
