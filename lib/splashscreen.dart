import 'package:flutter/material.dart';
import 'dart:async';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 169, 116),
        title: const Text("Pawpal App"),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pawpal.png', 
              width: 290,
              height: 290,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            const CircularProgressIndicator(
              color: Color.fromARGB(255, 107, 0, 66),
            ),
          ],
        ),
      ),
    );
  }
}
