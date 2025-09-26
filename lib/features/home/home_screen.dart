import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';
import '../../widgets/onboarding_button.dart';
import '../../widgets/outline_action_button.dart';
import 'package:flutter/widgets.dart'; 
// Import the new alarm screen file
import 'home_alarm.dart'; 

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
  // Spacing constants for the image
  static const double _imageTopSpacing = 40.0; 
  // Spacing constants for the buttons wrapper
  static const double _buttonTopPadding = 16.0; 
  static const double _buttonBottomPadding = 75.0; 

  // --- State Variables for Functionality ---
  bool _isLoading = false; 

  // Helper method to display the result in a modal/pop-up window
  void _showResultDialog(BuildContext context, String title, String content, {VoidCallback? onOkPressed}) {
    // Define the accent color used for borders and buttons
    const Color accentColor = Color(0xFF5200FF);
    const Color darkBackgroundColor = Color(0xFF0B0024);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside during processing
      builder: (BuildContext context) {
        return AlertDialog(
          // --- MODERN UI ENHANCEMENTS ---
          // Use a dark background to match the app theme
          backgroundColor: darkBackgroundColor,
          // Add elevation for depth
          elevation: 10,
          // Add a colored border for a modern, distinct look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), 
            side: const BorderSide(
              color: accentColor, 
              width: 1.5,
            ),
          ),
          // -----------------------------
          
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
                  // Use the accent color for the text button
                  color: accentColor, 
                  fontWeight: FontWeight.bold
                )
              ),
              // Use the provided callback, or default to just closing the dialog
              onPressed: onOkPressed ?? () {
                Navigator.of(context).pop();
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

    // 1. Set loading state to disable the button
    setState(() {
      _isLoading = true;
    });
    
    _showResultDialog(context, "Processing...", "Searching for your current location...");

    try {
      // 2. Simulate asynchronous location retrieval (1.5 seconds)
      await Future.delayed(const Duration(milliseconds: 1500)); 
      
      // 3. Mock result (Updated to use City and Country)
      const String mockCity = "San Francisco";
      const String mockCountry = "United States"; 
      
      // 4. Close the 'Processing...' dialog
      Navigator.of(context, rootNavigator: true).pop();
      
      // --- SUCCESS: Define navigation action ---
      final VoidCallback navigateToAlarm = () {
        // 4a. Close the current dialog
        Navigator.of(context).pop(); 
        // 4b. Navigate to the HomeAlarmScreen, replacing the current route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeAlarmScreen()),
        );
      };

      // 5. Show the success dialog, passing the navigation callback
      _showResultDialog(
        context, 
        "Success!", 
        // Updated message format to use City and Country
        "Default Location Set:\nCity: $mockCity, Country: $mockCountry",
        onOkPressed: navigateToAlarm,
      );

    } catch (e) {
      // Handle potential errors
      print('Location fetch error: $e'); 
      // Close the 'Processing...' dialog and show the error
      Navigator.of(context, rootNavigator: true).pop();
      _showResultDialog(
        context, 
        "Error", 
        "Location Error: Failed to retrieve or set default location."
      );
      
    } finally {
      // 6. Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
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
        // The main column is fixed and uses Spacer to manage vertical distribution
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Text Content Wrapper (Fixed Position) ---
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
                    text: "Stay on schedule and enjoy every moment of your journey.",
                    type: AppTextType.paragraph,
                    customSize: 19.0,
                  ),
                ],
              ),
            ),
            
            // Tweak: Adjust _imageTopSpacing to change the gap above the image
            const SizedBox(height: _imageTopSpacing),
            
            // --- 2. Image (Fixed Position) ---
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

            // --- 3. Spacer to push the buttons to the bottom ---
            const Spacer(),

            // --- 4. Buttons at bottom (Fixed Position) ---
            Container(
              padding: EdgeInsets.only(
                top: _buttonTopPadding,
                left: _contentPadding,
                right: _contentPadding,
                bottom: _buttonBottomPadding, 
              ),
              decoration: BoxDecoration(
                // Gradient for the button area
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
                   // Button 1: Outline Button (Location Fetch)
                  OutlineActionButton(
                    text: _isLoading ? "Processing..." : "Use Current Location",
                    // The onPressed callback is correctly handled here to ensure the button is disabled while loading.
                    onPressed: _isLoading ? () {} : () => _getCurrentLocation(), 
                    icon: Icons.location_on_rounded,
                    borderColor: Colors.white,
                    iconColor: Colors.white,
                    borderWidth: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    iconOnRight: true, 
                  ),
                  
                  const SizedBox(height: 8), // Gap between buttons
                  
                  // Button 2: Solid Button (Navigation)
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
