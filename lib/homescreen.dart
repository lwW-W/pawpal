import 'package:flutter/material.dart';
import 'user.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PawPal Home"),
        backgroundColor: const Color.fromARGB(255, 255, 169, 116), 
      ),
      body: Center(
        child: Text(
          "Welcome, ${user.name}!",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
