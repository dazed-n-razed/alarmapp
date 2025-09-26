import 'package:flutter/material.dart';

// A custom, transparent button with an adjustable outline, text, and icon.
class OutlineActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final double borderWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final bool iconOnRight; // New property to control icon position

  const OutlineActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.borderWidth = 1.0,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.w400,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.iconOnRight = false, // Default to left
  }) : super(key: key);

  // Helper method to build the content Row based on icon position
  List<Widget> _buildRowChildren() {
    final iconWidget = (icon != null) 
        ? [
            const SizedBox(width: 8), 
            Icon(icon, size: 24.0, color: iconColor)
          ] 
        : <Widget>[];

    final textWidget = [
      Text( 
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize, 
          fontWeight: fontWeight, 
        ),
      ),
    ];

    if (iconOnRight) {
      return [...textWidget, ...iconWidget];
    } else {
      // Default (Icon on Left)
      return [...iconWidget, ...textWidget];
    }
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 64.0; 

    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: borderColor, width: borderWidth), 
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            foregroundColor: textColor,
            backgroundColor: Colors.transparent,
            padding: padding,
            minimumSize: const Size.fromHeight(buttonHeight),
            textStyle: const TextStyle(fontFamily: 'Poppins'),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildRowChildren(), // Use the dynamic children
          ),
        ),
      ),
    );
  }
}
