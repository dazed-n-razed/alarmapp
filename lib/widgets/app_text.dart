// lib/common_widgets/app_text.dart
import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

enum AppTextType { heading, paragraph }

class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final TextAlign textAlign;

  const AppText({
    Key? key,
    required this.text,
    this.type = AppTextType.paragraph,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (type) {
      case AppTextType.heading:
        style = TextStyles.heading;
        break;
      case AppTextType.paragraph:
        style = TextStyles.paragraph;
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
