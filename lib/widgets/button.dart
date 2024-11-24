import 'package:flutter/material.dart';

class SportsButton extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color foregroundColor;

  const SportsButton({
    Key? key,
    this.label,
    required this.onPressed,
    this.textStyle,
    this.width,
    this.height,
    this.backgroundColor = Colors.blue,
    this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: iconSize),
                  const SizedBox(width: 8),
                  Text(label ?? "",
                      style: textStyle ?? const TextStyle(fontSize: 16)),
                ],
              )
            : Text(label ?? "",
                style: textStyle ?? const TextStyle(fontSize: 16)),
      ),
    );
  }
}
