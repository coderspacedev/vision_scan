import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:visionscan/vision.dart';

class ScreenReorderPdfPages extends StatefulWidget {
  final File? selectedFile;

  const ScreenReorderPdfPages({super.key, required this.selectedFile});

  @override
  State<ScreenReorderPdfPages> createState() => _ScreenReorderPdfPagesState();
}

class _ScreenReorderPdfPagesState extends State<ScreenReorderPdfPages> {
  File? selectedFile;
  List<Uint8List> pageImages = [];
  List<int> pageOrder = [];
  bool isLoading = false;
  bool isProcessing = false;

  List<int> order = [];
  int? _draggingIndex;

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
      appBar: AppAppBar(title: context.localization?.tool_reorder_pdf ?? 'Reorder PDF', onBack: () => Get.back()),
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
                    padding: EdgeInsets.all(context.scale(12)),
                    child: GridView.builder(
                      itemCount: order.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: context.scale(12),
                        crossAxisSpacing: context.scale(12),
                        childAspectRatio: context.scale(100) / context.scale(140),
                      ),
                      itemBuilder: (context, index) {
                        final img = pageImages[order[index]];
                        final actualIndex = order[index];
                        final isDragging = _draggingIndex == actualIndex;
                        return LongPressDraggable<int>(
                          data: actualIndex,
                          onDragStarted: () => setState(() => _draggingIndex = actualIndex),
                          onDragCompleted: () => setState(() => _draggingIndex = null),
                          onDraggableCanceled: (_, __) => setState(() => _draggingIndex = null),
                          feedback: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                              width: context.scale(100),
                              height: context.scale(140),
                              child: Transform.scale(scale: 0.9, child: _buildThumbnail(img, borderColor: Colors.blue)),
                            ),
                          ),
                          childWhenDragging: Opacity(opacity: 0.2, child: _buildThumbnail(img)),
                          child: DragTarget<int>(
                            onWillAcceptWithDetails: (DragTargetDetails<int> details) {
                              final fromIndex = details.data;
                              return fromIndex != actualIndex;
                            },
                            onAcceptWithDetails: (DragTargetDetails<int> details) {
                              final fromIndex = details.data;
                              _reorder(order.indexOf(fromIndex), index);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return AnimatedScale(
                                scale: isDragging ? 0.9 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: _buildThumbnail(img),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
    );
  }

  Widget _buildThumbnail(Uint8List img, {Color borderColor = Colors.grey}) {
    return AppContainer(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: context.scale(1)),
        borderRadius: BorderRadius.circular(context.scale(0)),
        color: colorCard,
      ),
      child: Image.memory(img, fit: BoxFit.contain),
    );
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
    print('==> ${images.length}');
    return images;
  }

  Widget _buildBottomButtons() {
    final isDisabled = pageImages.isNotEmpty || isLoading;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(12)),
        child: AppButton(
          width: double.infinity,
          text: context.localization?.action_reorder_pages ?? 'Reorder',
          isLoading: isLoading,
          style: context.bodyBoldMedium,
          textColor: colorAccentText,
          onPressed: isDisabled ? null : () => _handleReorder,
        ),
      ),
    );
  }

  Future<void> _handleReorder() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    try {
      final outputFile = await reorderPdfPages(originalFile: selectedFile!, newOrder: pageOrder);

      if (outputFile.existsSync()) {
        showMessage('Success', 'Reorder completed. Files saved.');
      } else {
        showMessage('Failed', 'Reorder failed.');
      }
    } catch (e) {
      showMessage('Error', 'Reorder error: $e');
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
      pageOrder = List.generate(images.length, (i) => i + 1);
      isLoading = false;
      isProcessing = false;
      order = List.generate(pageImages.length, (index) => index);
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    setState(() {
      final item = order.removeAt(oldIndex);
      order.insert(newIndex, item);
      pageOrder = order.map((i) => i + 1).toList();
    });
  }
}
