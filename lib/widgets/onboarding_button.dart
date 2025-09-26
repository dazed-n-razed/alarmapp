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
    return Container(
      // Fixed height of 76px for the button container.
      height: 76, 
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
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
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}