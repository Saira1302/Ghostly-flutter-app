import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: June 15, 2025',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Information We Collect: We may collect personal information such as your name, email, and usage data.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. How We Use Your Information: Your data is used to provide and improve our services, with your consent.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. Data Sharing: We do not sell your personal information to third parties without your consent.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'New Addition - Enhanced Data Protection:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'As of June 15, 2025, we have introduced enhanced data protection measures. This includes end-to-end encryption for all user data, an option to opt-out of data analytics, and a streamlined process for data deletion requests. Please contact us for more information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Your Rights: You have the right to access, correct, or delete your personal data.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '5. Changes to Policy: We may update this policy, and we will notify you of significant changes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'For questions, contact us at privacy@example.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
