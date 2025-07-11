import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:visionscan/presentation/screens/qr/screen_code_generate.dart';
import 'package:visionscan/presentation/screens/qr/screen_qr_history.dart';
import '../../../data/sources.dart';
import 'package:visionscan/vision.dart';

import 'screen_qr_scanner.dart';

class ScreenQRDashboard extends StatefulWidget {
  const ScreenQRDashboard({super.key});

  @override
  State<ScreenQRDashboard> createState() => _ScreenQrDashboardState();
}

class _ScreenQrDashboardState extends State<ScreenQRDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(
        title: context.localization?.tool_qr_code_scanner ?? '',
        onBack: () => Get.back(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.scale(12)),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                Get.to(ScreenQrHistory());
              },
              icon: Icon(Icons.history, color: colorText, size: context.scale(24)),
            ),
          ),
        ],
      ),
      body: _buildList(context),
      floatingActionButton: Container(
        margin: EdgeInsets.all(context.scale(12)),
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(ScreenQRScanner());
          },
          icon: Icon(Icons.qr_code_scanner_rounded, color: colorAccentText),
          label: Text(context.localization?.action_scan ?? 'Scan', style: context.bodyBoldLarge.copyWith(color: colorAccentText)),
          backgroundColor: colorAccent,
          elevation: context.scale(2),
          highlightElevation: context.scale(4),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final qrList = qrCodeList(context);
    final qrItems = qrList.where((e) => e.type == 'qr').toList();
    final barcodeItems = qrList.where((e) => e.type == 'barcode').toList();

    return ListView(
      padding: EdgeInsets.all(context.scale(12)),
      children: [
        _buildCategorySection(context, context.localization?.label_qr_code ?? '', qrItems),
        SizedBox(height: context.scale(16)),
        _buildCategorySection(context, context.localization?.label_bar_code ?? '', barcodeItems),
        SizedBox(height: context.scale(84)),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, List<QRCode> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.bodyBoldLarge),
        SizedBox(height: context.scale(12)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: context.scale(12),
            mainAxisSpacing: context.scale(12),
            childAspectRatio: 1 / 1,
          ),
          itemBuilder: (context, index) {
            final tool = items[index];
            return GestureDetector(
              onTap: () {
                Get.to(ScreenCodeGenerate(type: tool.type ?? '', title: tool.title ?? ''));
              },
              child: AppContainer(
                padding: EdgeInsets.all(context.scale(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(tool.icon ?? '', width: context.scale(48), height: context.scale(48)),
                    SizedBox(height: context.scale(16)),
                    Text(tool.title ?? '', style: context.bodyBoldMedium, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
