import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/outline_action_button.dart';
import 'package:flutter/widgets.dart'; // Ensure Icons.location_on_rounded is available

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // --- Dynamic Sizing Constants ---
  static const double _topMarginRatio = 78.0 / 800.0;
  static const double _imageHeight = 296.0;
  static const double _contentPadding = 16.0;
  // Spacing constants for the image
  static const double _imageTopSpacing = 70.0; 
  static const double _imageBottomSpacing = 500.0; // Tweak this value to change the gap between image and buttons.
  // NEW: Spacing constants for the buttons wrapper
  static const double _buttonTopPadding = 16.0; // Tweak this value to adjust the margin *above* the buttons.
  static const double _buttonBottomPadding = 75.0; // Tweak this value to adjust the margin *below* the buttons.

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: Column(
          children: [
            // --- Scrollable top content (Text and Image) ---
            Expanded(
              // Use LayoutBuilder to access the max height of the Expanded area
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: screenHeight * _topMarginRatio,
                      left: _contentPadding,
                      right: _contentPadding,
                      bottom: 0.0, // Ensures content is tight against button area
                    ),
                    child: ConstrainedBox(
                      // Constrain the content column to fill at least the viewable height
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Anchor content to the bottom of the constrained area
                        mainAxisAlignment: MainAxisAlignment.end, 
                        children: [
                          // --- Text Content Wrapper ---
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Welcome! Your Smart Travel Alarm",
                                type: AppTextType.heading,
                                customSize: 32.0,
                              ),
                              const SizedBox(height: 12),
                              AppText(
                                text: "Stay on schedule and enjoy every moment of your journey.",
                                type: AppTextType.paragraph,
                                customSize: 19.0,
                              ),
                            ],
                          ),
                          
                          // --- Image Spacing and Content (Tweakable) ---
                          // Tweak: Adjust _imageTopSpacing to change the gap above the image
                          const SizedBox(height: _imageTopSpacing),
                          
                          // --- Image (296px x 296px, Centered, Circle) ---
                          Center(
                            child: Container(
                              width: _imageHeight,
                              height: _imageHeight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(_imageHeight / 2),
                                child: Image.asset(
                                  "assets/images/image1.png",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF5200FF).withOpacity(0.3),
                                      alignment: Alignment.center,
                                      child: const AppText(
                                        text: "Image Error: image1.png",
                                        type: AppTextType.paragraph,
                                        customSize: 20.0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Tweak: Adjust _imageBottomSpacing to change the gap below the image (above the buttons)
                          const SizedBox(height: _imageBottomSpacing),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),

            // --- Buttons at bottom (Single Wrapper) ---
            Container(
              // This Container acts as the single wrapper for the two buttons.
              padding: const EdgeInsets.only(
                top: _buttonTopPadding,    // <-- Tweakable top margin
                left: _contentPadding,
                right: _contentPadding,
                // Using the new constant for tweakability
                bottom: _buttonBottomPadding, // <-- Tweakable bottom margin
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF0B0024),
                    const Color(0xFF0B0024).withOpacity(0.0),
                  ],
                  stops: const [0.7, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button 1: Outline Button
                  OutlineActionButton(
                    text: "Use Current Location",
                    onPressed: () {},
                    icon: Icons.location_on_rounded,
                    borderColor: Colors.white,
                    iconColor: Colors.white,
                    borderWidth: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    iconOnRight: true, 
                  ),
                  
                  const SizedBox(height: 8), // Gap between buttons
                  
                  // Button 2: Solid Button
                  OnboardingButton(
                    text: "Home",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
