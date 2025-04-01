import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the welcome page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(), // Set WelcomePage as the initial page
    );
  }
}