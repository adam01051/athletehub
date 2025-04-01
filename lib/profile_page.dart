import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AthleteSettingsPage(),
    );
  }
}

class AthleteSettingsPage extends StatelessWidget {
  const AthleteSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Profile Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section Title
              const Text(
                "Personal Information",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),

              // Name
              const Text(
                "Name",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Adam Smith",
                    style: TextStyle(
                      color: Colors.amberAccent[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      // Add edit name functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sport Type
              const Text(
                "Sport Type",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Soccer",
                        style: TextStyle(
                          color: Colors.amberAccent[400],
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      // Add edit sport functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Email
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "adam@gmail.com",
                        style: TextStyle(
                          color: Colors.amberAccent[400],
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      // Add edit email functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Additional Athlete Settings
              const Text(
                "Athlete Details",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),

              // Position
              _buildEditableField(
                label: "Position",
                value: "Some postion",
                icon: Icons.directions_run,
              ),
              const SizedBox(height: 20),

              // Team
              _buildEditableField(
                label: "Team",
                value: "Some team",
                icon: Icons.group,
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add save functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent[400],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.amberAccent[400],
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // Add edit functionality for this field
              },
            ),
          ],
        ),
      ],
    );
  }
}