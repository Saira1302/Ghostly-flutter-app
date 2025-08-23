import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: June 15, 2025',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to our app. By using our services, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Acceptance of Terms: By accessing or using the app, you agree to be bound by these terms.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. User Conduct: You agree not to use the app for any illegal or unauthorized purpose.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. Intellectual Property: All content within the app is owned by us or our licensors.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'New Addition - Enhanced Privacy Measures:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'As of June 15, 2025, we have implemented enhanced privacy measures to protect your data. This includes stricter data encryption, user consent for data collection, and the right to request data deletion. Please review our updated Privacy Policy for more details.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Limitation of Liability: We are not liable for any indirect damages arising from the use of the app.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '5. Changes to Terms: We may update these terms at any time, and continued use constitutes acceptance.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you have any questions, please contact us at support@example.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}