import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test1/shared/app_theme.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverFadeTransition(
            opacity: _fadeAnimation,
            sliver: SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildTeamSection(context),
                  const SizedBox(height: 24),
                  _buildMissionSection(context),
                  const SizedBox(height: 24),
                  _buildContactSection(context),
                  const SizedBox(height: 24),
                  _buildSocialMediaSection(context),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background pattern
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      backgroundBlendMode: BlendMode.overlay,
                      image: DecorationImage(
                        image: const AssetImage('assets/pattern.png'),
                        fit: BoxFit.cover,
                        opacity: 0.3,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.2),
                          BlendMode.dstATop,
                        ),
                        onError: (exception, stackTrace) {
                          // Fallback pattern if asset not found
                        },
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.sticky_note_2_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).AboutUs,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  "Our Team",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).WelcomeMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTeamMember(context,
                    name: "John Doe",
                    role: "Designer",
                    imageUrl: "https://randomuser.me/api/portraits/men/32.jpg"),
                const SizedBox(width: 24),
                _buildTeamMember(context,
                    name: "Jane Smith",
                    role: "Developer",
                    imageUrl:
                        "https://randomuser.me/api/portraits/women/44.jpg"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context, {
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: NetworkImage(imageUrl),
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback if image load fails
          },
          child: Center(
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey.shade400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          role,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).OurMission,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).OurMission,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Our goal is to help you organize your thoughts and ideas in a simple, secure way.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
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

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.contact_mail, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).ContactUs,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).QuestionsFeedback,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _sendEmail,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.hashtag,
                    color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  S.of(context).FollowUs,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialMediaButton(
                  context,
                  icon: const FaIcon(FontAwesomeIcons.facebook,
                      color: Colors.white),
                  label: S.of(context).Facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () {
                    _launchURL(
                        'https://www.facebook.com/profile.php?id=61563607514517');
                  },
                ),
                _buildSocialMediaButton(
                  context,
                  icon: const FaIcon(FontAwesomeIcons.twitter,
                      color: Colors.white),
                  label: S.of(context).Twitter,
                  color: const Color(0xFF1DA1F2),
                  onTap: () {
                    _launchURL('https://x.com/zemax_c4');
                  },
                ),
                _buildSocialMediaButton(
                  context,
                  icon: const FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.white),
                  label: S.of(context).Instagram,
                  color: const Color(0xFFE1306C),
                  onTap: () {
                    _launchURL('https://www.instagram.com/flutternexus/');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch $url",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zemax.c4@gmail.com',
      query: 'subject=Notes%20Recorder%20Feedback&body=Hi%20there,%0D%0A%0D%0A',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch email client",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

class SliverFadeTransition extends StatelessWidget {
  final Animation<double> opacity;
  final Widget sliver;

  const SliverFadeTransition({
    super.key,
    required this.opacity,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context) {
    return SliverOpacity(
      opacity: opacity.value,
      sliver: sliver,
    );
  }
}
