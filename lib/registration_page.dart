import 'package:flutter/material.dart';
import 'login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _sportController.dispose();
    _positionController.dispose();
    _teamController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );
      // Optionally navigate to profile page after registration
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AthleteSettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Register",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title
                const Text(
                  "Create Your Athlete Profile",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 30),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),


                // Position Field
                _buildTextField(
                  controller: _positionController,
                  label: "Password",
                  icon: Icons.directions_run,
                ),
                const SizedBox(height: 20),
                // Sport Field
                _buildTextField(
                  controller: _sportController,
                  label: "Sport",
                  icon: Icons.sports,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your sport';
                    }
                    return null;
                  },
                ),



                const SizedBox(height: 20),

                // Team Field
                _buildTextField(
                  controller: _teamController,
                  label: "Team",
                  icon: Icons.group,
                ),
                const SizedBox(height: 30),

                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent[400],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Optional: Link to Login
                Center(

                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.amberAccent[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )




                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: Colors.amberAccent[400]),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amberAccent[400]!),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
        ),
      ],
    );
  }
}

