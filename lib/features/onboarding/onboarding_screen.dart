// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/onboarding_video.dart';
import '../../widgets/onboarding_gif.dart';
import '../../widgets/onboarding_indicator.dart';
import '../home/home_screen.dart';

// The main screen widget for the onboarding flow.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "video": "assets/videos/video1.mp4",
      "title": "Discover the world, one journey at a time.",
      "desc":
          "From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today."
    },
    {
      "video": "assets/videos/video2.mp4",
      "title": "Plan smarter, travel better.",
      "desc":
          "Organize your trips with ease and focus on what matters: creating memories."
    },
    {
      "gif": "assets/gifs/morning.gif",
      "title": "Adventure awaits you.",
      "desc": "Join millions of travelers who explore the world effortlessly with us."
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // Ratio constant for video height based on a total of 800.0 (429.0 / 800.0).
  static const double _videoHeightRatio = 0.53625;
  // Ratio constant for button top position (664px / 800px).
  static const double _buttonTopRatio = 0.83;
  // Button container height (76px).
  // ignore: unused_field
  static const double _buttonContainerHeight = 76.0;
  // Indicator height approximation (including small margins/gaps).
  static const double _indicatorHeight = 24.0;
  

  Widget _buildMedia(BuildContext context, int index) {
    final item = onboardingData[index];
    
    final double videoFrameHeight = MediaQuery.of(context).size.height * _videoHeightRatio;

    Widget mediaContent;
    if (item.containsKey("video")) {
      mediaContent = OnboardingVideo(
        videoAsset: item["video"]!,
        width: MediaQuery.of(context).size.width,
        height: videoFrameHeight,
      );
    } else if (item.containsKey("gif")) {
      mediaContent = OnboardingGif(
        gifAsset: item["gif"]!,
        width: MediaQuery.of(context).size.width,
        height: videoFrameHeight,
      );
    } else {
      mediaContent = const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: videoFrameHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: mediaContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double videoFrameHeight = screenHeight * _videoHeightRatio;

    final double buttonTopPosition = screenHeight * _buttonTopRatio;

    // Calculate the top of the indicator. It's positioned 10px + indicator_height above the button's start.
    final double indicatorTopPosition = buttonTopPosition - _indicatorHeight - 10; 

    return Scaffold(
      // FIX: Ensure Scaffold background is transparent if needed, 
      // but applying the gradient to the body Container is correct.
      backgroundColor: Colors.transparent, 
      body: Container(
        // The background gradient is applied to the entire screen.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF082257), 
              Color(0xFF0B0024), 
              
            ],
          ),
        ),
        child: Stack(
          children: [
            // 1. The video/gif media section.
            _buildMedia(context, _currentPage),
            
            // 2. The main text content area (Title/Desc).
            Positioned(
              top: videoFrameHeight, 
              left: 0,
              right: 0,
              // FIX: Set the bottom position based on the indicator's top position 
              // minus a safe margin (e.g., 24px bottom padding + a small buffer).
              // We'll constrain it to stop just above the indicator's top padding.
              bottom: screenHeight - indicatorTopPosition + 12, // +12px to resolve the overflow
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 24, // Padding below video
                  // No bottom padding here, as the Positioned bottom constraint handles the space above the indicator
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: onboardingData.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = onboardingData[index];
                          // Text widgets and Columns are transparent by default.
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: item["title"]!,
                                type: AppTextType.heading,
                              ),
                              const SizedBox(height: 16),
                              AppText(
                                text: item["desc"]!,
                                type: AppTextType.paragraph,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. The page indicator, positioned absolutely.
            Positioned(
              top: indicatorTopPosition, // Dynamically calculated position
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: OnboardingIndicator(
                  currentIndex: _currentPage,
                  itemCount: onboardingData.length,
                ),
              ),
            ),
            
            // 4. The navigation button, dynamically positioned by ratio.
            Positioned(
              top: buttonTopPosition, // Dynamically calculated 83% from the top
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OnboardingButton(
                  text: _currentPage == onboardingData.length - 1
                      ? "Get Started"
                      : "Next",
                  onPressed: _nextPage,
                ),
              ),
            ),

            // 5. The "Skip" button positioned at the top right.
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0), 
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}