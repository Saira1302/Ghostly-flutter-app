import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'welcome_screen.dart'; // Ensure this import is correct

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key}); // Ensure const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top "Skip" button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => WelcomeScreen()), // Changed to WelcomeScreen
                      );
                    },
                    child: const Text("Skip"),
                  ),
                ],
              ),
            ),

            // Main Illustration
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assest/Animation - 1749743604399.json', // Ensure this asset exists
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Start Your Journey",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Join now and explore endless possibilities.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom dots and button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
                      SizedBox(width: 4),
                      Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 10, color: Colors.blue),
                    ],
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => WelcomeScreen()), // Changed to WelcomeScreen
                      );
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}