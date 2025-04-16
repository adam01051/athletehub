import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'login_page.dart';
import 'home_page.dart';
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

  final TextEditingController _passwordController = TextEditingController();

  // Database connection
  Future<PostgreSQLConnection> _getConnection() async {
    return PostgreSQLConnection(
      '10.0.2.2', // Use this for Android emulator
      5432,
      'flutter',
      username: 'postgres',
      password: '4909770',
    );
  }

  // Save user data to PostgreSQL
  Future<void> _saveToDatabase() async {
    final connection = await _getConnection();
    try {
      await connection.open();
      await connection.execute(
        '''
        INSERT INTO users (name, email, password, sport, position, team)
        VALUES (@name, @email, @password, @sport, @position, @team)
        ''',
        substitutionValues: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'sport': _sportController.text,
          'position': _positionController.text.isNotEmpty ? _positionController.text : null,

        },
      );
    } catch (e) {
      print('Error saving to database: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
      rethrow;
    } finally {
      await connection.close();
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save to PostgreSQL
        await _saveToDatabase();

        // Save to UserData singleton for in-memory access
        UserData().saveUserData(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          sport: _sportController.text,
          position: _positionController.text.isNotEmpty ? _positionController.text : null,

        );

        print("Saved user data: ${UserData().name}, ${UserData().email}");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(email: _emailController.text),
          ),
        );
      } catch (e) {
        // Error already handled in _saveToDatabase
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _sportController.dispose();
    _positionController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                _buildTextField(
                  controller: _positionController,
                  label: "Position",
                  icon: Icons.directions_run,
                ),


                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent[400],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
    bool obscureText = false,
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
          obscureText: obscureText,
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