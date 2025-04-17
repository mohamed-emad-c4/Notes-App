import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test1/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test1/shared/app_theme.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({super.key});

  @override
  State<HelpAndSupportPage> createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<FAQItem> _faqItems = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    // Initialize FAQ items
    _faqItems.addAll([
      FAQItem(
        question: "How do I reset my PIN?",
        answer:
            "To reset your PIN, go to Settings > Privacy & Security > PIN Protection and tap on 'Reset PIN'. You'll need to verify your identity before setting a new PIN.",
      ),
      FAQItem(
        question: "Can I recover deleted notes?",
        answer:
            "Yes, deleted notes are moved to the Trash for 30 days before being permanently deleted. You can access them from the menu and restore them if needed.",
      ),
      FAQItem(
        question: "How do I sync my notes across devices?",
        answer:
            "Currently, notes are stored locally on your device. We're working on a cloud sync feature that will be available in a future update.",
      ),
      FAQItem(
        question: "Is my data encrypted?",
        answer:
            "Yes, all your notes are encrypted on your device. Hidden notes have an additional layer of protection with PIN access.",
      ),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.getGradientAppBar(S.of(context).HelpSupport),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildHelpCard(context),
                const SizedBox(height: 24),
                _buildFAQSection(context),
                const SizedBox(height: 24),
                _buildContactSection(context),
                const SizedBox(height: 24),
                _buildSocialSection(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).HelpSupport,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).WeAreHereToHelp,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Need assistance?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Our support team is ready to help you with any questions or issues.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.question_answer, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).FAQ,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._faqItems.map((item) => _buildFAQItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, FAQItem item) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        tilePadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        childrenPadding: const EdgeInsets.only(bottom: 16.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              item.answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.contact_support, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).DidntFindAnswer,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "We're here to help you with any questions or issues you may have. Reach out to us through any of these channels.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: _sendEmail,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        S.of(context).EmailUs,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).ConnectWithUs,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).WeAppreciateFeedback,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildSocialConnectButton(
                    context,
                    icon: FontAwesomeIcons.whatsapp,
                    label: S.of(context).WhatsApp,
                    color: Colors.green.shade500,
                    onTap: _contactViaWhatsApp,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialConnectButton(
                    context,
                    icon: FontAwesomeIcons.facebookMessenger,
                    label: S.of(context).Messenger,
                    color: Colors.blue.shade600,
                    onTap: _contactViaMessenger,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialConnectButton(
                    context,
                    icon: FontAwesomeIcons.twitter,
                    label: S.of(context).Twitter,
                    color: Colors.lightBlue.shade400,
                    onTap: _contactViaTwitter,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialConnectButton(
                    context,
                    icon: FontAwesomeIcons.instagram,
                    label: S.of(context).Instagram,
                    color: Colors.purple.shade600,
                    onTap: _contactViaInstagram,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialConnectButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zemax.c4@gmail.com',
      query: 'subject=Help%20Needed&body=Hi%20there,%0D%0A%0D%0A',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch Email client",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.8),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not launch Email: $e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }

  void _contactViaWhatsApp() async {
    const String phoneNumber = '201099312476';
    const String message = 'Hello, I need some assistance.';

    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
      queryParameters: {
        'text': message,
      },
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch WhatsApp",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.8),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not launch WhatsApp: $e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }

  void _contactViaMessenger() async {
    final Uri messengerUri = Uri.parse('https://m.me/zemax.c4');

    try {
      if (await canLaunchUrl(messengerUri)) {
        await launchUrl(messengerUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch Messenger",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.8),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not launch Messenger: $e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }

  void _contactViaTwitter() async {
    final Uri twitterUri = Uri.parse('https://twitter.com/zemax_c4');

    try {
      if (await canLaunchUrl(twitterUri)) {
        await launchUrl(twitterUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch Twitter",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.8),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not launch Twitter: $e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }

  void _contactViaInstagram() async {
    final Uri instagramUri = Uri.parse('https://instagram.com/mohamed_emad_c4');

    try {
      if (await canLaunchUrl(instagramUri)) {
        await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch Instagram",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.8),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not launch Instagram: $e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
