import 'package:flutter/material.dart';
import 'package:id_card/test.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const WelcomePage(),
        home: const TestPage(),
    );
  }
}