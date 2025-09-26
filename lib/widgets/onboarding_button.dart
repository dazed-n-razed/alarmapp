// lib/widgets/onboarding_button.dart
import 'package:flutter/material.dart';
//import '../constants/colors.dart';

// A custom button for the onboarding screen.
class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OnboardingButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the desired total vertical space for the button and its surrounding margin.
    // Original total container height was 76px.
    const double increasedButtonHeight = 64.0; // Increased button height from 56px to 64px

    return Container(
      // The container's height is now adjusted to fit the new button size + padding.
      height: increasedButtonHeight + 20.0, // e.g., 64 + 10 (top padding) + 10 (bottom padding) = 84.0
      // We are keeping the same vertical padding structure.
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        // FIX: Set the explicit height of the button using the increased value.
        height: increasedButtonHeight, 
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5200FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(69),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            elevation: 0,
            animationDuration: const Duration(milliseconds: 160),
            // OPTIONAL: If you want to be extremely explicit, uncomment the line below.
            // minimumSize: const Size.fromHeight(increasedButtonHeight),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
          ),
        ),
      ),
    );
  }
}