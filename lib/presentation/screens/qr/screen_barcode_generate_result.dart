import 'dart:io';
import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visionscan/vision.dart';

class ScreenBarCodeGenerateResult extends StatefulWidget {
  final String barContent;
  final String type;

  const ScreenBarCodeGenerateResult({super.key, required this.barContent, required this.type});

  @override
  State<ScreenBarCodeGenerateResult> createState() => _ScreenBarCodeGenerateResultState();
}

class _ScreenBarCodeGenerateResultState extends State<ScreenBarCodeGenerateResult> {
  final GlobalKey _barcodeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertScanCodeHistory(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final barcode = getBarcodeByType(context, widget.type);
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: '', onBack: () => Get.back()),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.scale(24)),
            child: AppContainer(
              padding: EdgeInsets.all(context.scale(4)),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.scale(12)),
                child: RepaintBoundary(
                  key: _barcodeKey,
                  child: AppContainer(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.scale(12)),
                    decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(context.scale(12))),
                    child: BarcodeWidget(barcode: barcode, data: widget.barContent, width: double.infinity, height: 100, drawText: true),
                  ),
                ),
              ),
            ),
          ),
          AppContainer(
            height: context.scale(1),
            margin: EdgeInsets.symmetric(horizontal: context.scale(24)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(context.scale(24), context.scale(24), context.scale(24), context.paddingBottom + context.scale(12)),
            child: AppButton(width: double.infinity, text: context.localization?.action_save ?? '', onPressed: _saveQrImage),
          ),
        ],
      ),
    );
  }

  void showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? '', style: context.bodyMediumLarge),
        backgroundColor: colorCard,
      ),
    );
  }

  Future<void> _saveQrImage() async {
    try {
      await Permission.photos.request();
      final boundary = _barcodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null) {
        final dir = await getTemporaryDirectory();
        final file = await File('${dir.path}/bar_code.png').writeAsBytes(pngBytes);
        final success = await GallerySaver.saveImage(file.path, albumName: 'VisionScan');
        debugPrint(success == true ? "✅ Saved to gallery!" : "❌ Failed to save.");
        showMessage("✅ Saved to gallery!");
      }
    } catch (e) {
      debugPrint("❌ Error saving image: $e");
    }
  }

  Future<void> insertScanCodeHistory({required BuildContext context}) async {
    final database = await $FloorAppDatabase.databaseBuilder('qr_history.db').build();

    final dao = database.qrHistoryDao;
    await dao.insertHistory(
      QrHistory(
        qrContent: widget.barContent,
        type: widget.type,
        style: '',
        color: '',
        brushType: '',
        isCornered: false,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        historyType: 'generate',
      ),
    );
  }

  Barcode getBarcodeByType(BuildContext context, String type) {
    final loc = context.localization;
    if (type == loc?.label_bar_codebar) {
      return Barcode.codabar();
    } else if (type == loc?.label_bar_code39) {
      return Barcode.code39();
    } else if (type == loc?.label_bar_code93) {
      return Barcode.code93();
    } else if (type == loc?.label_bar_ean8) {
      return Barcode.ean8();
    } else if (type == loc?.label_bar_ean13) {
      return Barcode.ean13();
    } else if (type == loc?.label_bar_pdf417) {
      return Barcode.pdf417();
    } else if (type == loc?.label_bar_upca) {
      return Barcode.upcA();
    } else if (type == loc?.label_bar_itf) {
      return Barcode.itf();
    } else {
      return Barcode.code128();
    }
  }
}
