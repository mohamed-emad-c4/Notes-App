import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test1/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).HelpSupport),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).HelpSupport,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).WeAreHereToHelp,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).FAQ,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BulletPoint(text: S.of(context).ResetPassword),
              BulletPoint(text: S.of(context).ChangeEmail),
              BulletPoint(text: S.of(context).ContactSupport),
              const SizedBox(height: 20),
              Text(
                S.of(context).DidntFindAnswer,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    context,
                    icon: FaIcon(FontAwesomeIcons.envelope),
                    label: S.of(context).EmailUs,
                    onTap: _sendEmail,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                S.of(context).ConnectWithUs,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialMediaButton(
                      context,
                      icon:   FaIcon(FontAwesomeIcons.whatsapp),
                      label: S.of(context).WhatsApp,
                      color: Colors.green,
                      onTap: _contactViaWhatsApp,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: FaIcon(FontAwesomeIcons.facebook),
                      label: S.of(context).Messenger,
                      color: Colors.blue,
                      onTap: _contactViaMessenger,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: FaIcon(FontAwesomeIcons.twitter),
                      label: S.of(context).Twitter,
                      color: Colors.lightBlue,
                      onTap: _contactViaTwitter,
                    ),
                    const SizedBox(width: 20),
                    _buildSocialMediaButton(
                      context,
                      icon: FaIcon(FontAwesomeIcons.instagram),
                      label: S.of(context).Instagram,
                      color: Colors.purple,
                      onTap: _contactViaInstagram,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                S.of(context).WeAppreciateFeedback,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بقية الأكواد كما هي بدون تغيير
}


  // Widget for creating circular buttons
  Widget _buildCircleButton(
    BuildContext context, {
    required FaIcon icon,
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
            child: icon,
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
    required FaIcon icon,
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
            child: icon
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
       Get.snackbar("Error", "'Could not launch Email \n $emailUri");
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
       Get.snackbar("Error", "'Could not launch Instagram \n $e");
  }
}



  void _contactViaMessenger() async {
    // Replace with your Facebook page URL or Messenger link
    final Uri messengerUri = Uri.parse('https://m.me/zemax.c4');
    if (await canLaunch(messengerUri.toString())) {
      await launch(messengerUri.toString());
    } else {
      // Could not launch Messenger
       Get.snackbar("Error", "'Could not launch Messenger");
    }
  }

  void _contactViaTwitter() async {
    // Replace with your Twitter handle
    final Uri twitterUri = Uri.parse('https://twitter.com/zemax_c4');
    if (await canLaunch(twitterUri.toString())) {
      await launch(twitterUri.toString());
    } else {
      // Could not launch Twitter
             Get.snackbar("Error", "'Could not launch Twitter");

    }
  }

  void _contactViaInstagram() async {
    final Uri instagramUri = Uri.parse('https://instagram.com/mohamed_emad_c4');
    if (await canLaunch(instagramUri.toString())) {
      await launch(instagramUri.toString());
    } else {
       Get.snackbar("Error", "'Could not launch Instagram");
     
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
