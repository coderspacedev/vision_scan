import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visionscan/extensions/app_router_navigation.dart';
import 'package:visionscan/navigation/routes.dart';
import 'package:visionscan/vision.dart';

class ScreenSelectPdf extends StatefulWidget {
  final String? title;

  const ScreenSelectPdf({super.key, required this.title});

  @override
  State<ScreenSelectPdf> createState() => _ScreenSelectPdfState();
}

class _ScreenSelectPdfState extends State<ScreenSelectPdf> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      appBar: AppAppBar(title: widget.title ?? 'Modify PDF', onBack: () => context.pop()),
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
                            onTap: pickSinglePdfFile,
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
                                      subtitle: Text(
                                        _getFileSize(selectedFile!),
                                        style: context.bodySmall.copyWith(color: AppTheme.colors.text.withAlpha(100)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.scale(16)),
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
    final isDisabled = selectedFile == null;

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
                text: context.localization?.action_continue ?? 'Continue',
                style: context.bodyBoldMedium,
                textColor: AppTheme.colors.accentText,
                onPressed: isDisabled
                    ? null
                    : () {
                        context.navigateToObject(
                          widget.title == context.localization?.tool_reorder_pdf ? Routes.reorderPdfPages : Routes.removePdfPages,
                          {"selectedFile": selectedFile},
                        );
                      },
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

  void showMessage(String title, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(message ?? '', style: context.bodyMedium.copyWith(color: Colors.white)),
      backgroundColor: Colors.black54,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
