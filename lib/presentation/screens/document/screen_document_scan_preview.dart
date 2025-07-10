import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:visionscan/extensions/app_styles.dart';
import 'package:visionscan/extensions/context.dart';
import 'package:visionscan/extensions/screen_size.dart';

import '../../../extensions/app_colors.dart';
import '../../../widgets/app_bar.dart';

class ScreenDocumentScanPreview extends StatefulWidget {
  final String? scannedDocuments;
  final bool isScanned;

  const ScreenDocumentScanPreview({super.key, required this.scannedDocuments, required this.isScanned});

  @override
  State<ScreenDocumentScanPreview> createState() => _ScreenDocumentScanPreviewState();
}

class _ScreenDocumentScanPreviewState extends State<ScreenDocumentScanPreview> {
  String? scannedDocuments;

  @override
  void initState() {
    super.initState();
    scannedDocuments = widget.scannedDocuments;
  }

  Future<void> saveToFilesApp(BuildContext context, String? pdfFile) async {
    try {
      assert(File(pdfFile!).existsSync());
      final result = await FileSaver.instance.saveFile(
        name: 'scanned_document_${DateTime.now().millisecondsSinceEpoch}',
        filePath: pdfFile,
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );
      if (result.isNotEmpty) {
        showMessage('✅ Saved successfully to Files');
      } else {
        showMessage('⚠️ Save failed or canceled');
      }
    } catch (e) {
      showMessage('❌ Error saving file: $e');
    }
  }

  void showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? '', style: context.bodyMediumLarge),
        backgroundColor: colorCard,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = File(scannedDocuments ?? '');
    final isValidPdf = scannedDocuments != null && file.existsSync() && file.lengthSync() > 0;

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(
        title: context.localization?.title_preview ?? '',
        icon: Icons.close_rounded,
        onBack: () => Get.back(),
        actions: [
          if (widget.isScanned)
            IconButton(
              color: colorAccentText,
              iconSize: context.scale(20),
              icon: Icon(Icons.check_rounded, color: colorAccent),
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (scannedDocuments != null) {
                  saveToFilesApp(context, scannedDocuments);
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(context.scale(16)),
        child: Column(
          children: [
            if (isValidPdf)
              Expanded(
                child: SfPdfViewerTheme(
                  data: SfPdfViewerThemeData(backgroundColor: colorBackground),
                  child: SfPdfViewer.file(
                    File(scannedDocuments ?? ''),
                    enableDoubleTapZooming: true,
                    enableDocumentLinkAnnotation: true,
                    pageSpacing: context.scale(12),
                  ),
                ),
              )
            else
              Expanded(child: Center(child: Text('Invalid or missing PDF'))),
          ],
        ),
      ),
    );
  }
}
