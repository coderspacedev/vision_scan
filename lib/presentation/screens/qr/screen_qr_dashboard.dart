import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visionscan/extensions/app_router_navigation.dart';
import 'package:visionscan/navigation/routes.dart';
import 'package:visionscan/vision.dart';

import '../../../data/sources.dart';

class ScreenQRDashboard extends StatefulWidget {
  const ScreenQRDashboard({super.key});

  @override
  State<ScreenQRDashboard> createState() => _ScreenQrDashboardState();
}

class _ScreenQrDashboardState extends State<ScreenQRDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      appBar: AppAppBar(
        title: context.localization?.tool_qr_code_scanner ?? '',
        onBack: () => context.pop(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.scale(12)),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                context.navigateTo(Routes.qrHistory);
              },
              icon: Icon(Icons.history, color: AppTheme.colors.text, size: context.scale(24)),
            ),
          ),
        ],
      ),
      body: _buildList(context),
      floatingActionButton: Container(
        margin: EdgeInsets.all(context.scale(12)),
        child: FloatingActionButton.extended(
          onPressed: () {
            context.navigateTo(Routes.qrScanner);
          },
          icon: Icon(Icons.qr_code_scanner_rounded, color: AppTheme.colors.accentText),
          label: Text(context.localization?.action_scan ?? 'Scan', style: context.bodyBoldLarge.copyWith(color: AppTheme.colors.accentText)),
          backgroundColor: AppTheme.colors.accent,
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
                context.navigateToObject(Routes.qrGenerate, {"type": tool.type ?? '', "title": tool.title ?? ''});
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
