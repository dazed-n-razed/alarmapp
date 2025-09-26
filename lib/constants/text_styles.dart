// lib/constants/text_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class TextStyles {
  // Box 1: Heading
  static const TextStyle heading = TextStyle(
    fontFamily: 'Display',             // Figma font
    fontWeight: FontWeight.w500,       // Medium
    fontSize: 24,                      // Increased for better visibility
    height: 34 / 24,                   // Line height = 34px
    letterSpacing: 0,                  // 0%
    color: AppColors.white,
  );

  // Box 2: Paragraph
  static const TextStyle paragraph = TextStyle(
    fontFamily: 'Oxygen',
    fontWeight: FontWeight.w400,       // Regular
    fontSize: 14,                      // 14px
    height: 1.48,                      // 148% line height
    letterSpacing: 0,                  // 0%
    color: AppColors.white70,
  );
}
