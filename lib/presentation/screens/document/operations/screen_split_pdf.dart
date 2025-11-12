import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:visionscan/vision.dart';

class ScreenSplitPdf extends StatefulWidget {
  const ScreenSplitPdf({super.key});

  @override
  State<ScreenSplitPdf> createState() => _ScreenSplitPdfState();
}

class _ScreenSplitPdfState extends State<ScreenSplitPdf> {
  File? selectedFile;
  bool isSplitting = false;
  TextEditingController rangeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      appBar: AppAppBar(title: context.localization?.tool_split_pdf ?? 'Split PDF', onBack: () => context.pop()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: isSplitting ? null : pickSinglePdfFile,
                            child: AppContainer(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: AppTheme.colors.accent, width: context.scale(1)),
                                color: AppTheme.colors.card,
                                borderRadius: BorderRadius.circular(context.scale(12)),
                              ),
                              padding: EdgeInsets.all(context.scale(12)),
                              margin: EdgeInsets.all(context.scale(12)),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_action_upload_file.svg',
                                    width: context.scale(56),
                                    height: context.scale(56),
                                    colorFilter: ColorFilter.mode(AppTheme.colors.accent, BlendMode.srcIn),
                                  ),
                                  SizedBox(height: context.scale(12)),
                                  Text(context.localization?.label_choose_pdf_file ?? 'Choose PDF file', style: context.bodyBoldLarge),
                                  SizedBox(height: context.scale(4)),
                                  Text(context.localization?.body_supported_file ?? 'Supported file: .Pdf', style: context.bodySmall),
                                ],
                              ),
                            ),
                          ),
                          if (selectedFile != null)
                            Padding(
                              padding: EdgeInsets.all(context.scale(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppContainer(
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: context.scale(12)),
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
                                      title: Text(selectedFile!.path.split('/').last, style: context.bodyBoldMedium, overflow: TextOverflow.ellipsis),
                                      subtitle: Text(_getFileSize(selectedFile!), style: context.bodySmall.copyWith(color: AppTheme.colors.text.withAlpha(100))),
                                    ),
                                  ),
                                  SizedBox(height: context.scale(16)),
                                  Text(context.localization?.body_split_note ?? 'Note: Split Range (e.g., 1-3,5):', style: context.bodyBoldMedium),
                                  SizedBox(height: context.scale(8)),
                                  AppTextField(
                                    controller: rangeController,
                                    hint: context.localization?.hint_split_box ?? 'Enter page ranges',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomButtons(),
            ],
          );
        },
      ),
    );
  }

  String _getFileSize(File file) {
    final sizeInBytes = file.lengthSync();
    final sizeInKB = sizeInBytes / 1024;
    return sizeInKB < 1024 ? "${sizeInKB.toStringAsFixed(1)} KB" : "${(sizeInKB / 1024).toStringAsFixed(1)} MB";
  }

  Widget _buildBottomButtons() {
    final isDisabled = selectedFile == null || isSplitting;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(12)),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.localization?.action_cancel ?? 'Cancel',
                backgroundColor: AppTheme.colors.card,
                textColor: AppTheme.colors.cardText,
                style: context.bodyBoldMedium,
                onPressed: isDisabled
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        setState(() => selectedFile = null);
                      },
              ),
            ),
            SizedBox(width: context.scale(12)),
            Expanded(
              child: AppButton(
                text: context.localization?.action_split ?? 'Split',
                isLoading: isSplitting,
                style: context.bodyBoldMedium,
                textColor: AppTheme.colors.accentText,
                onPressed: isDisabled ? null : () => _handleSplit(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickSinglePdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: false);
    if (result != null) {
      setState(() => selectedFile = File(result.files.single.path!));
    }
  }

  Future<void> _handleSplit() async {
    FocusScope.of(context).unfocus();
    setState(() => isSplitting = true);
    try {
      final ranges = _parseRanges(rangeController.text);
      final outputFiles = await splitPDFWithRemaining(selectedFile!, selectedPages: ranges);

      if (outputFiles.isNotEmpty) {
        showMessage('Success', 'Split completed. Files saved.');
      } else {
        showMessage('Failed', 'Split failed.');
      }
    } catch (e) {
      showMessage('Error', 'Split error: $e');
    } finally {
      setState(() => isSplitting = false);
    }
  }

  List<int> _parseRanges(String input) {
    final Set<int> pages = {};
    final parts = input.split(',');
    for (var part in parts) {
      if (part.contains('-')) {
        final split = part.split('-');
        final start = int.tryParse(split[0].trim()) ?? 0;
        final end = int.tryParse(split[1].trim()) ?? 0;
        pages.addAll(List.generate(end - start + 1, (i) => start + i));
      } else {
        final page = int.tryParse(part.trim());
        if (page != null) pages.add(page);
      }
    }
    return pages.toList()..sort();
  }

  void showMessage(String title, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(
        message ?? '',
        style: context.bodyMedium.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.black54,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
