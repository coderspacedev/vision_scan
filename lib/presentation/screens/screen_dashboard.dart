import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:visionscan/extensions/app_router_navigation.dart';
import 'package:visionscan/navigation/routes.dart';
import 'package:visionscan/vision.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      appBar: AppAppBar(title: context.localization?.app_name ?? '', isBack: false),
      body: Padding(
        padding: EdgeInsets.all(context.scale(24)),
        child: Column(
          children: [
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_document_scanner ?? '',
              onPressed: () {
                scanDoc();
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_qr_code_scanner ?? '',
              onPressed: () {
                context.navigateTo(Routes.qrDashboard);
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_merge_pdfs ?? '',
              onPressed: () {
                context.navigateTo(Routes.mergePdfs);
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_split_pdf ?? '',
              onPressed: () {
                context.navigateTo(Routes.splitPdfs);
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_reorder_pdf ?? '',
              onPressed: () {
                context.navigateToObject(Routes.selectPdf, {"title": context.localization?.tool_reorder_pdf ?? ""});
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_remove_page_pdf ?? '',
              onPressed: () {
                context.navigateToObject(Routes.selectPdf, {"title": context.localization?.tool_remove_page_pdf ?? ""});
              },
            ),
            SizedBox(width: double.infinity, height: context.scale(12)),
            AppButton(
              width: double.infinity,
              backgroundColor: AppTheme.colors.card,
              textColor: AppTheme.colors.cardText,
              style: context.bodyBoldLarge,
              text: context.localization?.tool_saved_pdfs ?? '',
              onPressed: () {
                context.navigateTo(Routes.savedPdfs);
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

      if (scannedDocuments is Map && scannedDocuments['pdfUri'] != null) {
        // Extract PDF path
        final pdfUri = scannedDocuments['pdfUri'].toString();

        // Convert "file://..." URI to proper path
        final filePath = pdfUri.replaceFirst('file://', '');
        final file = File(filePath);

        if (await file.exists() && await file.length() > 0) {
          debugPrint('✅ Saved to: $filePath');

          if (mounted) {
            context.navigateToObject(
              Routes.pdfPreview,
              {
                "scannedDocuments": filePath,
                "pageCount": scannedDocuments['pageCount'] ?? 0,
                "isScanned": true,
              },
            );
          }
        } else {
          debugPrint('❌ Invalid scanned PDF file');
        }
      } else {
        debugPrint('❌ Unexpected response from scanner: $scannedDocuments');
      }
    } catch (e) {
      debugPrint('❌ Error scanning documents: $e');
    }

  }
}
