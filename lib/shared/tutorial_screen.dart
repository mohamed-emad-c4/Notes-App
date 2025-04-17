import 'package:flutter/material.dart';
import 'package:test1/shared/app_theme.dart';
import 'package:test1/shared_prefrence.dart';
import 'package:get/get.dart';
import 'package:test1/shared/double_tap_animation.dart';

class TutorialScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialScreen({super.key, required this.onComplete});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  List<TutorialPage> tutorialPages = [
    TutorialPage(
      title: "Welcome to Notes Recorder",
      description:
          "A secure place to store all your important notes and to-do lists.",
      icon: Icons.note_alt,
      color: AppTheme.primaryColor,
    ),
    TutorialPage(
      title: "Hidden Notes Feature",
      description:
          "Double-tap on 'Notes' title to access your secret notes, protected with a PIN code.",
      icon: Icons.lock_outline,
      color: Colors.green,
    ),
    TutorialPage(
      title: "Get Started",
      description: "Swipe, organize, and secure your notes with ease.",
      icon: Icons.check_circle_outline,
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: widget.onComplete,
                  child:
                      Text("Skip", style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _numPages,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(context, tutorialPages[index]);
                  },
                ),
              ),
              _buildPageIndicator(),
              _buildBottomButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (page.title == "Hidden Notes Feature") _buildHiddenNoteDemo(),
        ],
      ),
    );
  }

  Widget _buildHiddenNoteDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Double tap on 'Notes' to access hidden notes",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const DoubleTapAnimation(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text(
                  "PIN protected",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _numPages; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.4),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentPage > 0
              ? TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text("Back"),
                )
              : const SizedBox(width: 80),
          _currentPage < _numPages - 1
              ? ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Next"),
                )
              : ElevatedButton(
                  onPressed: widget.onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Get Started"),
                ),
        ],
      ),
    );
  }
}

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// Helper to show tutorial only once
class TutorialHelper {
  static Future<bool> shouldShowTutorial() async {
    final SharePrefrenceClass prefs = SharePrefrenceClass();
    final bool hasShownTutorial = await prefs.getVlue(
      key: 'has_shown_tutorial',
      defaultValue: false,
    );
    return !hasShownTutorial;
  }

  static Future<void> markTutorialShown() async {
    final SharePrefrenceClass prefs = SharePrefrenceClass();
    await prefs.saveValuebool(
      key: 'has_shown_tutorial',
      value: true,
    );
  }

  static void showTutorial(BuildContext context,
      {required VoidCallback onComplete}) {
    Get.to(
      TutorialScreen(onComplete: () {
        markTutorialShown();
        onComplete();
      }),
      fullscreenDialog: true,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }
}
