import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen_dashboard.dart';
import 'package:visionscan/vision.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    goto();
  }

  Future<void> goto() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Get.offAll(const ScreenDashboard());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: context.paddingTop + context.scale(12),
            left: context.scale(12),
            right: context.scale(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.localization?.app_name ?? '',
                  style: context.baseTextStyle(32, fontWeight: FontWeight.w900, lineHeight: 1.2, color: colorAccent),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.scale(4)),
                Text(context.localization?.app_slogan ?? '', style: context.bodyMedium),
                SizedBox(height: context.scale(36)),
                Center(
                  child: SizedBox(
                    width: context.scale(200),
                    height: context.scale(4),
                    child: LinearProgressIndicator(color: colorAccent, backgroundColor: colorText.withAlpha(10), minHeight: context.scale(3)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
