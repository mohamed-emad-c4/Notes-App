import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Us',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to our app! We are dedicated to providing you with the best service and experience. Our team is committed to continuous improvement and innovation to meet your needs.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Our Mission:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our mission is to deliver high-quality solutions that improve your daily life and provide a seamless user experience.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'If you have any questions, feedback, or just want to get in touch, feel free to contact us.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaButton(
                    context,
                    icon: Icons.email,
                    label: 'Email Us',
                    onTap: () {
                      _sendEmail();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Follow us on social media:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaButton(
                    context,
                    icon: Icons.facebook,
                    label: 'Facebook',
                    onTap: () {
                      _launchURL('https://facebook.com');
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSocialMediaButton(
                    context,
                    icon: AntDesign.twitter_circle_fill,
                    label: 'Twitter',
                    onTap: () {
                      _launchURL('https://twitter.com');
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSocialMediaButton(
                    context,
                    icon: AntDesign.instagram_fill,
                    label: 'Instagram',
                    onTap: () {
                      _launchURL('https://instagram.com');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for creating circular buttons
  Widget _buildSocialMediaButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
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

  // Launch URL method
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      // Could not launch URL
      print('Could not launch $url');
    }
  }

  // Phone call method
  void _makePhoneCall() async {
    const String phoneNumber =
        '+201099312476'; // Replace with your phone number
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      // Could not make the call
      print('Could not make the phone call');
    }
  }

  // Send email method
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zemax.c4@gmail.com',
      query:
          'subject=Help%20Needed&body=Hi%20there,%0D%0A%0D%0A', // Add more query parameters as needed
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      // Could not launch the email app
      print('Could not launch email app');
    }
  }
}
