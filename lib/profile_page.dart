import 'package:flutter/material.dart';
import 'user_data.dart';

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

class AthleteSettingsPage extends StatefulWidget {
  const AthleteSettingsPage({super.key});

  @override
  State<AthleteSettingsPage> createState() => _AthleteSettingsPageState();
}

class _AthleteSettingsPageState extends State<AthleteSettingsPage> {
  // Variables to hold the data, initialized with values from UserData
  String name = UserData().name ?? "Unknown";
  String sportType = UserData().sport ?? "Soccer";
  String email = UserData().email ?? "adam@gmail.com";


  // TextEditingController for the dialog input
  final TextEditingController _editController = TextEditingController();

  // Function to show a dialog and update the field
  Future<void> _showEditDialog(String fieldName, String currentValue, Function(String) onSave) async {
    _editController.text = currentValue;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  onSave(_editController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Save the updated data to UserData
  void _saveChanges() {
    UserData().saveUserData(
      name: name,
      email: email,
      password: UserData().password ?? "", // Preserve existing password
      sport: sportType,


    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes Saved!')),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    name,
                    style: TextStyle(
                      color: Colors.amberAccent[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      _showEditDialog("Name", name, (newValue) {
                        name = newValue;
                      });
                    },
                  ),
                ],
              ),


              const SizedBox(height: 20),
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
                        email,
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
                      _showEditDialog("Email", email, (newValue) {
                        email = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Athlete Details",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 15),

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
                        sportType,
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
                      _showEditDialog("Sport Type", sportType, (newValue) {
                        sportType = newValue;
                      });
                    },
                  ),
                ],
              ),




              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges, // Call the save method
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
    required VoidCallback onEdit,
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
              onPressed: onEdit,
            ),
          ],
        ),
      ],
    );
  }
}