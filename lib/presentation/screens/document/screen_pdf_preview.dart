import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:visionscan/vision.dart';

class ScreenPdfPreview extends StatefulWidget {
  final String? scannedDocument;
  final bool isScanned;

  const ScreenPdfPreview({super.key, required this.scannedDocument, required this.isScanned});

  @override
  State<ScreenPdfPreview> createState() => _ScreenPdfPreviewState();
}

class _ScreenPdfPreviewState extends State<ScreenPdfPreview> {
  String? scannedDocument;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey<SfPdfViewerState>();
  late PdfViewerController _pdfController;
  final UndoHistoryController _undoController = UndoHistoryController();
  List<Annotation> _annotations = [];

  @override
  void initState() {
    super.initState();
    scannedDocument = widget.scannedDocument;
    _pdfController = PdfViewerController();
    _undoController.addListener(() {
      debugPrint('Undo available: ${_undoController.value.canUndo}, Redo available: ${_undoController.value.canRedo}');
      setState(() {});
    });
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
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(message ?? '', style: context.bodyMedium.copyWith(color: Colors.white)),
      backgroundColor: Colors.black54,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onAnnotationAdded(Annotation annotation) {
    setState(() {
      _annotations.add(annotation);
    });
    debugPrint('Annotation added: ${annotation.runtimeType}');
  }

  void _onAnnotationRemoved(Annotation annotation) {
    setState(() {
      _annotations.remove(annotation);
    });
    debugPrint('Annotation removed: ${annotation.runtimeType}');
  }

  @override
  void dispose() {
    _undoController.removeListener(() {});
    _undoController.dispose();
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(scannedDocument ?? '');
    final isValidPdf = scannedDocument != null && file.existsSync() && file.lengthSync() > 0;

    return Scaffold(
      backgroundColor: AppTheme.colors.primary,
      appBar: AppAppBar(
        title: context.localization?.title_preview ?? '',
        icon: Icons.close_rounded,
        backgroundColor: AppTheme.colors.accent,
        textColor: AppTheme.colors.accentText,
        iconColor: AppTheme.colors.accentText,
        forceMaterialTransparency: false,
        onBack: () => context.pop(),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: AppTheme.colors.accentText),
            onPressed: _undoController.value.canUndo ? _undoController.undo : null,
          ),
          IconButton(
            icon: Icon(Icons.redo, color: AppTheme.colors.accentText),
            onPressed: _undoController.value.canRedo ? _undoController.redo : null,
          ),
          if (widget.isScanned)
            IconButton(
              color: AppTheme.colors.accentText,
              iconSize: context.scale(24),
              icon: Icon(Icons.check_rounded, color: AppTheme.colors.accent, size: context.scale(24)),
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (scannedDocument != null) {
                  saveToFilesApp(context, scannedDocument);
                }
              },
            ),
          if (!widget.isScanned)
            IconButton(
              icon: Icon(Icons.save, color: AppTheme.colors.accentText),
              onPressed: () async {
                try {
                  // 1. Export PDF bytes from viewer
                  final List<int> bytes = await _pdfController.saveDocument();

                  // 2. Overwrite the same file
                  if (scannedDocument != null) {
                    final file = File(scannedDocument ?? '');
                    await file.writeAsBytes(bytes, flush: true);
                  }

                  showMessage('✅ Changes saved to existing PDF');
                } catch (e) {
                  showMessage('❌ Failed to save PDF: $e');
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
                  data: SfPdfViewerThemeData(backgroundColor: AppTheme.colors.background),
                  child: SfPdfViewer.file(
                    File(scannedDocument ?? ''),
                    key: _pdfViewerKey,
                    enableDoubleTapZooming: true,
                    enableDocumentLinkAnnotation: true,
                    canShowSignaturePadDialog: true,
                    enableHyperlinkNavigation: true,
                    undoController: _undoController,
                    pageSpacing: context.scale(12),
                    canShowPaginationDialog: true,
                    canShowScrollStatus: true,
                    canShowPasswordDialog: true,
                    onAnnotationAdded: _onAnnotationAdded,
                    onAnnotationRemoved: _onAnnotationRemoved,
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
