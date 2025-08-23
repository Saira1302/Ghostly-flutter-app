import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_page2.dart'; // Import second screen
import 'welcome_screen.dart'; // Ensure this import is correct

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                      print('Skip pressed');
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
                    'assest/Animation - 1749743604399.json',
                    height: 200,
                    onLoaded: (composition) {
                      print('Lottie animation 1 loaded');
                    },
                    onWarning: (warning) {
                      print('Lottie warning: $warning');
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Find the things you’ve\nbeen looking for",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Here you’ll see all type of content from all around the world.",
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
                      Icon(Icons.circle, size: 10, color: Colors.blue),
                      SizedBox(width: 4),
                      Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
                      SizedBox(width: 4),
                      Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
                    ],
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      print('Navigating to OnboardingScreen2');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Onboardingpage2()),
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