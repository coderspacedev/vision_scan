import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visionscan/extensions/app_router_navigation.dart';
import 'package:visionscan/extensions/pdf_utils.dart';
import 'package:visionscan/vision.dart';

import '../../../navigation/routes.dart';

class ScreenSavedPdfs extends StatefulWidget {
  const ScreenSavedPdfs({super.key});

  @override
  State<ScreenSavedPdfs> createState() => _ScreenSavedPdfsState();
}

class _ScreenSavedPdfsState extends State<ScreenSavedPdfs> {
  List<FileSystemEntity> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    final dir = await getAppVisionScanDirectory();
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
      backgroundColor: AppTheme.colors.background,
      appBar: AppAppBar(title: context.localization?.tool_saved_pdfs ?? 'Saved Pdfs', onBack: () => context.pop()),
      body: pdfFiles.isEmpty
          ? Center(child: Text("No PDF files found", style: context.bodyBoldMedium))
          : ListView.separated(
              itemCount: pdfFiles.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppTheme.colors.text.withAlpha(20), thickness: 0.5, indent: context.scale(16), endIndent: context.scale(16)),
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
                      colorFilter: ColorFilter.mode(AppTheme.colors.accentText, BlendMode.srcIn),
                    ),
                  ),
                  title: Text(fileName, style: context.bodyBoldMedium, overflow: TextOverflow.ellipsis),
                  subtitle: Text(fileSize, style: context.bodySmall.copyWith(color: AppTheme.colors.text.withAlpha(100))),
                  trailing: PopupMenuButton<String>(
                    color: AppTheme.colors.card,
                    surfaceTintColor: AppTheme.colors.card,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.scale(8))),
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
                    context.navigateToObject(Routes.pdfPreview, {"scannedDocuments": pdfFiles[index].path, "isScanned": false});
                  },
                );
              },
            ),
    );
  }
}
