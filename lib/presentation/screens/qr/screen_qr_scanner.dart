import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/presentation/screens/qr/screen_result.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:visionscan/vision.dart';

class ScreenQRScanner extends StatefulWidget {
  const ScreenQRScanner({super.key});

  @override
  State<ScreenQRScanner> createState() => _ScreenQRScannerState();
}

class _ScreenQRScannerState extends State<ScreenQRScanner> {
  final MobileScannerController controller = MobileScannerController();
  bool isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    final scanSize = context.scale(250);
    final scanWindow = Rect.fromCenter(center: MediaQuery.sizeOf(context).center(const Offset(0, -100)), width: scanSize, height: scanSize);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildScanner(scanSize, scanWindow, context: context),
          _buildScannerBox(scanSize, context: context),
          _buildAppBar(context: context),
        ],
      ),
    );
  }

  _buildScanner(double scanSize, Rect scanWindow, {required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.scale(0)),
      child: Stack(
        children: [
          MobileScanner(
            controller: controller,
            scanWindow: scanWindow,
            useAppLifecycleState: true,
            errorBuilder: (context, error) {
              return Center(
                child: SizedBox(
                  width: scanSize * 0.8,
                  height: scanSize * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: colorAccentText, size: context.scale(32)),
                        SizedBox(height: context.scale(12)),
                        Text(
                          'Camera error: $error',
                          style: context.bodySmall.copyWith(color: colorAccentText),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            onDetect: (result) {
              final barcode = result.barcodes.first;
              final value = barcode.rawValue;
              if (value != null) {
                debugPrint('✅ Scanned: $value');
                controller.stop();
                Get.off(ScreenResult(qrContent: value));
              }
            },
          ),
          Positioned.fill(child: CustomPaint(painter: ScannerOverlayPainter(scanSize))),
        ],
      ),
    );
  }

  _buildScannerBox(double scanSize, {required BuildContext context}) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: scanSize,
        height: scanSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: context.scale(2)),
          borderRadius: BorderRadius.circular(context.scale(12)),
        ),
      ),
    );
  }

  _buildAppBar({required BuildContext context}) {
    return AppAppBar(
      title: '',
      backgroundColor: Colors.transparent,
      onBack: () => Get.back(),
      iconColor: colorAccentText,
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
              color: colorAccentText,
              icon: Icon(isTorchOn ? Icons.flash_on_outlined : Icons.flash_off_rounded),
              iconSize: context.scale(20),
              onPressed: () {
                setState(() {
                  isTorchOn = !isTorchOn;
                });
                controller.toggleTorch();
              },
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            );
          },
        ),
        IconButton(
          color: colorAccentText,
          iconSize: context.scale(20),
          icon: Icon(Icons.info_outline_rounded, color: colorAccentText),
          padding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            viewGuide(context: context);
          },
        ),
      ],
    );
  }

  viewGuide({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.scale(8))),
        backgroundColor: colorCard,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.scale(420)),
          child: Padding(
            padding: EdgeInsets.all(context.scale(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.localization?.title_guide_qr_code ?? '', style: context.headline5),
                SizedBox(height: context.scale(12)),
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Align(alignment: Alignment.centerLeft, child: Lottie.asset('assets/animations/ic_guide_qr_scanner.json')),
                ),
                SizedBox(height: context.scale(24)),
                Text(context.localization?.body_guide_qr_code_1 ?? '', style: context.bodySmall),
                SizedBox(height: context.scale(8)),
                Text(context.localization?.body_guide_qr_code_2 ?? '', style: context.bodySmall),
                SizedBox(height: context.scale(8)),
                Text(context.localization?.body_guide_qr_code_3 ?? '', style: context.bodySmall),
                SizedBox(height: context.scale(8)),
                Text(context.localization?.body_guide_qr_code_4 ?? '', style: context.bodySmall),
                SizedBox(height: context.scale(8)),
                Text(context.localization?.body_guide_qr_code_5 ?? '', style: context.bodySmall),
                SizedBox(height: context.scale(12)),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    height: context.scale(36),
                    text: context.localization?.action_guide_qr_code ?? '',
                    style: context.bodyBoldMedium.copyWith(color: colorAccentText),
                    radius: context.scale(8),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
