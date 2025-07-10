import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visionscan/extensions/screen_size.dart';

import '../extensions/app_colors.dart';
import '../extensions/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
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
          backgroundColor: backgroundColor ?? colorAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12.r)),
          elevation: 0,
        ),
        onPressed: () {
          if (!isLoading) onPressed();
        },
        child: isLoading
            ? SizedBox(
                width: 20.sp,
                height: 20.sp,
                child: CircularProgressIndicator(strokeWidth: 2.sp, valueColor: AlwaysStoppedAnimation<Color>(textColor ?? colorAccentText)),
              )
            : Text(text, style: style ?? context.button.copyWith(color: textColor ?? colorAccentText)),
      ),
    );
  }
}
