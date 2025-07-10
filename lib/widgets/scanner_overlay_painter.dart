import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double boxSize;

  ScannerOverlayPainter(this.boxSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(100);
    final rect = Offset.zero & size;
    final hole = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: boxSize, height: boxSize);
    canvas.drawPath(Path.combine(PathOperation.difference, Path()..addRect(rect), Path()..addRRect(RRect.fromRectXY(hole, 12, 12))), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
