import 'package:flutter/material.dart';

class OnboardingGif extends StatelessWidget {
  final String gifAsset;
  final double width;
  final double height;

  const OnboardingGif({
    Key? key,
    required this.gifAsset,
    this.width = 426,
    this.height = 321,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          gifAsset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
