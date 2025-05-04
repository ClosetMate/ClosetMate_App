import 'package:closet_mate/config/theme/colors.dart';
import 'package:flutter/material.dart';

class InitialAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const InitialAvatar({
    super.key,
    required this.name,
    this.radius = 30,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    Color bg = backgroundColor ?? ColorConstants.appSpecificDark;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        initial,
        style: textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: radius * 0.8,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}