import 'package:flutter/material.dart';

class ReportTheBugScreen extends StatefulWidget {
  const ReportTheBugScreen({super.key});

  @override
  _ReportTheBugScreenState createState() => _ReportTheBugScreenState();
}

class _ReportTheBugScreenState extends State<ReportTheBugScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitBugReport() {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      final email = _emailController.text;
      print('Bug Report Submitted - Description: $description, Email: $email');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bug report submitted successfully!')),
      );
      _descriptionController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Bug'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report a Bug',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please provide details about the bug you encountered. We’ll address it as soon as possible.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Bug Description',
                  border: OutlineInputBorder(),
                  hintText: 'Describe the issue in detail...',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bug description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Your Email',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email for follow-up...',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'New Addition - Attachment Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'As of June 15, 2025, you can now attach screenshots or logs to help us diagnose the issue more effectively. Use the attachment button below (feature coming soon!).',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitBugReport,
                child: const Text('Submit Bug Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
