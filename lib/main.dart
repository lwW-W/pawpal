import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {
  runApp(const PawPalApp());
}

class PawPalApp extends StatelessWidget {
  const PawPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawPal',
      home: SplashScreen(),
    );
  }
}
