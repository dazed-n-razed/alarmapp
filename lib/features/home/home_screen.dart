// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/app_text.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/outline_action_button.dart';

// Import the new alarm screen file
import 'home_alarm.dart'; // Corrected import to match the file path of HomeAlarmScreen

// Converted to StatefulWidget to handle location fetching and state management.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Dynamic Sizing Constants ---
  static const double _topMarginRatio = 78.0 / 800.0;
  static const double _imageHeight = 350.0;
  static const double _contentPadding = 16.0;

  // Spacing constants
  static const double _imageTopSpacing = 40.0;
  static const double _buttonTopPadding = 16.0;
  static const double _buttonBottomPadding = 75.0;

  // --- State Variables ---
  bool _isLoading = false;

  // Helper method to display the result in a modal/pop-up window
  // CHANGE: Now returns Future<bool?> to allow the caller to await the user's confirmation.
  Future<bool?> _showResultDialog(
    BuildContext context,
    String title,
    String content, {
    // We keep onOkPressed, but if null, we pop(true)
    VoidCallback? onOkPressed, 
  }) {
    const Color accentColor = Color(0xFF5200FF);
    const Color darkBackgroundColor = Color(0xFF0B0024);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: darkBackgroundColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: accentColor,
              width: 1.5,
            ),
          ),
          title: AppText(
            text: title,
            type: AppTextType.heading,
            customSize: 24.0,
            color: Colors.white,
          ),
          content: AppText(
            text: content,
            type: AppTextType.paragraph,
            customSize: 16.0,
            color: Colors.white70,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onOkPressed ??
                  () {
                    // When onOkPressed is null, close the dialog and return true
                    Navigator.of(context).pop(true);
                  },
            ),
          ],
        );
      },
    );
  }

  // Function to simulate fetching the current location asynchronously
  Future<void> _getCurrentLocation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // We do NOT need to await this dialog since it's immediately replaced.
    _showResultDialog(
      context,
      "Processing...",
      "Searching for your current location...",
      // NOTE: Passing a dummy function to onOkPressed here ensures it closes itself without returning a value
      onOkPressed: () {
        Navigator.of(context).pop();
      }
    );

    try {
      // 1. Simulate location retrieval delay
      await Future.delayed(const Duration(milliseconds: 1500));

      const String mockCity = "San Francisco";
      const String mockCountry = "United States";

      // 2. Close the 'Processing...' dialog
      // Use rootNavigator to ensure the busy dialog is closed regardless of context.
      Navigator.of(context, rootNavigator: true).pop(); 

      // 3. Show the success dialog and AWAIT its dismissal.
      // This ensures the current widget's context remains valid until the user confirms the dialog.
      final bool? confirmed = await _showResultDialog(
        context,
        "Success!",
        "Default Location Set:\nCity: $mockCity, Country: $mockCountry",
        onOkPressed: null, // Let the dialog handle its own close via pop(true)
      );
      
      // 4. If the user pressed OK and the widget is still mounted, navigate.
      // Since we awaited the pop, the context is safe for navigation now.
      if (confirmed == true) {
        _navigateToHomeAlarm('$mockCity, $mockCountry');
      }
      
    } catch (e) {
      print('Location fetch error: $e');
      // Close the 'Processing...' dialog (if it was still open) and show the error
      Navigator.of(context, rootNavigator: true).pop();
      _showResultDialog(
        context,
        "Error",
        "Location Error: Failed to retrieve or set default location.",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method to navigate to the HomeAlarmScreen
  void _navigateToHomeAlarm([String initialLocation = 'San Francisco, United States']) {
    // ESSENTIAL: Check if the widget is still mounted before attempting navigation.
    if (!mounted) return;

    // This handles navigation when the "Home" button is pressed 
    // AND after location success confirmation (now called from an awaited Future).
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeAlarmScreen(
          initialLocation: initialLocation,
          locationFetched: true,
        ),
      ),
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Text Content ---
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * _topMarginRatio,
                left: _contentPadding,
                right: _contentPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Welcome! Your Smart Travel Alarm",
                    type: AppTextType.heading,
                    customSize: 32.0,
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    text:
                        "Stay on schedule and enjoy every moment of your journey.",
                    type: AppTextType.paragraph,
                    customSize: 19.0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: _imageTopSpacing),

            // --- 2. Image ---
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

            const Spacer(),

            // --- 3. Buttons ---
            Container(
              padding: EdgeInsets.only(
                top: _buttonTopPadding,
                left: _contentPadding,
                right: _contentPadding,
                bottom: _buttonBottomPadding,
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
                  // Button 1: Location Fetch (Navigates upon success dialog confirmation)
                  OutlineActionButton(
                    text:
                        _isLoading ? "Processing..." : "Use Current Location",
                    // FIX: Pass an empty function '() {}' instead of 'null' 
                    // when loading, as OutlineActionButton expects a non-nullable VoidCallback.
                    onPressed:
                        _isLoading ? () {} : () => _getCurrentLocation(), 
                    icon: Icons.location_on_rounded,
                    borderColor: Colors.white,
                    iconColor: Colors.white,
                    borderWidth: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    iconOnRight: true,
                  ),
                  const SizedBox(height: 8),
                  // Button 2: Home (Navigates directly to the HomeAlarmScreen)
                  OnboardingButton(
                    text: "Home",
                    onPressed: _navigateToHomeAlarm, 
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
