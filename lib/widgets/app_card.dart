import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? radius;
  final Color? color;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.margin, this.padding, this.radius, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? colorCard,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 12.r),
        child: Padding(padding: padding ?? EdgeInsets.all(12.sp), child: child),
      ),
    );
  }
}
