import 'package:flutter/material.dart';
import 'package:visionscan/vision.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? radius;
  final TextStyle? style;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.radius,
    this.style,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.scale(48),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.colors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12)),
          elevation: 0,
        ),
        onPressed: () {
          if (!isLoading) onPressed!();
        },
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(textColor ?? AppTheme.colors.accentText)),
              )
            : Text(text, style: style?.copyWith(color: textColor ?? AppTheme.colors.accentText) ?? context.button.copyWith(color: textColor ?? AppTheme.colors.accentText)),
      ),
    );
  }
}
