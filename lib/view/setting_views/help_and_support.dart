import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are here to help! Whether you have a question, encounter an issue, or need further assistance, our support team is ready to assist you.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Frequently Asked Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const BulletPoint(text: 'How can I reset my password?'),
              const BulletPoint(text: 'How to change my email address?'),
              const BulletPoint(text: 'How to contact customer support?'),
              const SizedBox(height: 20),
              const Text(
                'If you didn\'t find the answer you\'re looking for, feel free to contact us directly:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    context,
                    icon: Icons.email,
                    label: 'Email Us',
                    onTap: _sendEmail,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Connect with us on social media:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialMediaButton(
                      context,
                      icon: AntDesign.whats_app_outline,
                      label: 'WhatsApp',
                      color: Colors.green,
                      onTap: _contactViaWhatsApp,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: Icons.facebook,
                      label: 'Messenger',
                      color: Colors.blue,
                      onTap: _contactViaMessenger,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: AntDesign.twitter_circle_fill,
                      label: 'Twitter',
                      color: Colors.lightBlue,
                      onTap: _contactViaTwitter,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: AntDesign.instagram_fill,
                      label: 'Instagram',
                      color: Colors.purple,
                      onTap: _contactViaInstagram,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'We appreciate your feedback and strive to improve our service continuously.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for creating circular buttons
  Widget _buildCircleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget for creating social media buttons
  Widget _buildSocialMediaButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zemax.c4@gmail.com',
      query:
          'subject=Help%20Needed&body=Hi%20there,%0D%0A%0D%0A', // Add more query parameters as needed
    );

    // استخدام canLaunchUrl و launchUrl بدلاً من canLaunch و launch
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Could not launch the email app
      print('Could not launch email app');
    }
  }



void _contactViaWhatsApp() async {
  const String phoneNumber = '201099312476'; // رقم الهاتف بدون +
  const String message = 'Hello, I need some assistance.';

  final Uri whatsappUri = Uri(
    scheme: 'https',
    host: 'wa.me',
    path: '/$phoneNumber',
    queryParameters: {
      'text': message,
    },
  );

  String whatsappLink = whatsappUri.toString();
  print('WhatsApp Link: $whatsappLink');

  try {
    if (await canLaunch(whatsappLink)) {
      await launch(whatsappLink);
    } else {
      print('Could not launch WhatsApp');
    }
  } catch (e) {
    print('Error launching WhatsApp: $e');
  }
}



  void _contactViaMessenger() async {
    // Replace with your Facebook page URL or Messenger link
    final Uri messengerUri = Uri.parse('https://m.me/zemax.c4');
    if (await canLaunch(messengerUri.toString())) {
      await launch(messengerUri.toString());
    } else {
      // Could not launch Messenger
      print('Could not launch Messenger');
    }
  }

  void _contactViaTwitter() async {
    // Replace with your Twitter handle
    final Uri twitterUri = Uri.parse('https://twitter.com/zemax_c4');
    if (await canLaunch(twitterUri.toString())) {
      await launch(twitterUri.toString());
    } else {
      // Could not launch Twitter
      print('Could not launch Twitter');
    }
  }

  void _contactViaInstagram() async {
    final Uri instagramUri = Uri.parse('https://instagram.com/mohamed_emad_c4');
    if (await canLaunch(instagramUri.toString())) {
      await launch(instagramUri.toString());
    } else {
      print('Could not launch Instagram');
    }
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
