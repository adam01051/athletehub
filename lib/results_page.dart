import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsPage extends StatelessWidget {
  final String sport;
  final String videoPath;
  final Map<String, dynamic> analysisResults;
  final String? annotatedVideoUrl;

  const ResultsPage({
    super.key,
    required this.sport,
    required this.videoPath,
    required this.analysisResults,
    this.annotatedVideoUrl,
  });

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch video: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map API results to display
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
            // Metrics Table
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Value',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: metrics.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          entry.key,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      DataCell(
                        Text(
                          entry.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                dataRowColor: MaterialStateProperty.all(Colors.grey[800]),
                headingRowColor: MaterialStateProperty.all(Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 30),
            // Video File Name
            const Text(
              "Submitted Video",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Video: ${videoPath.split('/').last}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (annotatedVideoUrl != null)
              ElevatedButton.icon(
                onPressed: () => _launchVideo(annotatedVideoUrl!),
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text(
                  "View Annotated Video",
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to confirmation page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[400],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}