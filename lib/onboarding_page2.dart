import 'package:firebase_connection_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_page3.dart'; // Correct import

class Onboardingpage2 extends StatelessWidget {
  const Onboardingpage2({super.key});

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
                        MaterialPageRoute(builder: (_) => OnboardingScreen3()), // Changed to OnboardingScreen3
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
                    'assest/Animation - 1749743604399.json',
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Connect with the World",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Share your moments and connect with people globally.",
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
                      Icon(Icons.circle, size: 10, color: Colors.blue),
                      SizedBox(width: 4),
                      Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
                    ],
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OnboardingScreen3()), // Removed const
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