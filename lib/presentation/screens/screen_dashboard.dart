import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:visionscan/vision.dart';

import 'document/operations/screen_merge_pdfs.dart';
import 'document/operations/screen_select_pdf.dart';
import 'document/screen_document_scan_preview.dart';
import 'document/screen_scanned_pdfs.dart';
import 'document/operations/screen_split_pdf.dart';
import 'qr/screen_qr_dashboard.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: context.localization?.app_name ?? '', isBack: false),
      body: Padding(
        padding: EdgeInsets.all(context.scale(16)),
        child: Column(
          children: [
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_document_scanner ?? '',
              onPressed: () {
                scanDoc();
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_qr_code_scanner ?? '',
              onPressed: () {
                Get.to(ScreenQRDashboard());
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_scanned_pdfs ?? '',
              onPressed: () {
                Get.to(ScreenScannedPdfs());
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_merge_pdfs ?? '',
              onPressed: () {
                Get.to(ScreenMergePdfs());
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_split_pdf ?? '',
              onPressed: () {
                Get.to(ScreenSplitPdf());
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_reorder_pdf ?? '',
              onPressed: () {
                Get.to(ScreenSelectPdf(title: context.localization?.tool_reorder_pdf));
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: colorCard,
              textColor: colorCardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_remove_page_pdf ?? '',
              onPressed: () {
                Get.to(ScreenSelectPdf(title: context.localization?.tool_remove_page_pdf));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanDoc() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await FlutterDocScanner().getScannedDocumentAsPdf();
      final file = File(scannedDocuments);
      if (await file.exists() && await file.length() > 0) {
        debugPrint('✅ Saved to: $scannedDocuments');
        Get.to(ScreenDocumentScanPreview(scannedDocuments: scannedDocuments, isScanned: true));
      } else {
        debugPrint('❌ Invalid scanned PDF');
      }
    } catch (e) {
      debugPrint('❌ Error scanning documents: $e');
    }
  }
}
