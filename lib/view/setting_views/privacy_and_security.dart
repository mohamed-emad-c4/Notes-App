// privacy_and_security.dart

import 'package:flutter/material.dart';

class PrivacyAndSecurityPage extends StatelessWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Security'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy and Security',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Your privacy and security are important to us. We take the following measures to ensure that your data is protected:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              BulletPoint(
                
                  text:
                      'Data Encryption: We use industry-standard encryption to protect your data.'),
              BulletPoint(
                  text: 'Access Control: No personnel can access your data.'),
              BulletPoint(
                  text:
                      'Regular Audits: We conduct regular security audits to identify and fix vulnerabilities.'),
              BulletPoint(
                  text:
                      'User Control: You have control over your data and can manage your settings at any time.'),
              SizedBox(height: 20),
              BulletPoint(
                  text:
                      'PIN: We use PIN codes to protect your notes and ensure that only you can access them.'),
              SizedBox(height: 20),
              Text(
                'For any questions or concerns, please contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.brightness_1, size: 6),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
