import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AboutUs),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).AboutUs,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).WelcomeMessage,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).OurMission,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).OurMission,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).ContactUs,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).QuestionsFeedback,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaButton(
                    context,
                    icon: const FaIcon(FontAwesomeIcons.envelope),
                    label: S.of(context).EmailUs,
                    onTap: () {
                      _sendEmail();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                S.of(context).FollowUs,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaButton(
                    context,
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    label: S.of(context).Facebook,
                    onTap: () {
                      _launchURL(
                          'https://www.facebook.com/profile.php?id=61563607514517');
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSocialMediaButton(
                    context,
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                    label: S.of(context).Twitter,
                    onTap: () {
                      _launchURL('https://x.com/zemax_c4');
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSocialMediaButton(
                    context,
                    icon: const FaIcon(FontAwesomeIcons.instagram),
                    label: S.of(context).Instagram,
                    onTap: () {
                      _launchURL('https://www.instagram.com/flutternexus/');
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

  Widget _buildSocialMediaButton(BuildContext context,
      {required FaIcon icon,
      required String label,
      required VoidCallback onTap}) {
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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      Get.snackbar("Error", "Could not launch");
    }
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zemax.c4@gmail.com',
      query: 'subject=Help%20Needed&body=Hi%20there,%0D%0A%0D%0A',
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      Get.snackbar("Error", "Could not launch");
    }
  }
}
