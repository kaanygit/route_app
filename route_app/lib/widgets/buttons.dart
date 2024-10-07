import 'package:flutter/material.dart';
import 'package:route_app/constants/style.dart';

enum ButtonWidth {
  small,
  medium,
  large,
  xLarge,
  xxLarge,
}

class MyButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonTextSize;
  final FontWeight buttonTextWeight;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;
  final ButtonWidth buttonWidth;
  final Color borderColor;

  const MyButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonTextSize,
    required this.buttonTextWeight,
    required this.onPressed,
    this.borderRadius = BorderRadius.zero,
    required this.buttonWidth,
    this.borderColor = Colors.grey,
  });
  double _getWidth(ButtonWidth width) {
    switch (width) {
      case ButtonWidth.small:
        return 100.0;
      case ButtonWidth.medium:
        return 150.0;
      case ButtonWidth.large:
        return 200.0;
      case ButtonWidth.xLarge:
        return 250.0;
      case ButtonWidth.xxLarge:
        return 300.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(buttonWidth),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          side: BorderSide(width: 0.3, color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          text,
          style: fontStyle(buttonTextSize, buttonTextColor, buttonTextWeight),
        ),
      ),
    );
  }
}
