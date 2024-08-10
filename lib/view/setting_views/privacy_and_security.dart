import 'package:flutter/material.dart';
import 'package:test1/generated/l10n.dart';

class PrivacyAndSecurityPage extends StatelessWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PrivacyAndSecurity),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).PrivacyAndSecurity,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).YourPrivacyAndSecurity,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              BulletPoint(text: S.of(context).DataEncryption),
              BulletPoint(text: S.of(context).AccessControl),
              BulletPoint(text: S.of(context).RegularAudits),
              BulletPoint(text: S.of(context).UserControl),
              const SizedBox(height: 20),
              BulletPoint(text: S.of(context).PIN),
              const SizedBox(height: 20),
              Text(
                S.of(context).ForAnyQuestions,
                style: const TextStyle(fontSize: 16),
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
