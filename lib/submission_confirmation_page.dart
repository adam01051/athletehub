import 'package:flutter/material.dart';
import 'package:id_card/results_page.dart'; // Import ResultsPage

class SubmissionConfirmationPage extends StatelessWidget {
  final String sport;
  final String videoPath;

  const SubmissionConfirmationPage({super.key, required this.sport, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Submission Confirmation",
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
            const Icon(
              Icons.check_circle,
              color: Colors.amberAccent,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "Submission Successful!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Sport: $sport",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Video: ${videoPath.split('/').last}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                      sport: sport,
                      videoPath: videoPath,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility, color: Colors.black),
              label: const Text(
                "View Results",
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