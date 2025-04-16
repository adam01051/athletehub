import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'welcome_page.dart';
import 'video_recorder_page.dart'; // Import the new page

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "AthleteHub",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.grey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amberAccent[400],
                    child: const Icon(Icons.person, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AthleteSettingsPage(
                      // name: "Adam Smith",
                      // email: "adamrandom@gmail.com",
                      // sport: "Soccer",
                      // position: "Midfielder",
                      // team: "City Strikers",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings page under development')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Take control of your athletic journey",
              style: TextStyle(color: Colors.grey[400], fontSize: 16, letterSpacing: 1),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildFeatureButton(
                    "Soccer",
                    Icons.sports_soccer_rounded,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VideoRecorderPage(sport: "Soccer"),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    "Cricket",
                    Icons.sports_cricket_outlined,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VideoRecorderPage(sport: "Cricket"),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    "Something",
                    Icons.sports,
                        () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Something coming soon')),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    "View Stats",
                    Icons.analytics,
                        () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Stats viewing coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.amberAccent[400]),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}