import 'dart:io';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' show PdfDocument, PdfPageSettings;
import 'package:path_provider/path_provider.dart';

Future<File> mergePDFs(List<File> files, {String outputName = 'merged_output'}) async {
  final PdfDocument mergedDoc = PdfDocument();

  for (final file in files) {
    final bytes = await file.readAsBytes();
    final PdfDocument doc = PdfDocument(inputBytes: bytes);
    for (int i = 0; i < doc.pages.count; i++) {
      final originalPage = doc.pages[i];
      final template = originalPage.createTemplate();
      final originalSize = Size(template.size.width, template.size.height);

      mergedDoc.pageSettings = PdfPageSettings(originalSize);
      final newPage = mergedDoc.pages.add();
      newPage.graphics.drawPdfTemplate(template, Offset.zero, originalSize);
    }

    doc.dispose();
  }

  final dir = await getApplicationDocumentsDirectory();
  final outputFile = File('${dir.path}/${outputName}_${DateTime.now()}.pdf');
  await outputFile.writeAsBytes(await mergedDoc.save());
  mergedDoc.dispose();
  return outputFile;
}

Future<List<File>> splitPDFWithRemaining(File file, {required List<int> selectedPages, String outputPrefix = 'split_page'}) async {
  final List<File> outputFiles = [];
  final bytes = await file.readAsBytes();
  final PdfDocument document = PdfDocument(inputBytes: bytes);
  final dir = await getApplicationDocumentsDirectory();

  final totalPages = document.pages.count;
  final selectedSet = selectedPages.toSet();

  // 1. Create PDF with selected pages (one file per page)
  for (final i in selectedSet) {
    if (i > 0 && i <= totalPages) {
      final singlePageDoc = PdfDocument();
      final template = document.pages[i - 1].createTemplate();
      singlePageDoc.pages.add().graphics.drawPdfTemplate(template, Offset.zero, Size(template.size.width, template.size.height));

      final output = File('${dir.path}/${outputPrefix}_only_page_$i.pdf');
      await output.writeAsBytes(await singlePageDoc.save());
      outputFiles.add(output);
      singlePageDoc.dispose();
    }
  }

  // 2. Create one PDF with remaining pages
  final remainingPages = List.generate(totalPages, (index) => index + 1).where((p) => !selectedSet.contains(p)).toList();
  if (remainingPages.isNotEmpty) {
    final remainingDoc = PdfDocument();
    for (final i in remainingPages) {
      final template = document.pages[i - 1].createTemplate();
      remainingDoc.pages.add().graphics.drawPdfTemplate(template, Offset.zero, Size(template.size.width, template.size.height));
    }

    final remainingOutput = File('${dir.path}/${outputPrefix}_remaining.pdf');
    await remainingOutput.writeAsBytes(await remainingDoc.save());
    outputFiles.add(remainingOutput);
    remainingDoc.dispose();
  }

  document.dispose();
  return outputFiles;
}

Future<File> removePagesFromPdf({
  required File originalFile,
  required List<int> pagesToRemove,
  String outputName = 'pdf_without_removed_pages.pdf',
}) async {
  final bytes = await originalFile.readAsBytes();
  final PdfDocument document = PdfDocument(inputBytes: bytes);

  final sortedPages = pagesToRemove.toSet().where((p) => p > 0 && p <= document.pages.count).toList()..sort((a, b) => b.compareTo(a));

  for (final pageNum in sortedPages) {
    document.pages.removeAt(pageNum - 1);
  }

  final dir = await getTemporaryDirectory();
  final output = File('${dir.path}/$outputName');
  await output.writeAsBytes(await document.save());
  document.dispose();

  return output;
}

Future<File> reorderPdfPages({
  required File originalFile,
  required List<int> newOrder,
  String outputName = 'reordered',
}) async {
  final originalBytes = await originalFile.readAsBytes();
  final originalDoc = PdfDocument(inputBytes: originalBytes);
  final reorderedDoc = PdfDocument();

  for (final pageNum in newOrder) {
    if (pageNum < 1 || pageNum > originalDoc.pages.count) continue;
    final template = originalDoc.pages[pageNum - 1].createTemplate();
    reorderedDoc.pages.add().graphics.drawPdfTemplate(template, Offset.zero, Size(template.size.width, template.size.height));
  }

  final dir = await getTemporaryDirectory();
  final outputFile = File('${dir.path}/${outputName}_${DateTime.now()}.pdf');
  await outputFile.writeAsBytes(await reorderedDoc.save());

  originalDoc.dispose();
  reorderedDoc.dispose();
  return outputFile;
}
