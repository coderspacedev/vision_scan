import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:visionscan/vision.dart';

class ScreenRemovePdfPages extends StatefulWidget {
  final File? selectedFile;

  const ScreenRemovePdfPages({super.key, required this.selectedFile});

  @override
  State<ScreenRemovePdfPages> createState() => _ScreenRemovePdfPagesState();
}

class _ScreenRemovePdfPagesState extends State<ScreenRemovePdfPages> {
  File? selectedFile;
  List<Uint8List> pageImages = [];
  List<int> pagesToRemove = [];

  final List<_RemoveAction> _undoStack = [];
  final List<_RemoveAction> _redoStack = [];

  bool isLoading = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    selectedFile = widget.selectedFile;
    setupPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(
        title: context.localization?.tool_remove_page_pdf ?? 'Remove PDF',
        onBack: () => Get.back(),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: _undoStack.isNotEmpty ? _handleUndo : null),
          IconButton(icon: const Icon(Icons.redo), onPressed: _redoStack.isNotEmpty ? _handleRedo : null),
        ],
      ),
      body: isProcessing
          ? Center(
              child: SizedBox(
                width: context.scale(24),
                height: context.scale(24),
                child: CircularProgressIndicator(color: colorAccent, strokeWidth: context.scale(2)),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scale(12)),
                    child: GridView.builder(
                      itemCount: pageImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: context.scale(12),
                        crossAxisSpacing: context.scale(12),
                        childAspectRatio: context.scale(100) / context.scale(140),
                      ),
                      itemBuilder: (context, index) {
                        final img = pageImages[index];
                        return _buildThumbnail(img, onRemove: () => _removePage(index));
                      },
                    ),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
    );
  }

  void _removePage(int index) {
    final removedImage = pageImages[index];
    setState(() {
      pagesToRemove.add(index + 1);
      _undoStack.add(_RemoveAction(index, removedImage));
      _redoStack.clear();
      pageImages.removeAt(index);
    });
  }

  void _handleUndo() {
    if (_undoStack.isEmpty) return;
    final lastAction = _undoStack.removeLast();
    setState(() {
      pageImages.insert(lastAction.index, lastAction.image);
      pagesToRemove.remove(lastAction.index + 1);
      _redoStack.add(lastAction);
    });
  }

  void _handleRedo() {
    if (_redoStack.isEmpty) return;
    final redoAction = _redoStack.removeLast();
    setState(() {
      pageImages.removeAt(redoAction.index);
      pagesToRemove.add(redoAction.index + 1);
      _undoStack.add(redoAction);
    });
  }

  Widget _buildThumbnail(Uint8List img, {Color borderColor = Colors.grey, VoidCallback? onRemove}) {
    return Stack(
      children: [
        Center(
          child: AppContainer(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: context.scale(1)),
              borderRadius: BorderRadius.circular(context.scale(0)),
              color: colorCard,
            ),
            child: Image.memory(img, fit: BoxFit.contain),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: context.scale(4),
            right: context.scale(4),
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withAlpha(125), shape: BoxShape.circle),
                padding: EdgeInsets.all(context.scale(4)),
                child: Icon(Icons.close, size: context.scale(16), color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final isDisabled = pageImages.isEmpty || isLoading;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(12)),
        child: AppButton(
          width: double.infinity,
          text: context.localization?.action_remove_pages ?? 'Remove Pages',
          isLoading: isLoading,
          style: context.bodyBoldMedium,
          textColor: colorAccentText,
          onPressed: isDisabled ? null : _handleRemove,
        ),
      ),
    );
  }

  Future<void> _handleRemove() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    try {
      final outputFile = await removePagesFromPdf(originalFile: selectedFile!, pagesToRemove: pagesToRemove);

      if (outputFile.existsSync()) {
        showMessage('Success', 'Remove page completed. Files saved.');
      } else {
        showMessage('Failed', 'Remove page failed.');
      }
    } catch (e) {
      showMessage('Error', 'Remove page error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> setupPages() async {
    setState(() {
      isProcessing = true;
    });
    final images = await getPageImages(selectedFile!);
    setState(() {
      pageImages = images;
      pagesToRemove = [];
      _undoStack.clear();
      _redoStack.clear();
      isProcessing = false;
      isLoading = false;
    });
  }

  Future<List<Uint8List>> getPageImages(File file) async {
    final doc = await PdfDocument.openFile(file.path);
    final List<Uint8List> images = [];

    for (int i = 1; i <= doc.pageCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render();
      final img = await pageImage.createImageIfNotAvailable();
      final byteData = await img.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        images.add(byteData.buffer.asUint8List());
      }
    }

    await doc.dispose();
    return images;
  }
}

class _RemoveAction {
  final int index;
  final Uint8List image;

  _RemoveAction(this.index, this.image);
}
