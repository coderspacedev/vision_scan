import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:visionscan/vision.dart';

class ScreenQrGenerateResult extends StatefulWidget {
  final String qrContent;
  final String type;

  const ScreenQrGenerateResult({super.key, required this.qrContent, required this.type});

  @override
  State<ScreenQrGenerateResult> createState() => _ScreenQrGenerateResultState();
}

class _ScreenQrGenerateResultState extends State<ScreenQrGenerateResult> {
  final GlobalKey qrKey = GlobalKey();
  String selectedStyle = 'Smooth';
  String selectedFillStyle = 'Color';

  int selectedColorIndex = 0;
  int selectedGradientIndex = 0;
  bool isRounded = true;

  final List<Color> qrForegroundColors = [
    Colors.black,
    Colors.blueGrey,
    Colors.indigo,
    Colors.deepPurple,
    Colors.teal,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.brown,
  ];

  final List<LinearGradient> gradientOptions = [
    LinearGradient(colors: [Colors.teal.shade200, Colors.blue.shade200, Colors.red.shade200]),
    LinearGradient(colors: [Colors.indigo.shade300, Colors.purple.shade300, Colors.pink.shade200]),
    LinearGradient(colors: [Colors.blue.shade400, Colors.cyan.shade300, Colors.lightGreen.shade300]),
    LinearGradient(colors: [Colors.orange.shade300, Colors.amber.shade300, Colors.yellow.shade200]),
    LinearGradient(colors: [Colors.deepPurple.shade300, Colors.indigo.shade300, Colors.blueGrey.shade300]),
    LinearGradient(colors: [Colors.green.shade400, Colors.lime.shade300, Colors.yellow.shade200]),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertScanCodeHistory(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.scale(16);
    final isColor = selectedFillStyle == 'Color';
    final items = isColor ? qrForegroundColors : gradientOptions;
    final selectedIndex = isColor ? selectedColorIndex : selectedGradientIndex;

    final PrettyQrBrush brush = isColor
        ? PrettyQrBrush.from(qrForegroundColors[selectedColorIndex])
        : PrettyQrBrush.gradient(gradient: gradientOptions[selectedGradientIndex]);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: '', onBack: () => Get.back()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scale(68)),
                    child: AppContainer(
                      margin: EdgeInsets.all(context.scale(12)),
                      padding: EdgeInsets.all(context.scale(4)),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(context.scale(12)),
                        child: RepaintBoundary(
                          key: qrKey,
                          child: PrettyQrView.data(
                            data: widget.qrContent,
                            decoration: PrettyQrDecoration(
                              background: Colors.white,
                              quietZone: PrettyQrQuietZone.standart,
                              shape: selectedStyle == 'Rounded'
                                  ? PrettyQrRoundedSymbol(color: brush, borderRadius: BorderRadius.circular(context.scale(isRounded ? 12 : 0)))
                                  : PrettyQrSmoothSymbol(color: brush, roundFactor: isRounded ? 1 : 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: padding),
                  AppContainer(
                    height: context.scale(1),
                    margin: EdgeInsets.symmetric(horizontal: padding),
                  ),
                  SizedBox(height: padding),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Rounded Corners"),
                        CupertinoSwitch(value: isRounded, activeTrackColor: colorAccent, onChanged: (val) => setState(() => isRounded = val)),
                      ],
                    ),
                  ),
                  SizedBox(height: padding),

                  // Style Dropdown
                  _buildDropdown(
                    label: 'Style:',
                    value: selectedStyle,
                    items: ['Smooth', 'Rounded'],
                    onChanged: (val) => setState(() => selectedStyle = val!),
                  ),

                  // Fill Style Dropdown
                  _buildDropdown(
                    label: 'Brush',
                    value: selectedFillStyle,
                    items: ['Color', 'Gradient'],
                    onChanged: (val) => setState(() => selectedFillStyle = val!),
                  ),

                  // Color/Gradient Picker
                  GridView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: context.scale(12),
                      mainAxisSpacing: context.scale(12),
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isColor) {
                            selectedColorIndex = index;
                          } else {
                            selectedGradientIndex = index;
                          }
                        }),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: AppContainer(
                                decoration: BoxDecoration(
                                  color: isColor ? qrForegroundColors[index] : null,
                                  gradient: isColor ? null : gradientOptions[index],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            if (isSelected) const Positioned.fill(child: Icon(Icons.check_rounded, color: colorPrimary)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.fromLTRB(context.scale(24), context.scale(24), context.scale(24), context.paddingBottom + context.scale(12)),
            child: AppButton(width: double.infinity, text: context.localization?.action_save ?? '', onPressed: _saveQrImage),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
          child: Text(label, style: context.bodyMediumLarge),
        ),
        SizedBox(height: context.scale(4)),
        AppContainer(
          margin: EdgeInsets.symmetric(horizontal: context.scale(12)),
          padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            elevation: 2,
            dropdownColor: colorCard,
            borderRadius: BorderRadius.circular(context.scale(8)),
            style: context.bodyLarge,
            padding: EdgeInsets.zero,
            underline: const SizedBox.shrink(),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: context.bodyLarge),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: context.scale(12)),
      ],
    );
  }

  void showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? '', style: context.bodyMediumLarge),
        backgroundColor: colorCard,
      ),
    );
  }

  Future<void> _saveQrImage() async {
    try {
      await Permission.photos.request();
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null) {
        final dir = await getTemporaryDirectory();
        final file = await File('${dir.path}/qr_code.png').writeAsBytes(pngBytes);
        final success = await GallerySaver.saveImage(file.path, albumName: 'VisionScan');
        debugPrint(success == true ? "✅ Saved to gallery!" : "❌ Failed to save.");
        showMessage("✅ Saved to gallery!");
      }
    } catch (e) {
      debugPrint("❌ Error saving image: $e");
    }
  }

  String detectQRType(String value, {required BuildContext context}) {
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return context.localization?.scan_type_url ?? 'URL';
    } else if (lower.startsWith('mailto:')) {
      return context.localization?.scan_type_email ?? 'Email';
    } else if (lower.startsWith('tel:')) {
      return context.localization?.scan_type_phone ?? 'Phone';
    } else if (lower.startsWith('sms:')) {
      return context.localization?.scan_type_sms ?? 'SMS';
    } else if (lower.startsWith('wifi:')) {
      return context.localization?.scan_type_wifi ?? 'WiFi';
    } else if (lower.startsWith('geo:')) {
      return context.localization?.scan_type_geo ?? 'Geo Location';
    } else if (lower.startsWith('begin:vcard') || lower.contains('mecard:')) {
      return context.localization?.scan_type_contact ?? 'Contact';
    } else if (lower.contains('begin:VEVENT'.toLowerCase())) {
      return context.localization?.scan_type_event ?? 'Calendar Event';
    } else if (RegExp(r'^[0-9]{8,}$').hasMatch(lower)) {
      return context.localization?.scan_type_barcode ?? 'Product Code / Barcode';
    } else {
      return context.localization?.scan_type_text ?? 'Text';
    }
  }

  IconData getQRTypeIcon(String value) {
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return Icons.link;
    } else if (lower.startsWith('mailto:')) {
      return Icons.email;
    } else if (lower.startsWith('tel:')) {
      return Icons.phone;
    } else if (lower.startsWith('sms:')) {
      return Icons.sms;
    } else if (lower.startsWith('wifi:')) {
      return Icons.wifi;
    } else if (lower.startsWith('geo:')) {
      return Icons.location_on;
    } else if (lower.startsWith('begin:vcard') || lower.contains('mecard:')) {
      return Icons.contacts;
    } else if (lower.contains('begin:VEVENT'.toLowerCase())) {
      return Icons.event;
    } else if (RegExp(r'^[0-9]{8,}$').hasMatch(lower)) {
      return Icons.qr_code_2;
    } else {
      return Icons.text_fields;
    }
  }

  Future<void> insertScanCodeHistory({required BuildContext context}) async {
    final database = await $FloorAppDatabase.databaseBuilder('qr_history.db').build();

    final dao = database.qrHistoryDao;
    await dao.insertHistory(
      QrHistory(
        qrContent: widget.qrContent,
        type: widget.type,
        style: '',
        color: '',
        brushType: '',
        isCornered: false,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        historyType: 'generate',
      ),
    );
  }
}
