import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:visionscan/vision.dart';

class ScreenMergePdfs extends StatefulWidget {
  const ScreenMergePdfs({super.key});

  @override
  State<ScreenMergePdfs> createState() => _ScreenMergePdfsState();
}

class _ScreenMergePdfsState extends State<ScreenMergePdfs> {
  List<File> selectedFiles = [];
  bool isMerging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: context.localization?.tool_merge_pdfs ?? 'Merge Pdfs', onBack: () => Get.back()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: isMerging ? null : pickMultiplePdfFiles,
                            child: AppContainer(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: colorAccent, width: context.scale(1)),
                                color: colorCard,
                                borderRadius: BorderRadius.circular(context.scale(12)),
                              ),
                              padding: EdgeInsets.all(context.scale(12)),
                              margin: EdgeInsets.all(context.scale(12)),
                              child: Column(
                                children: [
                                  Icon(Icons.add_circle_rounded, color: colorAccent, size: context.scale(56)),
                                  SizedBox(height: context.scale(12)),
                                  Text('Choose files', style: context.bodyBoldLarge),
                                  SizedBox(height: context.scale(4)),
                                  Text('Supported files: .Pdf', style: context.bodySmall),
                                ],
                              ),
                            ),
                          ),
                          if (selectedFiles.isNotEmpty)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: selectedFiles.length,
                              itemBuilder: (context, index) {
                                final file = selectedFiles[index];
                                final fileName = file.path.split('/').last;
                                final fileSize = _getFileSize(file);
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: context.scale(12)),
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
                                );
                              },
                            ),
                          if (_isContentShort(context)) _buildBottomButtons(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isContentShort(context)) _buildBottomButtons(),
            ],
          );
        },
      ),
    );
  }

  bool _isContentShort(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = context.scale(80);
    final totalHeight = (selectedFiles.length * itemHeight) + context.scale(240);
    return totalHeight < screenHeight;
  }

  Widget _buildBottomButtons() {
    final bool isDisabled = selectedFiles.isEmpty || isMerging;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scale(12)),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Cancel',
                backgroundColor: colorCard,
                textColor: colorCardText,
                style: context.bodyBoldMedium,
                onPressed: isDisabled
                    ? null
                    : () {
                        setState(() => selectedFiles.clear());
                      },
              ),
            ),
            SizedBox(width: context.scale(12)),
            Expanded(
              child: AppButton(
                text: 'Merge',
                isLoading: isMerging,
                style: context.bodyBoldMedium,
                textColor: colorAccentText,
                onPressed: isDisabled ? null : () => _handleMerge(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMerge() async {
    setState(() => isMerging = true);
    try {
      final result = await mergePDFs(selectedFiles);

      if (result.existsSync()) {
        showMessage('Success', 'PDF merged and saved at:\n${result.path}');
      } else {
        showMessage('Failed', 'Merging failed. File not saved.');
      }
    } catch (e) {
      showMessage('Error', 'Failed to merge: $e');
    } finally {
      setState(() => isMerging = false);
    }
  }

  void showMessage(String? title, String? message) {
    Get.snackbar(title ?? '', message ?? '', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> pickMultiplePdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
    if (result != null) {
      final files = result.paths.whereType<String>().map((e) => File(e)).toList();
      setState(() => selectedFiles = files);
    } else {
      print('No files selected');
    }
  }

  String _getFileSize(File file) {
    final sizeInBytes = file.lengthSync();
    final sizeInKB = sizeInBytes / 1024;
    return sizeInKB < 1024 ? "${sizeInKB.toStringAsFixed(1)} KB" : "${(sizeInKB / 1024).toStringAsFixed(1)} MB";
  }
}
