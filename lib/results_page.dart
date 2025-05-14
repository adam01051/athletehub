import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String sport;
  final String videoPath;

  const ResultsPage({super.key, required this.sport, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    // Placeholder values for Speed, Strength, and Curve
    final Map<String, String> metrics = {
      'Speed': '85 mph',
      'Strength': '72%',
      'Curve': 'Moderate',
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
          ],
        ),
      ),
    );
  }
}