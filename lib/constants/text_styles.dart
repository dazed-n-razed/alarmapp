// lib/constants/text_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class TextStyles {
     // Box 1: Heading - Updated to Poppins, 11px, 16px line-height, 400 weight
  static const TextStyle heading = TextStyle(
    fontFamily: 'Poppins',            // Font family: Poppins
    fontWeight: FontWeight.w400,      // Font weight: 400 (Regular)
    fontSize: 11.0,                   // Font size: 11px
    height: 16 / 11,                  // Line height: 16px
    letterSpacing: 0,                 // Letter spacing: normal
    color: AppColors.white,           // Retaining original color
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
