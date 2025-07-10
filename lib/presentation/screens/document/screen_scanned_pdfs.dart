import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visionscan/extensions/app_styles.dart';
import 'package:visionscan/extensions/screen_size.dart';

import '../../../extensions/app_colors.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_container.dart';
import '../document/screen_document_scan_preview.dart';

class ScreenScannedPdfs extends StatefulWidget {
  const ScreenScannedPdfs({super.key});

  @override
  State<ScreenScannedPdfs> createState() => _ScreenScannedPdfsState();
}

class _ScreenScannedPdfsState extends State<ScreenScannedPdfs> {
  List<FileSystemEntity> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    final pdfs = files.where((file) => file.path.endsWith('.pdf')).toList();

    setState(() {
      pdfFiles = pdfs;
    });
  }

  String _getFileSize(File file) {
    final sizeInBytes = file.lengthSync();
    final sizeInKB = sizeInBytes / 1024;
    return sizeInKB < 1024 ? "${sizeInKB.toStringAsFixed(1)} KB" : "${(sizeInKB / 1024).toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: 'Scanned Docs', onBack: () => Get.back()),
      body: pdfFiles.isEmpty
          ? Center(child: Text("No PDF files found", style: context.bodyBoldMedium))
          : ListView.separated(
              itemCount: pdfFiles.length,
              separatorBuilder: (context, index) =>
                  Divider(color: colorText.withAlpha(20), thickness: 0.5, indent: context.scale(16), endIndent: context.scale(16)),
              itemBuilder: (context, index) {
                final file = File(pdfFiles[index].path);
                final fileName = file.path.split('/').last;
                final fileSize = _getFileSize(file);
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(0)),
                  leading: AppContainer(
                    color: Colors.redAccent,
                    padding: EdgeInsets.all(context.scale(12)),
                    child: SvgPicture.asset(
                      'assets/icons/ic_placeholder_pdf.svg',
                      width: context.scale(24),
                      height: context.scale(24),
                      colorFilter: ColorFilter.mode(colorAccentText, BlendMode.srcIn),
                    ),
                  ),
                  title: Text(fileName, style: context.bodyBoldMedium, overflow: TextOverflow.ellipsis),
                  subtitle: Text(fileSize, style: context.bodySmall.copyWith(color: colorText.withAlpha(100))),
                  trailing: PopupMenuButton<String>(
                    surfaceTintColor: colorCard,
                    color: colorCard,
                    onSelected: (value) async {
                      if (value == 'delete') {
                        file.deleteSync();
                        _loadPdfFiles();
                      } else if (value == 'share') {
                        final params = ShareParams(text: '', files: [XFile(file.path)]);
                        final result = await SharePlus.instance.share(params);
                        if (result.status == ShareResultStatus.success) {
                          print('Thank you for sharing the picture!');
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'share',
                        child: Text('Share', style: context.bodyMedium),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: context.bodyMedium),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(ScreenDocumentScanPreview(scannedDocuments: pdfFiles[index].path, isScanned: false));
                  },
                );
              },
            ),
    );
  }
}
