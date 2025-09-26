import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

enum AppTextType { heading, paragraph }

class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final TextAlign textAlign;
  final double? customSize; 
  // ADDED: The optional color parameter
  final Color? color; 

  const AppText({
    Key? key,
    required this.text,
    this.type = AppTextType.paragraph,
    this.textAlign = TextAlign.start,
    this.customSize, 
    this.color, // ADDED: color to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    // 1. Determine the base style
    switch (type) {
      case AppTextType.heading:
        style = TextStyles.heading;
        break;
      case AppTextType.paragraph:
        style = TextStyles.paragraph;
    }

    // 2. Override the font size if customSize is provided
    if (customSize != null) {
      style = style.copyWith(fontSize: customSize);
    }
    
    // 3. ADDED: Override the color if provided
    if (color != null) {
      style = style.copyWith(color: color);
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
