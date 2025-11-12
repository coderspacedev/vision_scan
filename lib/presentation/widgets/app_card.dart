import 'package:visionscan/vision.dart';
import 'package:flutter/material.dart';

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
      color: color ?? AppTheme.colors.card,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 12),
        child: Padding(padding: padding ?? EdgeInsets.all(12), child: child),
      ),
    );
  }
}
