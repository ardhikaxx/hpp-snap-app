import 'package:flutter/material.dart';
import 'splash_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HPP Snap App',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}